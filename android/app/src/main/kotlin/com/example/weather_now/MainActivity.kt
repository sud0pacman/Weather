package com.example.weather_now

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        super.onCreate(savedInstanceState)
    }
}
