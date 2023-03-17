import 'package:flutter/services.dart';
import 'package:pushly_pushsdk/src/models.dart';

class ECommImpl {

  final MethodChannel _channel = const MethodChannel('PushSDK#EComm');

  ECommImpl(){
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> addToCart(List<PNECommItem> items) {
    return _channel.invokeMethod("addToCart", {'items': items.map((e) => e.toJson()).toList()});    
  }

  Future<void> updateCart(List<PNECommItem> items) {
    return _channel.invokeMethod("updateCart", {'items': items.map((e) => e.toJson()).toList()});    
  }

  Future<void> clearCart() {
    return _channel.invokeMethod("clearCart");    
  } 

  Future<void> trackPurchase() {
    return _channel.invokeMethod("trackPurchase");    
  } 

  Future<void> trackPurchaseForId(List<PNECommItem> items, String? purchaseId, String? priceValue) {
    var data = {};
    
    data['items'] = items.map((e) => e.toJson()).toList();

    if (purchaseId != null) {
      data['purchaseId'] = purchaseId;
    }
    if (priceValue != null) {
      data['priceValue'] = priceValue;
    }
    return _channel.invokeMethod("trackPurchaseForId", data);    
  } 

  Future<void> _handleMethod(MethodCall call) async {
    // no-op
  }
}
