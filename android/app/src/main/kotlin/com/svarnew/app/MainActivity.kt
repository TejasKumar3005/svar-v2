import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.UserManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "parental_control_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "checkParentalControlPIN") {
                val enteredPin: String? = call.argument("pin")
                val parentalControlEnabled = isParentalControlsEnabled(this)
                var pinMatches = false
                if (parentalControlEnabled) {
                    pinMatches = checkPINWithDeviceSettings(this, enteredPin)
                }
                result.success(pinMatches)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun isParentalControlsEnabled(context: Context): Boolean {
        val devicePolicyManager = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as? DevicePolicyManager
        return if (devicePolicyManager != null) {
            val adminComponent = ComponentName(context, MyDeviceAdminReceiver::class.java)
            devicePolicyManager.isProfileOwnerApp(context.packageName) && devicePolicyManager.hasUserRestriction(adminComponent, UserManager.DISALLOW_INSTALL_APPS)
        } else {
            false
        }
    }

    private fun checkPINWithDeviceSettings(context: Context, enteredPin: String?): Boolean {
        val parentalControlPIN = Settings.Secure.getString(context.contentResolver, Settings.Secure.PARENTAL_CONTROL_PIN)
        return !parentalControlPIN.isNullOrEmpty() && parentalControlPIN == enteredPin
    }


}

