package com.truelayer.RNTrueLayerPaymentsSDK

import com.facebook.react.bridge.ReadableMap

fun ReadableMap.getBooleanOrNull(key: String): Boolean? {
    return if (hasKey(key)) getBoolean(key) else null
}

fun ReadableMap.getIntOrNull(key: String): Int? {
    return if (hasKey(key)) getInt(key) else null
}