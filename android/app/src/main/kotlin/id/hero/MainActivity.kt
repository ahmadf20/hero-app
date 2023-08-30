package id.hero

import android.os.Bundle
import androidx.annotation.NonNull

import io.flutter.embedding.android.FlutterActivity

import com.samsung.wearable_rotary.WearableRotaryPlugin
import android.view.MotionEvent

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", "transparent")
        super.onCreate(savedInstanceState)
    }

    override fun onGenericMotionEvent(event: MotionEvent?): Boolean {
        return when {
            WearableRotaryPlugin.onGenericMotionEvent(event) -> true
            else -> super.onGenericMotionEvent(event)
        }
    }
}