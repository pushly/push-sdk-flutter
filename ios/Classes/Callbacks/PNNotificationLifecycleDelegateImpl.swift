import Pushly

internal class PushSDKNativeNotificationLifecycleDelegate: PNNotificationLifecycleDelegate {
    
    let channel: FlutterMethodChannel
    let binaryMessenger: FlutterBinaryMessenger
    
    init(channel: FlutterMethodChannel, binaryMessenger: FlutterBinaryMessenger) {
        self.channel = channel
        self.binaryMessenger = binaryMessenger
    }
    
    private func openDestinationURL(_ destinationURL: URL) {
        if UIApplication.shared.canOpenURL(destinationURL) {
            PNLogs.verbose("Opening destination: \(destinationURL)")
            UIApplication.shared.open(destinationURL, options: [:], completionHandler: nil)
        } else {
            PNLogs.verbose("Opening destination externally: \(destinationURL)")
            UIApplication.shared.open(destinationURL)
        }
    }
    
    func pushSDK(didReceiveNotification notification: PNNotification) {
        channel.invokeMethod("PNNotificationLifecycleCallbacks.onPushSDKDidReceiveNotification", arguments: notification.toSimpleObject())
    }
    
    func pushSDK(didReceiveNotificationDestination destination: String, withInteraction interaction: PNNotificationInteraction) -> Bool  {
        channel.invokeMethod("PNNotificationLifecycleCallbacks.onPushSDKDidReceiveNotificationDestination", arguments: [
            "destination": destination,
            "interaction": interaction.toSimpleObject()
        ]) { [unowned self] result in
            let value = (result as? NSNumber)?.boolValue ?? false
            
            PNLogs.verbose("Result \(value)")
            
            if !value {
                let url = URL(string: interaction.notification.landingURL)!
                switch interaction.actionIdentifier {
                case PNNotificationInteractionType.defaultAction.name:
                    fallthrough
                case PNNotificationInteractionType.customAction.name:
                    self.openDestinationURL(url)
                default:
                    PNLogs.debug("Ignoring dismiss action - handled in native SDK")
                }
            }
        }
        return true
    }
}
