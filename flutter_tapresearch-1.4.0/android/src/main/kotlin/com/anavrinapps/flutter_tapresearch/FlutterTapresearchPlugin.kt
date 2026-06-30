package com.anavrinapps.flutter_tapresearch

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

// TapResearch SDK 3.x.
// NOTE: package paths below follow the 3.x docs; verify against the artifact
// you resolve (`com.tapresearch:tapsdk`) and adjust imports if they differ.
import com.tapresearch.tapsdk.TapResearch
import com.tapresearch.tapsdk.callback.TRContentCallback
import com.tapresearch.tapsdk.models.TRError
import com.tapresearch.tapsdk.models.TRReward

/**
 * Flutter bridge for the TapResearch SDK 3.x.
 *
 * The 3.x SDK requires both an api token and a user identifier at
 * initialization, uses string placement tags, and delivers rewards as a
 * batched list. See [TapResearch] (lib/flutter_tapresearch.dart) for the Dart
 * side of the protocol.
 */
class FlutterTapresearchPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var appContext: Context? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "flutter_tapresearch")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initialize" -> initialize(call, result)
            "isReady" -> result.success(TapResearch.isReady())
            "canShowContentForPlacement" -> {
                val tag = call.argument<String>("placementTag") ?: ""
                result.success(TapResearch.canShowContentForPlacement(tag) { error ->
                    invokeOnMain("onError", errorMap(error))
                })
            }
            "showContentForPlacement" -> showContent(call, result)
            "setUserIdentifier" -> {
                val userId = call.argument<String>("userIdentifier") ?: ""
                TapResearch.setUserIdentifier(userId) { error ->
                    invokeOnMain("onError", errorMap(error))
                }
                result.success(null)
            }
            "sendUserAttributes" -> {
                val attrs = call.argument<Map<String, Any>>("attributes") ?: emptyMap()
                TapResearch.sendUserAttributes(HashMap(attrs)) { error ->
                    invokeOnMain("onError", errorMap(error))
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun initialize(call: MethodCall, result: Result) {
        val apiToken = call.argument<String>("apiToken")
        val userIdentifier = call.argument<String>("userIdentifier")
        val context = activity ?: appContext
        if (apiToken.isNullOrEmpty()) {
            result.error("no_api_token", "A null/empty api token was provided", null)
            return
        }
        if (userIdentifier.isNullOrEmpty()) {
            result.error("no_user_id", "A null/empty user identifier was provided", null)
            return
        }
        if (context == null) {
            result.error("no_context", "No Android context available for init", null)
            return
        }

        TapResearch.initialize(
            apiToken,
            userIdentifier,
            context,
            rewardCallback = { rewards -> invokeOnMain("onRewards", rewards.map(::rewardMap)) },
            errorCallback = { error -> invokeOnMain("onError", errorMap(error)) },
            sdkReadyCallback = { invokeOnMain("onSdkReady", null) }
        )
        result.success(null)
    }

    private fun showContent(call: MethodCall, result: Result) {
        val tag = call.argument<String>("placementTag") ?: ""
        val custom = call.argument<Map<String, Any>>("customParameters")
        val contentCallback = object : TRContentCallback {
            override fun onTapResearchContentShown(placementTag: String) {
                invokeOnMain("onContentShown", placementTag)
            }

            override fun onTapResearchContentDismissed(placementTag: String) {
                invokeOnMain("onContentDismissed", placementTag)
            }
        }
        TapResearch.showContentForPlacement(
            tag,
            if (custom != null) HashMap(custom) else null,
            contentCallback
        ) { error -> invokeOnMain("onError", errorMap(error)) }
        result.success(null)
    }

    private fun rewardMap(reward: TRReward): Map<String, Any?> = mapOf(
        "transactionIdentifier" to reward.transactionIdentifier,
        "placementIdentifier" to reward.placementIdentifier,
        "placementTag" to reward.placementTag,
        "currencyName" to reward.currencyName,
        "rewardAmount" to reward.rewardAmount,
        "payoutEventType" to reward.payoutEventType
    )

    private fun errorMap(error: TRError?): Map<String, Any?> = mapOf(
        "code" to (error?.code?.toString() ?: "unknown"),
        "message" to (error?.message ?: "")
    )

    /** MethodChannel callbacks must be delivered on the main thread. */
    private fun invokeOnMain(method: String, args: Any?) {
        mainHandler.post { channel.invokeMethod(method, args) }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
