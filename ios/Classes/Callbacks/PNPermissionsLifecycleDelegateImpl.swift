import Foundation
import Pushly

internal class PNPermissionsLifecycleDelegateImpl : PNPermissionsLifecycleDelegate {
    
    private let channel: FlutterMethodChannel
    private let binaryMessenger: FlutterBinaryMessenger
    
    init(channel: FlutterMethodChannel, binaryMessenger: FlutterBinaryMessenger) {
        self.channel = channel
        self.binaryMessenger = binaryMessenger
    }
    
    func pushSDK(didReceivePermissionResponse granted: Bool, withSettings settings: UNNotificationSettings) {
        let status = parsePermissionResponse(granted: granted, withSettings: settings)
        channel.invokeMethod("PNPermissionLifecycleCallbacks.onPushSDKDidReceivePermissionResponse", arguments: ["response": status])
    }

    func pushSDK(didReceivePermissionResponse granted: Bool, withSettings settings: UNNotificationSettings, withError: Error) {
        let status = parsePermissionResponse(granted: granted, withSettings: settings)
        channel.invokeMethod("PNPermissionLifecycleCallbacks.onPushSDKDidReceivePermissionResponse", arguments: ["response": status])
    }

    func pushSDK(didReceivePermissionStatusChange status: UNAuthorizationStatus, withSettings settings: UNNotificationSettings) {
        var authorizationStatus = ""
        switch status {
        case .authorized, .ephemeral, .provisional:
            authorizationStatus = "GRANTED"
        case .notDetermined:
            authorizationStatus = "DISMISSED"
        default:
            authorizationStatus = "DENIED"
        }
        channel.invokeMethod("PNPermissionLifecycleCallbacks.onPushSDKDidReceivePermissionStatusChange", arguments: ["response": authorizationStatus])
    }

    func pushSDK(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: String) {
        channel.invokeMethod("PNPermissionLifecycleCallbacks.onPushSDKDidRegisterForRemoteNotificationsWithDeviceToken", arguments: ["deviceToken": deviceToken])
    }

    func pushSDK(didFailToRegisterForRemoteNotificationsWithError error: Error) {
        channel.invokeMethod("PNPermissionLifecycleCallbacks.onPushSDKDidFailToRegisterForRemoteNotificationsWithError", arguments: ["error": error.localizedDescription])
    }
}
