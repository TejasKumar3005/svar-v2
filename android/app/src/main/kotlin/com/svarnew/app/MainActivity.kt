package com.svarnew.app

import android.os.Bundle
import com.google.firebase.appdistribution.FirebaseAppDistribution
import com.google.firebase.appdistribution.FirebaseAppDistributionException
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.svarnew.app/update"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
        //     if (call.method == "checkForUpdate") {
        //         checkForUpdate(result)
        //     } else {
        //         result.notImplemented()
        //     }
        // }
    }

    override fun onResume() {
        super.onResume()
        checkForUpdate()
    }

    private fun checkForUpdate() {
        val firebaseAppDistribution = FirebaseAppDistribution.getInstance()
        firebaseAppDistribution.updateIfNewReleaseAvailable()
            .addOnProgressListener { updateProgress ->
                // runOnUiThread {
                //     val totalBytes = updateProgress.apkFileTotalBytes ?: 1L // Ensure no division by zero
                //     val progress = updateProgress.apkBytesDownloaded / totalBytes.toDouble()
                //     MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("updateProgress", progress)
                // }
            }
            .addOnFailureListener { e ->
                // runOnUiThread {
                //     MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("updateFailed", e.message)
                // }
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
                // runOnUiThread {
                //     MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("updateSuccess", null)
                // }
            }
    }
}