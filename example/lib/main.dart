import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

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
  UserProfile? _userProfile;
  String? _externalId;

  @override
  void initState() {
    super.initState();
    initializePushSDK();
  }

  Future<void> initializePushSDK() async {
    if (!mounted) return;

    await trackNotificationLifecycleCallbacks();
    await trackPermissionCallbacks();

    await PushSDK.setLogLevel(PNLogLevel.info);
    await PushSDK.setConfiguration('REPLACE_WITH_SDK_KEY');

    final prefs = await SharedPreferences.getInstance();
    _externalId = prefs.getString("externalId");

    if (_externalId == null) {
      _externalId = generateRandomString(8);
      await prefs.setString("externalId", _externalId!);
      await PushSDK.UserProfile.setExternalId(_externalId!);
    }

    await PushSDK.showNativeNotificationPermissionPrompt(completion: (granted, status, error) {
      if (granted == true) {
        print('Permissions granted: $granted');
        getUserProfile();
      }
    });
  }

  Future<void> getUserProfile() async {
    final profile = await PushSDK.UserProfile.get();

    setState(() {
      _userProfile = profile;
    });
  }

  Future<void> trackPermissionCallbacks() {
    return PushSDK.registerPermissionLifecycleCallbacks(
      onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken: (token) {
        print('User received device token: $token');
        getUserProfile();
      },
    );
  }

  Future<void> trackNotificationLifecycleCallbacks() {
    return PushSDK.registerNotificationLifecycleCallbacks(
      onPushSDKDidReceiveNotificationDestination: (destination, interaction) {
        print('Received notification click destination: $destination');
        return false;
      },
    );
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
              Text('Anonymous ID:\n${_userProfile?.anonymousId ?? 'Not Available'}\n', textAlign: TextAlign.center),
              Text('External ID:\n${_userProfile?.externalId ?? 'Setting: $_externalId'}\n', textAlign: TextAlign.center),
              Text('Subscription Status:\n${_userProfile?.subscriberStatus.name ?? 'Loading...'}\n', textAlign: TextAlign.center),
              Text('Token:\n${_userProfile?.token ?? 'Not Available'}\n', textAlign: TextAlign.center),
            ]
          )
        ),
      ),
    );
  }
}
