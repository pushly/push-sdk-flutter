import Pushly
import Flutter
import UIKit

internal class UserProfileDelegate: NSObject, FlutterPlugin {
    
    private let channel: FlutterMethodChannel
    private let binaryMessenger: FlutterBinaryMessenger
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let instance = UserProfileDelegate(binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel)
    }
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
        channel = FlutterMethodChannel(name: "PushSDK#UserProfile", binaryMessenger: binaryMessenger)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        PNLogs.debug("iOS Flutter bridge received method call: \(call.method) with args \(String(describing: call.arguments))")
        let args: [String: Any?] = (call.arguments as? Dictionary<String, Any?>) ?? [:]
        
        switch call.method {
        case "get":
            let profile = PushSDK.UserProfile.dict()
            PNLogs.debug("Sending UserProfile#get with value: \(profile)")
            result(profile)
        case "setExternalId":
            PushSDK.UserProfile.externalId = args["externalId"] as! String
            result(nil)
        case "append":
            PushSDK.UserProfile.append(args["values"] as! [Any], to: args["key"] as! String)
            result(nil)
        case "set":
            PushSDK.UserProfile.set(args["value"]!!, forKey: args["key"] as! String)
            result(nil)
        case "setData":
            PushSDK.UserProfile.set(args["data"] as! [String: Any])
            result(nil)
        case "remove":
            PushSDK.UserProfile.remove(args["values"] as! [Any], from: args["key"] as! String)
            result(nil)
        case "trackActivity":
            if let tags = args["tags"] as? [String] {
                PushSDK.UserProfile.trackActivity(name: args["name"] as! String, withTags: tags)
            } else {
                PushSDK.UserProfile.trackActivity(name: args["name"] as! String)
            }
            result(nil)
        case "requestUserDeletion":
            PushSDK.UserProfile.requestUserDeletion()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

