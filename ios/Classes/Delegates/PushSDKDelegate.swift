import Pushly
import Flutter
import UIKit

internal class PushSDKDelegate: NSObject, FlutterPlugin {
    
    private let channel: FlutterMethodChannel
    private let binaryMessenger: FlutterBinaryMessenger
    
    private static var pushSdkConfigured = false
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let instance = PushSDKDelegate(binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel)
    }
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
        channel = FlutterMethodChannel(name: "PushSDK", binaryMessenger: binaryMessenger)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        PNLogs.debug("Received method call: \(call.method) with args \(String(describing: call.arguments))")
        let args: [String: Any?] = (call.arguments as? Dictionary<String, Any?>) ?? [:]
        
        switch call.method {
        case "setLogLevel":
            let level = args["level"] as? String
            let logLevel: PNLogLevel
            switch (level?.uppercased()) {
                case "VERBOSE": logLevel = PNLogLevel.verbose; break
                case "DEBUG": logLevel = PNLogLevel.debug; break
                case "INFO": logLevel = PNLogLevel.info; break
                case "WARN": logLevel = PNLogLevel.warn; break
                case "ERROR": logLevel = PNLogLevel.error; break
                case "CRITICAL": logLevel = PNLogLevel.critical; break
                case "NONE": fallthrough
                default: logLevel = PNLogLevel.none
            }
            PNLogs.logLevel = logLevel
            PushSDK.logLevel = logLevel
            result(nil)
        case "registerPushSDKLifecycleCallbacks":
            PushSDK.setSDKLifecycleDelegate(PNPushSDKLifecycleDelegateImpl(channel: channel, binaryMessenger: binaryMessenger))
            result(nil)
        case "registerNotificationLifecycleCallbacks":
            PushSDK.setNotificationLifecycleDelegate(PushSDKNativeNotificationLifecycleDelegate(channel: channel, binaryMessenger: binaryMessenger))
            result(nil)
        case "registerPermissionLifecycleCallbacks":
            PushSDK.setPermissionsLifecycleDelegate(PNPermissionsLifecycleDelegateImpl(channel: channel, binaryMessenger: binaryMessenger))
            result(nil)
        case "setConfiguration":
            if !PushSDKDelegate.pushSdkConfigured {
                PNLogs.verbose("Configuring Flutter PushSDK")
                PushSDK.setConfiguration(appKey: args["appKey"] as! String, withLaunchOptions: nil)
                PushSDKDelegate.pushSdkConfigured = true
            } else {
                PNLogs.warn("Flutter PushSDK already initialized. Please ensure setConfiguration is only called once.")
            }
            result(nil)
        case "showNativeNotificationPermissionPrompt":
            PushSDK.showNativeNotificationPermissionPrompt({ [unowned self] granted, settings, err in
                let status = parsePermissionResponse(granted: granted, withSettings: settings)
                self.channel.invokeMethod("showNativeNotificationPermissionPromptCallback", arguments: ["granted": granted, "status": status, "error": err?.localizedDescription])
            }, skipConditionsEvaluation: args["skipConditionsEvaluation"] as! Bool, skipFrequencyCapEvaluation: args["skipFrequencyCapEvaluation"] as! Bool)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

