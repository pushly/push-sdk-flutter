import 'package:flutter/services.dart';
import 'package:pushly_pushsdk/pushsdk.dart';
import 'package:pushly_pushsdk/src/models.dart';

class UserProfileImpl {

  final MethodChannel _channel = const MethodChannel('PushSDK#UserProfile');

  UserProfileImpl(){
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> setExternalId(String externalId) {
    return _channel.invokeMethod("setExternalId", {'externalId': externalId});    
  }

  Future<void> append(String key, List<dynamic> values) {
    return _channel.invokeMethod("append", {'key': key, 'values': values});    
  }

  Future<void> set(String key, dynamic value) {
    return _channel.invokeMethod("set", {'key': key, 'value': value});    
  }

  Future<void> setData(Map<String, dynamic> data) {
    return _channel.invokeMethod("setData", {'data': data});    
  }

  Future<void> remove(String key, List<dynamic> values) {
    return _channel.invokeMethod("remove", {'key': key, 'values': values});    
  }

  Future<void> trackActivity(String name, List<String> tags) {
    return _channel.invokeMethod("trackActivity", {'name': name, 'tags': tags});    
  }

  Future<void> requestUserDeletion() {
    return _channel.invokeMethod("requestUserDeletion");    
  }

  Future<UserProfile> get() {
    return _channel.invokeMethod("get", null).then((value) => UserProfile(value.cast<String, dynamic>()));
  }

  Future<String?> getExternalId() {
    return get().then((value) => value.externalId);
  }

  Future<String> getAnonymousId() {
    return get().then((value) => value.anonymousId);
  }

  Future<bool> isDeleted() {
    return get().then((value) => value.isDeleted);
  }

  Future<bool> isEligibleToPrompt() {
    return get().then((value) => value.isEligibleToPrompt);
  }

  Future<bool> isSubscribed() {
    return get().then((value) => value.isSubscribed);
  }

  Future<PNSubscriberStatus> subscriberStatus() {
    return get().then((value) => value.subscriberStatus);
  }

  Future<void> _handleMethod(MethodCall call) async {
    // no-op
  }
}