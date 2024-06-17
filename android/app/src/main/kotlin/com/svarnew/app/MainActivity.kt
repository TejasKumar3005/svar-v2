

package com.svarnew.app
import android.util.Log
import android.os.Bundle
import com.google.firebase.appdistribution.FirebaseAppDistribution
import com.google.firebase.appdistribution.FirebaseAppDistributionException
import com.google.firebase.appdistribution.UpdateProgress
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.svarnew.app/update"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "checkForUpdate") {
                checkForUpdate(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun checkForUpdate(result: MethodChannel.Result) {
        val firebaseAppDistribution = FirebaseAppDistribution.getInstance()
        firebaseAppDistribution.updateIfNewReleaseAvailable()
            .addOnProgressListener { updateProgress ->
                runOnUiThread {
                    // Send progress updates back to Flutter
                    MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).invokeMethod("updateProgress", updateProgress.apkBytesDownloaded / updateProgress.apkTotalBytesToDownload)
                }
            }
            .addOnFailureListener { e ->
                runOnUiThread {
                    // Send error back to Flutter
                    MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).invokeMethod("updateFailed", e.message)
                }
                if (e is FirebaseAppDistributionException) {
                    when (e.errorCode) {
                        FirebaseAppDistributionException.Status.NOT_IMPLEMENTED -> {
                            // Handle specific error
                        }
                        else -> {
                            // Handle other errors
                        }
                    }
                }
            }
            .addOnSuccessListener {
                runOnUiThread {
                    // Send success back to Flutter
                    MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).invokeMethod("updateSuccess", null)
                }
            }
    }
}


