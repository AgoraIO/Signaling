package io.agora.sginatutorial;

import android.app.Application;
import android.util.Log;

import io.agora.AgoraAPIOnlySignal;

public class AGApplication extends Application {
    private final String TAG = AGApplication.class.getSimpleName();


    private static AGApplication mInstance;
    private AgoraAPIOnlySignal m_agoraAPI;


    public static AGApplication the() {
        return mInstance;
    }

    public AGApplication() {
        mInstance = this;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        setupAgoraEngine();
    }

    public AgoraAPIOnlySignal getmAgoraAPI() {
        return m_agoraAPI;
    }


    private void setupAgoraEngine() {
        String appID = getString(R.string.agora_app_id);

        try {
            m_agoraAPI = AgoraAPIOnlySignal.getInstance(this, appID);


        } catch (Exception e) {
            Log.e(TAG, Log.getStackTraceString(e));

            throw new RuntimeException("NEED TO check rtc sdk init fatal error\n" + Log.getStackTraceString(e));
        }
    }


}

