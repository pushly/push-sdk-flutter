import Pushly

internal class PNPushSDKLifecycleDelegateImpl : PNPushSDKLifecycleDelegate {
    
    private let channel: FlutterMethodChannel
    private let binaryMessenger: FlutterBinaryMessenger
    
    init(channel: FlutterMethodChannel, binaryMessenger: FlutterBinaryMessenger) {
        self.channel = channel
        self.binaryMessenger = binaryMessenger
    }
    
    func pushSDK(didFinishLoading configuration: Pushly.PNApplicationConfig, withNotificationSettings settings: UNNotificationSettings) {
        var data: [String: Any?] = configuration.toSimpleObject()
        data["subscriberStatus"] = PushSDK.UserProfile.subscriberStatus.rawValue
        channel.invokeMethod(
            "PNPushSDKLifecycleCallbacks.onPushSDKDidFinishLoading",
            arguments: data
        )
    }
    
    func pushSDK(didExitWithSubscriberStatus status: Pushly.PNSubscriberStatus, withDeletedState deleted: Bool) {
        channel.invokeMethod("PNPushSDKLifecycleCallbacks.onPushSDKDidExitWithSubscriberStatus", arguments: ["subscriberStatus": status.rawValue, "deleted": deleted])
    }
}
