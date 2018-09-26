package mainclass;

import io.agora.signal.Signal;
import io.agora.signal.Signal.LoginSession;
import io.agora.signal.Signal.LoginSession.Channel;
import model.DialogueRecord;
import model.DialogueStatus;
import model.User;
import tool.Constant;
import tool.PrintToScreen;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class WorkerThread implements Runnable {

    private boolean mainThreadStatus = false;

    private String token = "_no_need_token";
    private String currentUser;
    private boolean timeOutFlag;
    private DialogueStatus currentStatus;
    private HashMap<String, User> users;
    private HashMap<String, List<DialogueRecord>> accountDialogueRecords = null;
    private HashMap<String, List<DialogueRecord>> channelDialogueRecords = null;
    List<DialogueRecord> currentAccountDialogueRecords = null;
    List<DialogueRecord> currentChannelDialogueRecords = null;
    private Scanner in;
    private Signal sig;

    private String currentMode;

    public WorkerThread(String mode) {
        currentMode = mode;
        init();
        String appid = Constant.app_ids.get(0);
        if (currentMode.equals(Constant.COMMAND_SINGLE_SIGNAL_OBJECT)) {
            sig = new Signal(appid);
            currentStatus = DialogueStatus.UNLOGIN;
        } else {
            if (currentMode.equals(Constant.COMMAND_MULTI_SIGNAL_OBJECT)) {
                currentStatus = DialogueStatus.SIGNALINSTANCE;
            }
        }
    }

    private void init() {
        this.mainThreadStatus = true;
        in = new Scanner(System.in);

        timeOutFlag = false;
        users = new HashMap<String, User>();

        if (currentMode == Constant.COMMAND_MULTI_SIGNAL_OBJECT) {//add by
            signalName = new ArrayList<String>();
            signalNameAndSignalRecord = new HashMap<String, Signal>();
            signalAndUser = new HashMap<Signal, HashMap<String, User>>();
        }
        accountDialogueRecords = new HashMap<String, List<DialogueRecord>>();
        channelDialogueRecords = new HashMap<String, List<DialogueRecord>>();
    }

    public void run() {
        PrintToScreen.printToScreenLine("**************************************************");
        PrintToScreen.printToScreenLine("* Agora Signaling Tutorial  ---SDK version:1.2.0 *");
        PrintToScreen.printToScreenLine("**************************************************");
        while (this.mainThreadStatus) {
            switch (currentStatus) {
                case SIGNALINSTANCE:
                    dealWithProduceSignalInstance();
                    break;
                case CHOOSESIGNAL:
                    dealWithChooseSignalObject();
                    break;
                case UNLOGIN:
                    dealWithUnLogin();
                    break;
                case LOGINED:
                    dealWithLogined();
                    break;
                case SINGLE_POINT:
                    dealWithPersonToPerson();
                    break;
                case CHANNEL:
                    dealWithChannel();
                    break;
                default:
                    PrintToScreen.printToScreenLine("*************programe in error states***************");
                    break;
            }
        }
    }

    //add by
    public void dealWithProduceSignalInstance() {
        printSignalName(currentSignalName);
        makeSignals();
    }


    public void printSignalName(String signalName) {

        if (signalName == null) {
            if (isFirstMakeSignal) {
                PrintToScreen.printToScreenLine("************************************************************************");
                PrintToScreen.printToScreenLine("*Your Signal Object  is empty,please create a Signal Object first !*");
                PrintToScreen.printToScreenLine("*You can input '0' to make a Signal Object!                           *");
                PrintToScreen.printToScreenLine("************************************************************************");
            }
        } else {
            PrintToScreen.printToScreenLine("Your signal Object is " + signalName + " .");
        }
    }


    private String currentSignalName;
    private ArrayList<String> signalName;
    private int signalCount = 0;

    private HashMap<String, Signal> signalNameAndSignalRecord = null;
    private HashMap<Signal, HashMap<String, User>> signalAndUser;
    private boolean isFirstMakeSignal = true;


    public void makeSignals() {
        String inputSignalCommand = "";
        boolean needBreak = true;
        while ((currentStatus == DialogueStatus.SIGNALINSTANCE) && needBreak) {
            if (!isFirstMakeSignal) {
                PrintToScreen.printToScreenLine("***********************************************");
                PrintToScreen.printToScreenLine("*You can input '0' to create a Signal Object!*");
                PrintToScreen.printToScreenLine("***********************************************");
            } else {
                isFirstMakeSignal = false;
            }
            PrintToScreen.printToScreen("Command: ");
            inputSignalCommand = in.nextLine() + "";
            if (!inputSignalCommand.equals(Constant.COMMAND_CREATE_SIGNAL)) {
                PrintToScreen.printToScreenLine("");
                PrintToScreen.printToScreenLine("***************************************************");
                PrintToScreen.printToScreenLine("*Can't understand your command, Please Try again! *");
                PrintToScreen.printToScreenLine("***************************************************");

            } else {

                String appId = null;
                boolean appIdneedBreak = true;

                while ((currentStatus == DialogueStatus.SIGNALINSTANCE) && appIdneedBreak) {
                    if (Constant.CURRENT_APPID < Constant.app_ids.size()) {
                        appId = Constant.app_ids.get(Constant.CURRENT_APPID);
                        Constant.CURRENT_APPID++;
                        appIdneedBreak = false;
                    } else {
                        PrintToScreen.printToScreenLine("There are no more appId,please input a new appId :");
                        PrintToScreen.printToScreen("APPID: ");
                        appId = in.nextLine();
                        if (appId.equals("") | appId.equals(null)) {
                            PrintToScreen.printToScreenLine("***************************************************");
                            PrintToScreen.printToScreenLine("Sorry,your appId is null!");
                            PrintToScreen.printToScreenLine("***************************************************");

                        } else {
                            Constant.app_ids.add(appId);
                            Constant.CURRENT_APPID++;
                            appIdneedBreak = false;
                        }
                    }
                }

                Signal signal = new Signal(appId);
                PrintToScreen.printToScreenLine("Current Signal Object appId = " + appId);
                currentSignalName = "Signal " + signalCount;
                signalName.add(currentSignalName);
                signalNameAndSignalRecord.put(currentSignalName, signal);
                signalCount++;
                PrintToScreen.printToScreenLine("**************************************************");
                PrintToScreen.printToScreenLine("                    Success !                     ");
                PrintToScreen.printToScreenLine("Current Signal Object is " + currentSignalName + ".             ");
                PrintToScreen.printToScreenLine("Here are all Signal Objects:                     ");
                PrintToScreen.printToScreenLine(printAllSignalObject());
                PrintToScreen.printToScreenLine("**************************************************");

                needBreak = false;
            }
        }
        chooseWhatToDo();
    }


    public void chooseWhatToDo() {
        boolean needBreak = true;
        while ((currentStatus == DialogueStatus.SIGNALINSTANCE) && needBreak) {
            String inputCommand = "";
            PrintToScreen.printToScreenLine("Please choose what to do...");
            PrintToScreen.printToScreenLine("**************************************************************");
            PrintToScreen.printToScreenLine("*input '0' choose to create a Signal Objcet continue!        *");
            PrintToScreen.printToScreenLine("*input '1' chooose to create an Account in this Signal Object*");
            PrintToScreen.printToScreenLine("**************************************************************");
            PrintToScreen.printToScreen("Command: ");
            inputCommand = in.nextLine();
            if (inputCommand.equals(Constant.COMMAND_CREATE_SIGNAL)) {
                makeSignals();
                needBreak = false;
            } else if (inputCommand.equals(Constant.COMMAND_CREATE_ACCOUNT)) {
                currentStatus = DialogueStatus.UNLOGIN;
                needBreak = false;
            } else {
                PrintToScreen.printToScreenLine("*********************************************");
                PrintToScreen.printToScreenLine("...your command: " + inputCommand + "  can't understand...");
                PrintToScreen.printToScreenLine("*********************************************");
            }
        }
    }


    private String printAllSignalObject() {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < signalName.size(); i++) {
            if (i != (signalName.size() - 1)) {
                stringBuilder.append(i + 1 + ":  ").append(signalName.get(i)).append("\n");
                continue;
            }
            stringBuilder.append(signalName.size() + ":  ").append(signalName.get(i));
        }

        return stringBuilder.toString();
    }

    private void dealWithChooseSignalObject() {
        PrintToScreen.printToScreenLine("**************************************************************");
        PrintToScreen.printToScreenLine("Current Signal Object is " + currentSignalName + ".              ");
        PrintToScreen.printToScreenLine("Here are all Signal Objects:                     ");
        PrintToScreen.printToScreenLine(printAllSignalObject());
        String allSignalObject = printAllSignalObject();
        PrintToScreen.printToScreenLine("You can switch Signal Object by input the number of the Signal.... ");
        PrintToScreen.printToScreen("Command: ");

        String inputCommand = in.nextLine();
        checkTheNumberofSignalObject(inputCommand);

    }

    private void checkTheNumberofSignalObject(String numberSignalObject) {
        for (int i = 0; i < signalName.size(); i++) {
            if (numberSignalObject.equals(i + 1 + "")) {

                currentSignalName = signalName.get(i);
                PrintToScreen.printToScreenLine("**************************************************************");

                PrintToScreen.printToScreenLine("Current Signal Object is " + currentSignalName);
                currentStatus = DialogueStatus.UNLOGIN;

                return;
            }
        }
        PrintToScreen.printToScreenLine("...your command: " + numberSignalObject + "  can't understand...");
        dealWithChooseSignalObject();
    }


    public void dealWithUnLogin() {
        while (this.mainThreadStatus && (this.currentStatus == DialogueStatus.UNLOGIN)) {
            String inputCommand = "";
            Signal currentSignal = null;
            if (currentMode.equals(Constant.COMMAND_MULTI_SIGNAL_OBJECT)) {
                PrintToScreen.printToScreenLine("**************************************************************");
                PrintToScreen.printToScreenLine("Current Signal is :" + currentSignalName + "    " + signalNameAndSignalRecord.get(currentSignalName).toString());
                PrintToScreen.printToScreenLine("You can input 'switch' to choose a Signal Object....");
                PrintToScreen.printToScreenLine("Please enter your account to login....");
                PrintToScreen.printToScreenLine("**************************************************************");
                PrintToScreen.printToScreen("Account:");
                inputCommand = in.nextLine();
                checkWheatherSwitchSignalObject(inputCommand);
                currentSignal = signalNameAndSignalRecord.get(currentSignalName);
            } else if (currentMode.equals(Constant.COMMAND_SINGLE_SIGNAL_OBJECT)) {
                PrintToScreen.printToScreenLine("Current Signal is  :" + sig.toString());
                PrintToScreen.printToScreen("Account:");
                inputCommand = in.nextLine();
                currentSignal = sig;
            }

            if (currentStatus != DialogueStatus.UNLOGIN) {
                return;
            }

            if (checkAccountName(inputCommand)) {
                login(inputCommand, currentSignal);
            } else {
                PrintToScreen.printToScreenLine("Please recheck the account,it has format error");
                PrintToScreen.printToScreenLine("********************************************************");
            }
        }
    }

    private void checkWheatherSwitchSignalObject(String inputCommand) {
        if (inputCommand.equals("switch")) {
            currentStatus = DialogueStatus.CHOOSESIGNAL;
        }
    }

    public void dealWithLogined() {
        while (this.mainThreadStatus && this.currentStatus == DialogueStatus.LOGINED) {
            boolean loginedFlag = true;
            while (this.mainThreadStatus && loginedFlag) {
                PrintToScreen.printToScreenLine("******************************************************");
                PrintToScreen.printToScreenLine("you can input '" + Constant.COMMAND_LOGOUT + "' to logout....");
                PrintToScreen.printToScreenLine("Please chose chart type.....");
                PrintToScreen.printToScreenLine("****************************************************");
                PrintToScreen.printToScreenLine("*input '2' choose single_point chart               *");
                PrintToScreen.printToScreenLine("*input '3' choose channel chart                    *");
                PrintToScreen.printToScreenLine("****************************************************");
                PrintToScreen.printToScreen("choose option:");
                String command = in.nextLine();
                if (command.equals(Constant.COMMAND_LOGOUT)) {
                    loginedFlag = false;
                    if ((users != null) && (currentUser != null)) {
                        users.get(currentUser).getSession().logout();
                        timeOutFlag = false;
                        wait_time(users.get(currentUser).getLogoutLatch(), Constant.TIMEOUT, currentUser);
                    } else {

                        currentStatus = DialogueStatus.UNLOGIN;
                    }
                } else if (command.equals(Constant.COMMAND_TYPE_SINGLE_POINT)) {
                    loginedFlag = false;
                    currentStatus = DialogueStatus.SINGLE_POINT;
                } else if (command.equals(Constant.COMMAND_TYPE_CHANNEL)) {
                    loginedFlag = false;
                    currentStatus = DialogueStatus.CHANNEL;
                } else {
                    PrintToScreen.printToScreenLine("************************************************");
                    PrintToScreen.printToScreenLine("...your command:" + command + " can't understand...");
                }
            }
        }
    }

    public void dealWithPersonToPerson() {
        while (this.mainThreadStatus && this.currentStatus == DialogueStatus.SINGLE_POINT) {
            PrintToScreen.printToScreenLine("************************************************");
            PrintToScreen.printToScreenLine("Please enter the opposite account.....");
            PrintToScreen.printToScreen("Input Opposite Account:");
            String oppositeAccount = in.nextLine();
            if (checkAccountName(oppositeAccount)) {
                intoP2PConversation(oppositeAccount);
            } else {
                PrintToScreen.printToScreenLine("Please recheck the oppositeAccount,it has format error");
                PrintToScreen.printToScreenLine("**************************************************");
            }
        }
    }

    public void queryUserStatus(String account) {

    }

    public void intoP2PConversation(String oppositeAccount) {
        boolean p2pFlag = true;
        currentAccountDialogueRecords = initP2PRecord(oppositeAccount);
        PrintToScreen.printToScreenLine("**************************************************");
        if (currentAccountDialogueRecords == null || currentAccountDialogueRecords.size() == 0) {
            currentAccountDialogueRecords = new ArrayList<DialogueRecord>();
        } else {
            for (int i = 0; i < currentAccountDialogueRecords.size(); i++) {
                PrintToScreen.printToScreenLine(currentAccountDialogueRecords.get(i).getAccount() + ":" + currentAccountDialogueRecords.get(i).getDialogue());
            }
        }
        PrintToScreen.printToScreenLine("****above is history record :" + currentAccountDialogueRecords.size() + "**************");
        PrintToScreen.printToScreenLine("you can send message now and input '" + Constant.COMMAND_LEAVE_CHART + "' to leave this session");
        PrintToScreen.printToScreenLine("***************" + oppositeAccount + " status : " + "to do " + "******************");
        while (this.mainThreadStatus && p2pFlag) {
            String command = in.nextLine();
            if (command.equals(Constant.COMMAND_LEAVE_CHART)) {
                p2pFlag = false;
                currentStatus = DialogueStatus.LOGINED;
                accountDialogueRecords.put(oppositeAccount, currentAccountDialogueRecords);
            } else {
                sendMsg(command, oppositeAccount);
            }
        }
    }

    public List<DialogueRecord> initP2PRecord(String oppositeAccount) {
        return accountDialogueRecords.get(oppositeAccount);
    }

    public void dealWithChannel() {
        while (this.mainThreadStatus && this.currentStatus == DialogueStatus.CHANNEL) {
            PrintToScreen.printToScreenLine("************************************************");
            PrintToScreen.printToScreenLine("you can input '" + Constant.COMMAND_LOGOUT + "' to logout....");
            PrintToScreen.printToScreenLine("Please enter the channel name.....");
            PrintToScreen.printToScreen("channel name:");
            String channelName = in.nextLine();
            if (checkAccountName(channelName)) {
                joinChannel(channelName);
                if (this.currentStatus == DialogueStatus.CHANNEL && timeOutFlag == false) {
                    intoChannelConversation(channelName);
                } else {
                    PrintToScreen.printToScreenLine("****************join channel error*************");
                }
            } else {
                PrintToScreen.printToScreenLine("Please recheck the channel name,it has format error");
                PrintToScreen.printToScreenLine("**************************************************");
            }
        }
    }

    public void intoChannelConversation(String channelName) {
        boolean channelFlag = true;
        currentChannelDialogueRecords = initChannelRecord(channelName);
        PrintToScreen.printToScreenLine("*******************channel:" + channelName + "*****************");
        if (currentChannelDialogueRecords == null || currentChannelDialogueRecords.size() == 0) {
            currentChannelDialogueRecords = new ArrayList<DialogueRecord>();
        } else {
            for (int i = 0; i < currentChannelDialogueRecords.size(); i++) {
                PrintToScreen.printToScreenLine(currentChannelDialogueRecords.get(i).getAccount() + ":" + currentChannelDialogueRecords.get(i).getDialogue());
            }
        }
        PrintToScreen.printToScreenLine("****above is history record :" + currentChannelDialogueRecords.size() + "**************");
        PrintToScreen.printToScreenLine("you can send message now and input '" + Constant.COMMAND_LEAVE_CHART + "' to leave this session");

        while (this.mainThreadStatus && channelFlag) {

            String command = in.nextLine();
            if (command.equals(Constant.COMMAND_LEAVE_CHART)) {
                channelFlag = false;
                currentStatus = DialogueStatus.LOGINED;
                users.get(currentUser).getChannel().channelLeave();
                channelDialogueRecords.put(channelName, currentChannelDialogueRecords);
            } else {
                channelDeal(command, channelName);
            }
        }

    }

    public void channelDeal(String command, String channelName) {
        users.get(currentUser).getChannel().messageChannelSend(command);
    }

    public void joinChannel(String channelName) {
        final CountDownLatch channelJoindLatch = new CountDownLatch(1);
        Channel channel = users.get(currentUser).getSession().channelJoin(channelName, new Signal.ChannelCallback() {
            @Override
            public void onChannelJoined(Signal.LoginSession session, Signal.LoginSession.Channel channel) {
                channelJoindLatch.countDown();
            }

            @Override
            public void onChannelUserList(Signal.LoginSession session, Signal.LoginSession.Channel channel, List<String> users, List<Integer> uids) {
            }


            @Override
            public void onMessageChannelReceive(Signal.LoginSession session, Signal.LoginSession.Channel channel, String account, int uid, String msg) {

                if (currentChannelDialogueRecords != null && currentStatus == DialogueStatus.CHANNEL) {
                    PrintToScreen.printToScreenLine(account + ":" + msg);
                    DialogueRecord dialogueRecord = new DialogueRecord(account, msg, new Date());
                    currentChannelDialogueRecords.add(dialogueRecord);
                }

            }

            @Override
            public void onChannelUserJoined(Signal.LoginSession session, Signal.LoginSession.Channel channel, String account, int uid) {
                if (currentStatus == DialogueStatus.CHANNEL) {
                    PrintToScreen.printToScreenLine("..." + account + " joined channel... ");
                }
            }

            @Override
            public void onChannelUserLeaved(Signal.LoginSession session, Signal.LoginSession.Channel channel, String account, int uid) {
                if (currentStatus == DialogueStatus.CHANNEL) {
                    PrintToScreen.printToScreenLine("..." + account + " leave channel... ");
                }
            }

            @Override
            public void onChannelLeaved(Signal.LoginSession session, Signal.LoginSession.Channel channel, int ecode) {
                if (currentStatus == DialogueStatus.CHANNEL) {
                    currentStatus = DialogueStatus.LOGINED;
                }
            }

        });
        timeOutFlag = false;
        wait_time(channelJoindLatch, Constant.TIMEOUT, channelName);
        if (timeOutFlag == false) {
            users.get(currentUser).setChannel(channel);
        }

    }


    public List<DialogueRecord> initChannelRecord(String channelName) {
        return channelDialogueRecords.get(channelName);
    }

    public void sendMsg(final String msg, String oppositeAccount) {
        Signal.LoginSession currentSession = users.get(currentUser).getSession();
        currentSession.messageInstantSend(oppositeAccount, msg, new Signal.MessageCallback() {
            @Override
            public void onMessageSendSuccess(Signal.LoginSession session) {
                DialogueRecord dialogueRecord = new DialogueRecord(currentUser, msg, new Date());
                currentAccountDialogueRecords.add(dialogueRecord);
                PrintToScreen.printToScreenLine(currentUser + ":" + msg);
            }

            @Override
            public void onMessageSendError(Signal.LoginSession session, int ecode) {
                PrintToScreen.printToScreenLine(currentUser + " msg send error");
            }
        });
    }


    public boolean initRecordFile() {
        boolean recordFileFlag = false;
        File directory = new File(".");
        String path = null;
        String path_p2p = null;
        String path_channel = null;
        try {
            path = directory.getCanonicalPath();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return recordFileFlag;
        }
        path_p2p = path + "\\" + Constant.RECORD_FILE_P2P;
        path_channel = path + "\\" + Constant.RECORD_FILE_CHANEEL;
        File file_p2p = new File(path_p2p);
        File file_channel = new File(path_channel);
        PrintToScreen.printToScreenLine(path);
        if (file_p2p.exists()) {
            file_p2p.delete();
        }
        if (file_channel.exists()) {
            file_channel.delete();
        }
        try {
            file_p2p.createNewFile();
            file_channel.createNewFile();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return recordFileFlag;
        }
        recordFileFlag = true;
        return recordFileFlag;
    }

    public boolean checkAccountName(String accountName) {
        boolean returnFlag = false;
        if (accountName.contains(" ")) {
            return returnFlag;
        } else if (accountName.length() <= 0 || accountName.length() >= 128) {
            return returnFlag;
        } else if (accountName.equals(currentUser)) {
            PrintToScreen.printToScreenLine("...the same as the logining account...");
            return returnFlag;
        }
        returnFlag = true;
        return returnFlag;
    }

    public void login(final String accountName, Signal signal) {

        sig = signal;
        PrintToScreen.printToScreenLine("Signal is a :  = " + sig + "   accountName  = " + accountName + "   token   = " + token);

        final CountDownLatch loginLatch = new CountDownLatch(1);


        sig.login(accountName, this.token, new Signal.LoginCallback() {
            @Override
            public void onLoginSuccess(final Signal.LoginSession session, int uid) {
                if (timeOutFlag == false) {
                    currentUser = accountName;
                    User user = new User(session, accountName, uid);

                    user.setLoginLatch(loginLatch);
                    users.put(currentUser, new User(session, accountName, uid));
                    PrintToScreen.printToScreenLine("account:" + users.get(accountName).getAccount() + " login successd");
                    currentStatus = DialogueStatus.LOGINED;
                    user.getLoginLatch().countDown();
                }
            }
            
            /*@Override
            public void onLoginFailed(LoginSession session, int ecode) {
            	// TODO Auto-generated method stub
            	super.onLoginFailed(session, ecode);
            PrintToScreen.printToScreenLine("account:"+users.get(accountName).getAccount()+" login failed");     	
           
            }*/


            @Override
            public void onLogout(Signal.LoginSession session, int ecode) {
                if (currentStatus == DialogueStatus.LOGINED && timeOutFlag == false) {
                    PrintToScreen.printToScreenLine("account:" + users.get(accountName).getAccount() + " logout successd");
                    if (accountDialogueRecords != null) {
                        accountDialogueRecords.clear();
                    }
                    if (currentChannelDialogueRecords != null) {
                        currentChannelDialogueRecords.clear();
                    }
                    currentStatus = DialogueStatus.UNLOGIN;
                    users.get(currentUser).getLogoutLatch().countDown();
                    currentUser = null;
                }
            }

            @Override
            public void onMessageInstantReceive(Signal.LoginSession session, String account, int uid, String msg) {
                if (currentAccountDialogueRecords != null && currentStatus == DialogueStatus.SINGLE_POINT) {
                    PrintToScreen.printToScreenLine(account + ":" + msg);
                    DialogueRecord dialogueRecord = new DialogueRecord(account, msg, new Date());
                    currentAccountDialogueRecords.add(dialogueRecord);
                }
            }
        });
        this.timeOutFlag = false;
        wait_time(loginLatch, Constant.TIMEOUT, accountName);
    }


    public void wait_time(CountDownLatch x, int tInMS, String accountName) {
        try {
            x.await(tInMS, TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            currentStatus = DialogueStatus.UNLOGIN;
        }
        if (x.getCount() == 1) {
            this.timeOutFlag = true;
            PrintToScreen.printToScreenLine("connect time out ......");
            currentStatus = DialogueStatus.UNLOGIN;
            if (users.get(accountName) != null) {
                users.get(accountName).getSession().logout();
            }
        }
    }
}
