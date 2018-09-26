package io.agora.activity;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import java.lang.ref.WeakReference;

import io.agora.AgoraAPI;
import io.agora.IAgoraAPI;
import io.agora.sginatutorial.AGApplication;
import io.agora.sginatutorial.R;
import io.agora.utils.Constant;
import io.agora.utils.ToastUtils;


public class LoginActivity extends Activity {
    private final String TAG = LoginActivity.class.getSimpleName();

    private EditText textAccountName;
    private TextView textViewVersion;
    private String appId;

    private String account;
    private boolean enableLoginBtnClick = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_login);

        appId = getString(R.string.agora_app_id);

        textAccountName = (EditText) findViewById(R.id.account_name);
        textViewVersion = (TextView) findViewById(R.id.login_version);

    }

    //login siginal
    public void onClickLogin(View v) {

        if (enableLoginBtnClick) {
            account = textAccountName.getText().toString();

            if (account == null || account.equals("")) {
                ToastUtils.show(new WeakReference<Context>(LoginActivity.this), getString(R.string.str_msg_not_empty));

            } else if (account.length() >= Constant.MAX_INPUT_NAME_LENGTH) {
                ToastUtils.show(new WeakReference<Context>(LoginActivity.this), getString(R.string.str_msg_not_128));

            } else if (account.contains(" ")) {
                ToastUtils.show(new WeakReference<Context>(LoginActivity.this), getString(R.string.str_msg_not_contains_space));

            } else {
                enableLoginBtnClick = false;

                AGApplication.the().getmAgoraAPI().login2(appId, account, "_no_need_token", 0, "", 5, 1);
            }
        }

    }

    private void addCallback() {

        AGApplication.the().getmAgoraAPI().callbackSet(new AgoraAPI.CallBack() {

            @Override
            public void onLoginSuccess(int i, int i1) {
                Log.i(TAG, "onLoginSuccess " + i + "  " + i1);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Intent intent = new Intent(LoginActivity.this, SelectChannelActivity.class);
                        intent.putExtra("account", account);
                        startActivity(intent);

                    }
                });
            }

            @Override
            public void onLoginFailed(final int i) {
                Log.i(TAG, "onLoginFailed " + i);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (i == IAgoraAPI.ECODE_LOGIN_E_NET) {
                            enableLoginBtnClick = true;
                            ToastUtils.show(new WeakReference<Context>(LoginActivity.this), getString(R.string.str_msg_net_bad));
                        }
                    }
                });
            }


            @Override
            public void onError(String s, int i, String s1) {
                Log.i(TAG, "onError s:" + s + " s1:" + s1);
            }

        });
    }

    @Override

    protected void onResume() {
        super.onResume();

        addCallback();
        enableLoginBtnClick = true;
        StringBuffer version = new StringBuffer("" + AGApplication.the().getmAgoraAPI().getSdkVersion());

        if (version.length() >= 8) {
            String strVersion = "version " + version.charAt(2) + "." + version.charAt(4) + "." + version.charAt(6);
            textViewVersion.setText(strVersion);
        }

    }

}
