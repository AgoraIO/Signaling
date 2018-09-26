package io.agora.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.IdRes;
import android.util.Log;
import android.view.View;

import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import java.lang.ref.WeakReference;

import io.agora.AgoraAPI;
import io.agora.IAgoraAPI;
import io.agora.sginatutorial.AGApplication;
import io.agora.sginatutorial.R;
import io.agora.utils.Constant;
import io.agora.utils.ToastUtils;


public class SelectChannelActivity extends Activity {
    private final String TAG = SelectChannelActivity.class.getSimpleName();

    private TextView textViewTitle;
    private TextView textViewButton;
    private EditText edittextName;
    private RadioButton buttonSingle;
    private RadioButton buttonChannel;
    private RadioGroup radioGroup;
    private String otherName;
    private String selfAccount;
    private final int REQUEST_CODE = 0x01;

    private boolean stateSingleMode = true; // single mode or channel mode
    private boolean enableChannelBtnClick = true;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_selectchannel);

        initUI();
    }

    private void initUI() {
        Intent intent = getIntent();
        selfAccount = intent.getStringExtra("account");

        textViewTitle = (TextView) findViewById(R.id.select_channel_title);
        edittextName = (EditText) findViewById(R.id.select_channel_edittiext);
        textViewButton = (TextView) findViewById(R.id.select_channel_button);
        buttonSingle = (RadioButton) findViewById(R.id.select_mode_single);
        buttonChannel = (RadioButton) findViewById(R.id.select_mode_channel);
        radioGroup = (RadioGroup) findViewById(R.id.sekect_mode_group);
        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                switch (checkedId) {
                    case R.id.select_mode_single:
                        stateSingleMode = true;
                        break;
                    case R.id.select_mode_channel:
                        stateSingleMode = false;

                        break;
                }
                onClickSelectMode();

            }
        });
        buttonSingle.setChecked(true);

    }


    public void onClickChat(View v) {
        if (enableChannelBtnClick) {
            otherName = edittextName.getText().toString();

            if (otherName == null || otherName.equals("")) {
                ToastUtils.show(new WeakReference<Context>(SelectChannelActivity.this), getString(R.string.str_msg_not_empty));

            } else if (otherName.length() >= Constant.MAX_INPUT_NAME_LENGTH) {
                ToastUtils.show(new WeakReference<Context>(SelectChannelActivity.this), getString(R.string.str_msg_not_128));

            } else if (stateSingleMode && otherName.contains(" ")) {
                ToastUtils.show(new WeakReference<Context>(SelectChannelActivity.this), getString(R.string.str_msg_not_contains_space));

            } else if (stateSingleMode && otherName.equals(selfAccount)) {
                ToastUtils.show(new WeakReference<Context>(SelectChannelActivity.this), getString(R.string.str_msg_cannot_yourself));

            } else {
                enableChannelBtnClick = false;
                if (stateSingleMode) {

                    Intent intent = new Intent(this, MessageActivity.class);
                    intent.putExtra("mode", stateSingleMode);
                    intent.putExtra("name", otherName);
                    intent.putExtra("selfname", selfAccount);
                    startActivityForResult(intent, REQUEST_CODE);
                } else {
                    AGApplication.the().getmAgoraAPI().channelJoin(otherName);
                }
            }
        }

    }

    public void onClickSelectMode() {

        if (stateSingleMode) {
            textViewTitle.setText(getString(R.string.str_msg_single));
            textViewButton.setText(getString(R.string.str_chat));
            edittextName.setHint(getString(R.string.str_friend));

        } else {
            textViewTitle.setText(getString(R.string.str_msg_channel));
            textViewButton.setText(getString(R.string.str_join));
            edittextName.setHint(getString(R.string.str_channel));

        }

    }

    private void addCallback() {

        AGApplication.the().getmAgoraAPI().callbackSet(new AgoraAPI.CallBack() {

            @Override
            public void onChannelJoined(String channelID) {
                super.onChannelJoined(channelID);

            }

            @Override
            public void onChannelJoinFailed(String channelID, int ecode) {
                super.onChannelJoinFailed(channelID, ecode);

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        enableChannelBtnClick = true;
                        ToastUtils.show(new WeakReference<Context>(SelectChannelActivity.this), getString(R.string.str_join_channe_failed));
                    }
                });
            }

            @Override
            public void onChannelUserList(String[] accounts, final int[] uids) {
                super.onChannelUserList(accounts, uids);

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Intent intent = new Intent(SelectChannelActivity.this, MessageActivity.class);
                        intent.putExtra("mode", stateSingleMode);
                        intent.putExtra("name", otherName);
                        intent.putExtra("selfname", selfAccount);
                        intent.putExtra("usercount", uids.length);
                        startActivity(intent);

                    }
                });
            }

            @Override
            public void onLogout(final int i) {

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (i == IAgoraAPI.ECODE_LOGOUT_E_KICKED) { //other login the account
                            ToastUtils.show(new WeakReference<Context>(SelectChannelActivity.this), "Other login account ,you are logout.");

                        } else if (i == IAgoraAPI.ECODE_LOGOUT_E_NET) { //net
                            ToastUtils.show(new WeakReference<Context>(SelectChannelActivity.this), "Logout for Network can not be.");

                        }

                        finish();

                    }
                });

            }

            @Override
            public void onError(String s, int i, String s1) {
                Log.i(TAG, "onError s:" + s + " s1:" + s1);
            }

            @Override
            public void onMessageInstantReceive(final String account, int uid, final String msg) {
                Log.i(TAG, "onMessageInstantReceive  account = " + account + " uid = " + uid + " msg = " + msg);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        Constant.addMessageBean(account, msg);

                    }
                });
            }

        });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == REQUEST_CODE && resultCode == RESULT_OK) {
            if (data != null && data.getStringExtra("result").equals("finish")) {
                finish();
            }

        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        addCallback();
        enableChannelBtnClick = true;
    }

    @Override
    public void onBackPressed() {
        AGApplication.the().getmAgoraAPI().logout();
        Constant.cleanMessageListBeanList();
        super.onBackPressed();
    }

    public void onClickFinish(View v) {
        AGApplication.the().getmAgoraAPI().logout();
        /** logout clear messagelist**/
        Constant.cleanMessageListBeanList();
        finish();
    }


}
