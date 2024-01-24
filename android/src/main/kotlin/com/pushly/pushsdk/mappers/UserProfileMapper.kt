package com.pushly.pushsdk.mappers

import com.pushly.android.UserProfile

fun UserProfile.toMap() = HashMap<String, Any?>().apply {
    putAll(
        pairs = listOf(
            "anonymousId" to anonymousId,
            "externalId" to externalId,
            "isDeleted" to isDeleted,
            "isEligibleToPrompt" to isEligibleToPrompt,
            "isSubscribed" to isSubscribed,
            "subscriberStatus" to subscriberStatus?.name,
            "token" to token
        )
    )
}
