package com.svarnew.app

import android.media.MediaExtractor
import android.media.MediaFormat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer

class MainActivity: FlutterActivity() {
    private val CHANNEL = "audio_sample_extractor"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAudioSamples") {
                val filePath = call.argument<String>("filePath")
                val samples = extractAudioSamples(filePath)
                result.success(samples)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun extractAudioSamples(filePath: String?): List<Double> {
        val samples = mutableListOf<Double>()
        val extractor = MediaExtractor()
        extractor.setDataSource(filePath!!)

        val format = extractor.getTrackFormat(0)
        extractor.selectTrack(0)

        val bufferSize = format.getInteger(MediaFormat.KEY_MAX_INPUT_SIZE)
        val buffer = ByteBuffer.allocate(bufferSize)
        while (extractor.readSampleData(buffer, 0) >= 0) {
            buffer.rewind()
            while (buffer.hasRemaining()) {
                samples.add(buffer.get().toDouble())
            }
            buffer.clear()
            extractor.advance()
        }
        extractor.release()

        return samples
    }
}
