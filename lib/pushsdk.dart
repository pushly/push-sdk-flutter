import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pushly_pushsdk/src/ecomm.dart';
import 'package:pushly_pushsdk/src/models.dart';
import 'package:pushly_pushsdk/src/enums.dart';
import 'package:pushly_pushsdk/src/userprofile.dart';

export 'src/enums.dart';
export 'src/models.dart';

class PushSDK {

  final MethodChannel _defaultChannel = const MethodChannel('PushSDK');

  PushSDK() {
    _defaultChannel.setMethodCallHandler(_handleMethod);
  }

  static PushSDK sdk = PushSDK();
  
  // ignore: non_constant_identifier_names
  static UserProfileImpl UserProfile = UserProfileImpl();
  // ignore: non_constant_identifier_names
  static ECommImpl EComm = ECommImpl();

  //PNPushSDKLifecycleCallbacks
  static Function(PNApplicationConfig configuration, PNSubscriberStatus subscriberStatus) _onPushSDKDidFinishLoading = (configuration, subscriberStatus) => false;
  static Function(PNSubscriberStatus subscriberStatus, bool deleted) _onPushSDKDidExitWithSubscriberStatus = (subscriberStatus, deleted) => {};

  // PNNotificationLifecycleCallbacks
  static Function(PNNotification notification) _onPushSDKDidReceiveNotification = (notification) => {};
  static bool Function(String destination, PNNotificationInteraction interaction) _onPushSDKDidReceiveNotificationDestination = (destination, interaction) => false;

  // Permission prompt completion callback
  static Function(bool? granted, PNPermissionResponse? status, Exception? error) _permissionCallback = (granted, status, error) => {}; 

  // PNPermissionLifecycleCallbacks
  static Function(PNPermissionResponse response) _onPushSDKDidReceivePermissionResponse = (response) => {};
  static Function(PNPermissionResponse response) _onPushSDKDidReceivePermissionStatusChange = (response) => {};
  static Function(String token) _onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken = (token) => {};
  static Function(Exception error) _onPushSDKDidFailToRegisterForRemoteNotificationsWithError =(error) => {};

  static Future<void> setLogLevel(PNLogLevel level) async {
    await sdk._defaultChannel.invokeMethod("setLogLevel", {'level': level.name});
  }
  
  static Future<void> setConfiguration(String appKey) async {
    await sdk._defaultChannel.invokeMethod("setConfiguration", {'appKey': appKey});
  }

  static Future<void> registerPushSDKLifecycleCallbacks({
      Function(PNApplicationConfig, PNSubscriberStatus)? onPushSDKDidFinishLoading,
      Function(PNSubscriberStatus, bool)? onPushSDKDidExitWithSubscriberStatus,
    }) {
      if (onPushSDKDidFinishLoading != null) {
        _onPushSDKDidFinishLoading = onPushSDKDidFinishLoading;
      }
      if (onPushSDKDidExitWithSubscriberStatus != null) {
        _onPushSDKDidExitWithSubscriberStatus = onPushSDKDidExitWithSubscriberStatus;
      }
      return sdk._defaultChannel.invokeMethod("registerPushSDKLifecycleCallbacks");
  }

  static Future<void> registerNotificationLifecycleCallbacks({
    Function(PNNotification)? onPushSDKDidReceiveNotification,
    bool Function(String, PNNotificationInteraction)? onPushSDKDidReceiveNotificationDestination,
  }) {
    if (onPushSDKDidReceiveNotification != null) {
      _onPushSDKDidReceiveNotification = onPushSDKDidReceiveNotification;
    }
    if (onPushSDKDidReceiveNotificationDestination != null) {
      _onPushSDKDidReceiveNotificationDestination = onPushSDKDidReceiveNotificationDestination;
    }
    return sdk._defaultChannel.invokeMethod("registerNotificationLifecycleCallbacks");
  }

  static Future<void> registerPermissionLifecycleCallbacks({
    Function(PNPermissionResponse)? onPushSDKDidReceivePermissionResponse,
    Function(PNPermissionResponse)? onPushSDKDidReceivePermissionStatusChange,
    Function(String)? onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken,
    Function(Exception)? onPushSDKDidFailToRegisterForRemoteNotificationsWithError,
  }) {
    if (onPushSDKDidReceivePermissionResponse != null) {
      _onPushSDKDidReceivePermissionResponse = onPushSDKDidReceivePermissionResponse;
    }
    if (onPushSDKDidReceivePermissionStatusChange != null) {
      _onPushSDKDidReceivePermissionStatusChange = onPushSDKDidReceivePermissionStatusChange;
    }
    if (onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken != null) {
      _onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken = onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken;
    }
    if (onPushSDKDidFailToRegisterForRemoteNotificationsWithError != null) {
      _onPushSDKDidFailToRegisterForRemoteNotificationsWithError = onPushSDKDidFailToRegisterForRemoteNotificationsWithError;
    }
    
    return sdk._defaultChannel.invokeMethod("registerPermissionLifecycleCallbacks");
  }

  static Future<void> showNativeNotificationPermissionPrompt(
    {
      Function(bool?, PNPermissionResponse?, Exception?)? completion,
      bool skipConditionsEvaluation = false,
      bool skipFrequencyCapEvaluation = false,
    }
  ) async {
    if (completion != null) {
      _permissionCallback = completion;
    }
    return sdk._defaultChannel.invokeMethod("showNativeNotificationPermissionPrompt", {'skipConditionsEvaluation': skipConditionsEvaluation, 'skipFrequencyCapEvaluation': skipFrequencyCapEvaluation});
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    Map<String, dynamic> args = call.arguments.cast<String, dynamic>();

    switch (call.method) {
      case 'PNPushSDKLifecycleCallbacks.onPushSDKDidFinishLoading':
        _onPushSDKDidFinishLoading(
          PNApplicationConfig(args), 
          PNSubscriberStatus.fromValue(args[PNSubscriberStatus.kSubscriberStatus]),
        );
        break;
      case 'PNPushSDKLifecycleCallbacks.onPushSDKDidExitWithSubscriberStatus':
        _onPushSDKDidExitWithSubscriberStatus(
          PNSubscriberStatus.fromValue(args[PNSubscriberStatus.kSubscriberStatus]),
          args['deleted'],
        );
        break;
      case 'PNNotificationLifecycleCallbacks.onPushSDKDidReceiveNotification':
        _onPushSDKDidReceiveNotification(PNNotification.create(args));
        break;
      case 'PNNotificationLifecycleCallbacks.onPushSDKDidReceiveNotificationDestination':
        PNNotificationInteraction interaction = PNNotificationInteraction(args["interaction"].cast<String, dynamic>());
        var result = _onPushSDKDidReceiveNotificationDestination(
          args['destination'],
          interaction,
        );
        return Future<bool>.value(result);
      case 'showNativeNotificationPermissionPromptCallback':
        var err = args['error'] != null ? Exception(args['error']) : null;
        _permissionCallback(
            args['granted'],
            PNPermissionResponse.fromValue(args['status']),
            err,
          );
        break;
      case 'PNPermissionLifecycleCallbacks.onPushSDKDidFailToRegisterForRemoteNotificationsWithError':
        _onPushSDKDidFailToRegisterForRemoteNotificationsWithError(Exception(args['error']));
        break;
      case 'PNPermissionLifecycleCallbacks.onPushSDKDidReceivePermissionResponse':
        _onPushSDKDidReceivePermissionResponse(PNPermissionResponse.fromValue(args['response']));
        break;
      case 'PNPermissionLifecycleCallbacks.onPushSDKDidReceivePermissionStatusChange':
        _onPushSDKDidReceivePermissionStatusChange(PNPermissionResponse.fromValue(args['response']));
        break;
      case 'PNPermissionLifecycleCallbacks.onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken':
        _onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken(args['deviceToken']);
        break;
    }
    return Future<void>.value();
  }
}
