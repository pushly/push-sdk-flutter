import Pushly

extension PushSDK.UserProfile {
    
    static func dict() -> [String: Any?] {
        return [
            "anonymousId": PushSDK.UserProfile.anonymousId,
            "externalId": PushSDK.UserProfile.externalId,
            "isDeleted": PushSDK.UserProfile.isDeleted,
            "isEligibleToPrompt": PushSDK.UserProfile.isEligibleToPrompt,
            "isSubscribed": PushSDK.UserProfile.isSubscribed,
            "subscriberStatus": "\(PushSDK.UserProfile.subscriberStatus.rawValue)",
            "token": PushSDK.UserProfile.token
        ]
    }
}

struct PNECommItemDecodable: Decodable {
    let id: String
    let quantity: Int
    
    static func decode(json: String) -> PNECommItem {
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(PNECommItemDecodable.self, from: json.data(using: .utf8)!)
        return PNECommItem(id: decoded.id, quantity: decoded.quantity)
    }
}

internal func parsePermissionResponse(granted: Bool, withSettings settings: UNNotificationSettings) -> String {
    switch ((granted, settings.authorizationStatus)) {
        case (true, _):
            return "GRANTED"
        case (false, .notDetermined):
            return "DISMISSED"
        default:
            return "DENIED"
    }
}
