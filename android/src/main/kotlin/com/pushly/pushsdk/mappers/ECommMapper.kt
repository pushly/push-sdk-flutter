package com.pushly.pushsdk.mappers

import com.pushly.android.models.PNECommItem
import org.json.JSONObject

typealias PNECommMap = String

fun PNECommMap.toModel(): PNECommItem {
    val json = JSONObject(this)
    return PNECommItem(
        id = json.get("id") as String,
        quantity = json.get("quantity") as Int
    )
}
