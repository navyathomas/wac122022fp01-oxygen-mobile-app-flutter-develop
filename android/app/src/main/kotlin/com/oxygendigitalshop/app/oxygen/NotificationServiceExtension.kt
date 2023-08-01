package com.oxygendigitalshop.app.oxygen

import android.content.Context
import android.content.SharedPreferences
import android.content.SharedPreferences.Editor
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import com.onesignal.OSNotificationReceivedEvent
import com.onesignal.OneSignal.OSRemoteNotificationReceivedHandler
import com.oxygendigitalshop.app.MainActivity
import com.oxygendigitalshop.app.appStateDestroy
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class NotificationServiceExtension : OSRemoteNotificationReceivedHandler {
    lateinit var sharedPreferences: SharedPreferences
    lateinit var editor: Editor
    private var stateValue: Boolean = false
    override fun remoteNotificationReceived(
        context: Context,
        notificationReceivedEvent: OSNotificationReceivedEvent
    ) {
        sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        editor =     sharedPreferences.edit()
        stateValue = sharedPreferences.getBoolean(appStateDestroy, false)
        val notification = notificationReceivedEvent.notification
        val mutableNotification = notification.mutableCopy()
        val data = notification.additionalData
        val notificationId = notification.notificationId
        NativeMethodChannel.invokeNotificationChannel(data);
        val handler = Handler(Looper.getMainLooper())
        handler.post {
           addNotificationCount(context = context)
        }
        Log.i("ServiceExtension", "Received Notification :: Notification ID => $notificationId")
        Log.i("ServiceExtension", "Received Notification :: Adiitional Data => $data")
        notificationReceivedEvent.complete(mutableNotification)
    }

    fun addNotificationCount(context: Context){
        if(stateValue){
            val count = sharedPreferences.getInt("flutter.oxygenNotificationCount", 0)
            editor.putInt("flutter.oxygenNotificationCount",  count + 1);
            editor.commit()
        }
    }
}

object NativeMethodChannel {
    private const val CHANNEL_NAME = "Oxygen#Notifications"
    private lateinit var methodChannel: MethodChannel
    fun configureChannel(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
    }
    fun invokeNotificationChannel(data:  Any?) {
       if(::methodChannel.isInitialized){
           val handler = Handler(Looper.getMainLooper())
           handler.post {
               methodChannel.invokeMethod("Oxygen#Notifications", "$data");
           }
       }
    }
}

