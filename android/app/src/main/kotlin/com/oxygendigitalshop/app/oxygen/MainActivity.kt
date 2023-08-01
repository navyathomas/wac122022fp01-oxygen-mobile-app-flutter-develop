package com.oxygendigitalshop.app

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.SharedPreferences.Editor
import android.util.Log
import android.widget.Toast
import com.oxygendigitalshop.app.oxygen.AppStateObserver
import com.oxygendigitalshop.app.oxygen.NativeMethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private  val CHANNEL = "com.oxygendigitalshop.app"
    lateinit var sharedPreference: SharedPreferences
    lateinit var editor: SharedPreferences.Editor

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        startService(Intent(baseContext, AppStateObserver::class.java))
        super.configureFlutterEngine(flutterEngine)
        sharedPreference = this.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        editor = sharedPreference.edit()
        NativeMethodChannel.configureChannel(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when(call.method){
                "Oxygen#Notifications" -> {
                    editor.putInt("flutter.oxygenNotificationCount", 0)
                    editor.commit()
                }
//                "Oxygen#Notifications#ResetState" -> {
//                    editor.putBoolean(appStateDestroy, false)
//                    editor.commit()
//                }
            }


        }
    }
}

const val appStateDestroy: String = "appStateDestroy"


