package com.oxygendigitalshop.app.oxygen

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.IBinder
import android.util.Log
import android.widget.Toast
import com.oxygendigitalshop.app.appStateDestroy

class AppStateObserver: Service() {
    lateinit var sharedPreference: SharedPreferences
    lateinit var editor: SharedPreferences.Editor

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        sharedPreference = this.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        editor = sharedPreference.edit()
        editor.putBoolean(appStateDestroy, false)
        editor.commit()
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        editor.putBoolean(appStateDestroy, true)
        editor.commit()
        super.onDestroy()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        editor.putBoolean(appStateDestroy, true)
        editor.commit()
        stopSelf()
    }
}
