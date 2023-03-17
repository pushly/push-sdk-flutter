import Pushly
import Flutter
import UIKit

internal class ECommDelegate: NSObject, FlutterPlugin {
    
    private let channel: FlutterMethodChannel
    private let binaryMessenger: FlutterBinaryMessenger
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let instance = ECommDelegate(binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel)
    }
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
        channel = FlutterMethodChannel(name: "PushSDK#EComm", binaryMessenger: binaryMessenger)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        PNLogs.debug("iOS Flutter bridge received method call: \(call.method) with args \(String(describing: call.arguments))")
        let args: [String: Any?] = (call.arguments as? Dictionary<String, Any?>) ?? [:]
        
        switch call.method {
        case "addToCart":
            let items = (args["items"] as! [String]).map { PNECommItemDecodable.decode(json: $0) }
            PushSDK.EComm.addToCart(items: items)
            result(nil)
        case "updateCart":
            let items = (args["items"] as! [String]).map { PNECommItemDecodable.decode(json: $0) }
            PushSDK.EComm.updateCart(withItems: items)
            result(nil)
        case "clearCart":
            PushSDK.EComm.clearCart()
            result(nil)
        case "trackPurchase":
            PushSDK.EComm.trackPurchase()
            result(nil)
        case "trackPurchaseForId":
            let items = (args["items"] as! [String]).map { PNECommItemDecodable.decode(json: $0) }
            PushSDK.EComm.trackPurchase(of: items, withPurchaseId: args["purchaseId"] as? String, withPriceValue: args["priceValue"] as? String)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

