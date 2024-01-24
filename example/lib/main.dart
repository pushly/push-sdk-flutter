import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dt;

import 'package:pushly_pushsdk/pushsdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

String generateRandomString(int len) {
  final random = Random();
  const availableChars ='AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(len, (index) => availableChars[random.nextInt(availableChars.length)]).join();
  return randomString;
}

class MyApp extends StatefulWidget {
  
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PNApplicationConfig? _config;
  PNSubscriberStatus? _status;
  bool _deleted = false;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    initializeSdk();
  }

  Future<void> initializeSdk() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    String? externalId = prefs.getString("externalId");

    if (externalId == null) {
      externalId = generateRandomString(8);
      await prefs.setString("externalId", externalId);
    }

    await trackLifecycleCallbacks();
    await trackNotificationLifecycleCallbacks();
    await trackPermissionCallbacks();

    await PushSDK.setLogLevel(PNLogLevel.verbose);
    await PushSDK.setConfiguration("UjdYMswog2YLVmc9xs9O3GhdwglKnzIYb7hE");
    await PushSDK.UserProfile.setExternalId(externalId);

    getUserProfile();
    
  }

  Future<void> getUserProfile() {
    return PushSDK.UserProfile.get().then((value) => setState(() {
      _userProfile = value;
      _status = value.subscriberStatus;
      _deleted = value.isDeleted ?? false;
    }));
  }

  void showNativePermissionPrompt() async {
    await PushSDK.showNativeNotificationPermissionPrompt(completion: (granted, status, error) {
      if (granted == true) {
          getUserProfile();
        }
    });
  }

  Future<void> trackPermissionCallbacks() {
    return PushSDK.registerPermissionLifecycleCallbacks(
      onPushSDKDidReceivePermissionResponse:(permissionResponse) {
        dt.log(permissionResponse.value.toString());
      },
      onPushSDKDidReceivePermissionStatusChange: (permissionResponse) {
        dt.log(permissionResponse.value);
      },
      onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken:(deviceToken) {
        dt.log(deviceToken);
      },
      onPushSDKDidFailToRegisterForRemoteNotificationsWithError: (error) {
        dt.log(error.toString());
      }
    );
  }

  Future<void> trackLifecycleCallbacks() {
    return PushSDK.registerPushSDKLifecycleCallbacks(
      onPushSDKDidFinishLoading: (configuration, subscriberStatus) {
        dt.log("App callback onPushSDKDidFinishLoading #### Configuration: ${configuration.toString()}, status: $subscriberStatus");
        setState(() {
          _config = configuration;
          _status = subscriberStatus;
        });        
      },
      onPushSDKDidExitWithSubscriberStatus: (subscriberStatus, deleted) {
        dt.log("onPushSDKDidExitWithSubscriberStatus #### deleted: $deleted, status: $subscriberStatus");
        setState(() {
          _deleted = deleted;
          _status = subscriberStatus;
        });
      },
    );
  }

  Future<void> trackNotificationLifecycleCallbacks() {
    return PushSDK.registerNotificationLifecycleCallbacks(
      onPushSDKDidReceiveNotification: (notification) {
        dt.log("Flutter app: Received app notification = ${notification.toString()}");
        if (notification is PNAndroidNotification) {
          // process android specific notification fields
        } else if (notification is PNiOSNotification) {
          // process iOS specific notification fields
        }
      },
      onPushSDKDidReceiveNotificationDestination: (destination, interaction) {
        dt.log("Flutter app: Received Android notification destination = $destination for notification interaction: ${interaction.toString()}");
        return false;
      },
    );
  }

  void toggleUdr() {
    if (_userProfile?.isDeleted == false) {
      PushSDK.UserProfile.requestUserDeletion().then((_) => getUserProfile());
    } 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Status:\n${_status?.name}\n', textAlign: TextAlign.center),
              Text('Deleted:\n$_deleted\n', textAlign: TextAlign.center),
              Text('UserProfile#externalId:\n${_userProfile?.externalId}\n', textAlign: TextAlign.center),
              Text('UserProfile#anonymousId:\n${_userProfile?.anonymousId}\n', textAlign: TextAlign.center),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  showNativePermissionPrompt();
                }, 
                child: const Text('Prompt notification permission'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  toggleUdr();
                }, 
                child: const Text('Toggle UDR'),
              ),
            ]
          )
        ),
      ),
    );
  }
}
