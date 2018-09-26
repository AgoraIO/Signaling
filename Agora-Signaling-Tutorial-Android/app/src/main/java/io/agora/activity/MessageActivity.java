package io.agora.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;


import android.os.Bundle;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.OrientationHelper;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import android.view.View;
import android.widget.*;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;

import io.agora.AgoraAPI;
import io.agora.AgoraAPIOnlySignal;
import io.agora.IAgoraAPI;
import io.agora.adapter.MessageAdapter;
import io.agora.model.MessageBean;
import io.agora.model.MessageListBean;
import io.agora.sginatutorial.AGApplication;
import io.agora.sginatutorial.R;
import io.agora.utils.Constant;
import io.agora.utils.ToastUtils;

/**
 * Created by beryl on 2017/11/6.
 */

public class MessageActivity extends Activity {
    private final String TAG = MessageActivity.class.getSimpleName();

    private AgoraAPIOnlySignal agoraAPI;
    private TextView textViewTitle;
    private EditText editText;
    private RecyclerView recyclerView;
    private List<MessageBean> messageBeanList;
    private MessageAdapter adapter;

    private String channelName = "";
    private String selfName = "";
    private boolean stateSingleMode = true; // single mode or channel mode
    private int channelUserCount;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message);

        InitUI();
        setupData();
    }


    private void InitUI() {
        textViewTitle = (TextView) findViewById(R.id.message_title);
        editText = (EditText) findViewById(R.id.message_edittiext);
        recyclerView = (RecyclerView) findViewById(R.id.message_list);

        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        recyclerView.setLayoutManager(layoutManager);
        layoutManager.setOrientation(OrientationHelper.VERTICAL);
    }


    private void setupData() {

        Intent intent = getIntent();
        channelName = intent.getStringExtra("name");
        selfName = intent.getStringExtra("selfname");
        stateSingleMode = intent.getBooleanExtra("mode", true);
        channelUserCount = intent.getIntExtra("usercount", 0);
        textViewTitle.setText(channelName + "(" + channelUserCount + ")");

        if (stateSingleMode) {
            MessageListBean messageListBean = Constant.getExistMesageListBean(channelName);
            if (messageListBean == null) {
                messageBeanList = new ArrayList<>();
            } else {
                messageBeanList = messageListBean.getMessageBeanList();
            }
        } else {
            messageBeanList = new ArrayList<>();
        }
        adapter = new MessageAdapter(this, messageBeanList);
        recyclerView.setAdapter(adapter);

        agoraAPI = AGApplication.the().getmAgoraAPI();
        if (stateSingleMode) {
            agoraAPI.queryUserStatus(channelName);
        }

    }


    /**
     * siginal callback
     */
    private void addCallback() {
        if (agoraAPI == null) {
            return;
        }

        agoraAPI.callbackSet(new AgoraAPI.CallBack() {

            @Override
            public void onChannelUserJoined(String account, int uid) {
                super.onChannelUserJoined(account, uid);
                channelUserCount++;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        textViewTitle.setText(channelName + "(" + channelUserCount + ")");
                    }
                });
            }

            @Override
            public void onChannelUserLeaved(String account, int uid) {
                super.onChannelUserLeaved(account, uid);
                channelUserCount--;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        textViewTitle.setText(channelName + "(" + channelUserCount + ")");
                    }
                });
            }

            @Override
            public void onLogout(final int i) {
                Log.i(TAG, "onLogout  i = " + i);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (i == IAgoraAPI.ECODE_LOGOUT_E_KICKED) { //other login the account
                            ToastUtils.show(new WeakReference<Context>(MessageActivity.this), "Other login account ,you are logout.");

                        } else if (i == IAgoraAPI.ECODE_LOGOUT_E_NET) { //net
                            ToastUtils.show(new WeakReference<Context>(MessageActivity.this), "Logout for Network can not be.");
                            finish();

                        }
                        Intent intent = new Intent();
                        intent.putExtra("result", "finish");
                        setResult(RESULT_OK, intent);
                        finish();
                    }
                });

            }


            @Override
            public void onQueryUserStatusResult(final String name, final String status) {
                Log.i(TAG, "onQueryUserStatusResult  name = " + name + "  status = " + status);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        if (status.equals("1")) {
                            if (stateSingleMode) {
                                textViewTitle.setText(channelName + getString(R.string.str_online));
                            }

                        } else if (status.equals("0")) {
                            if (stateSingleMode) {
                                textViewTitle.setText(channelName + getString(R.string.str_not_online));
                            }

                        }
                    }
                });
            }

            @Override
            public void onMessageInstantReceive(final String account, int uid, final String msg) {
                Log.i(TAG, "onMessageInstantReceive  account = " + account + " uid = " + uid + " msg = " + msg);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (account.equals(channelName)) {

                            MessageBean messageBean = new MessageBean(account, msg, false);
                            messageBean.setBackground(getMessageColor(account));
                            messageBeanList.add(messageBean);
                            adapter.notifyItemRangeChanged(messageBeanList.size(), 1);
                            recyclerView.scrollToPosition(messageBeanList.size() - 1);
                        } else {

                            Constant.addMessageBean(account, msg);

                        }

                    }
                });
            }

            @Override
            public void onMessageChannelReceive(String channelID, final String account, int uid, final String msg) {
                Log.i(TAG, "onMessageChannelReceive  account = " + account + " uid = " + uid + " msg = " + msg);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        //self message had added
                        if (!account.equals(selfName)) {
                            MessageBean messageBean = new MessageBean(account, msg, false);
                            messageBean.setBackground(getMessageColor(account));
                            messageBeanList.add(messageBean);
                            adapter.notifyItemRangeChanged(messageBeanList.size(), 1);
                            recyclerView.scrollToPosition(messageBeanList.size() - 1);
                        }

                    }
                });
            }

            @Override
            public void onMessageSendSuccess(String messageID) {

            }

            @Override
            public void onMessageSendError(String messageID, int ecode) {

            }

            @Override
            public void onError(String name, int ecode, String desc) {
                Log.i(TAG, "onError  name = " + name + " ecode = " + ecode + " desc = " + desc);
            }

            @Override
            public void onLog(String txt) {
                super.onLog(txt);
            }
        });

    }


    @Override
    protected void onResume() {
        super.onResume();
        addCallback();

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        if (stateSingleMode) {
            Constant.addMessageListBeanList(new MessageListBean(channelName, messageBeanList));
        } else {
            if (agoraAPI != null) {
                agoraAPI.channelLeave(channelName);

            }
        }

    }

    public void onClickSend(View v) {
        String msg = editText.getText().toString();
        if (msg != null && !msg.equals("")) {
            MessageBean messageBean = new MessageBean(selfName, msg, true);
            messageBeanList.add(messageBean);
            adapter.notifyItemRangeChanged(messageBeanList.size(), 1);
            recyclerView.scrollToPosition(messageBeanList.size() - 1);

            if (stateSingleMode) {
                agoraAPI.messageInstantSend(channelName, 0, msg, "");
            } else {
                agoraAPI.messageChannelSend(channelName, msg, "");
            }

        }
        editText.setText("");

    }


    public void onClickFinish(View v) {
        finish();
    }

    //get exist account message color
    private int getMessageColor(String account) {
        for (int i = 0; i < messageBeanList.size(); i++) {
            if (account.equals(messageBeanList.get(i).getAccount())) {
                return messageBeanList.get(i).getBackground();
            }
        }
        return Constant.COLOR_ARRAY[Constant.RANDOM.nextInt(Constant.COLOR_ARRAY.length)];
    }


}
