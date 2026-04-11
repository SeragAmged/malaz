package com.example.malaz

import android.os.Build
import android.view.WindowManager
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onPostResume() {
        super.onPostResume()
        // Remove the native splash screen immediately when Flutter is ready
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            splashScreen.remove()
        }
    }
}
