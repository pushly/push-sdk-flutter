import Flutter
import UIKit
import Pushly

internal let MODULE_VERSION = "1.0.0"
internal let PNLogs = PNLogger(name: "PushSDK SWBridge")

public class SwiftPushlyPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      PushSDK.setEventSourceApplication(PNEventSourceApplication(name: "pushly-sdk-flutter", version: MODULE_VERSION))
      PushSDKDelegate.register(with: registrar)
      UserProfileDelegate.register(with: registrar)
      ECommDelegate.register(with: registrar)
      
      // TODO: neeed to get rid of this - it's auto generated on project setup and not used
      let channel = FlutterMethodChannel(name: "pushsdk", binaryMessenger: registrar.messenger())
      let instance = SwiftPushlyPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
