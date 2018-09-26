import time, thread
from agorasigsdk import AgoraSignal, LoginSession, Channel
from twisted.internet import reactor
from model import User, DialogueRecord

APP_ID = "_your_app_id"
token = "_no_need_token"
COMMAND_LOGOUT = "logout"
COMMAND_LEAVE_CHERT = "leave"
COMMAND_TYPE_SINGLE_POINT = "1"
COMMAND_TYPE_CHANNEL = "2"


class InteractiveDialogue:
    is_reactor_running = False

    def __init__(self):
        self.sig = AgoraSignal(APP_ID)
        self.account_dialogue_records = {}
        self.channel_dialogue_records = {}
        self.current_user = None
        self.current_account_dialogue_records = []
        self.current_channel_dialogue_records = []

    def check_account(self, account):
        if (not account or len(account) >= 128):
            return False
        elif (self.current_user and account == self.current_user.account):
            print("**************************************************")
            print("...the target count should not same as current account...")
            return False
        else:
            return True

    def check_channel(self, channel_name):
        if (not channel_name or len(channel_name) >= 128):
            return False
        return True

    def check_command_logout(self, command):
        if (command == COMMAND_LOGOUT):
            self.current_user.session.logout()
            return True
        return False

    def check_command_leave(self, command, from_channel=False):
        if (command == COMMAND_LEAVE_CHERT):
            if from_channel:
                self.current_user.channel.channel_leave()
            self.deal_with_logined()
            return True
        return False

    def start(self):
        if len(APP_ID) != 32:
            print("Sorry, your id is incorrect...")
        else:
            print("************************************************")
            print("* Agora Signaling Tutorial---SDK version:1.0.2 *")
            print("************************************************")
            print("Please enter your accout to login....")
            account = raw_input("Account:")
            self.login(account)

    def login(self, account):
        class MyLoginCallBack(LoginSession.LoginCallback):
            def on_login_success(self_callback, session, uid):
                self.current_user = User(session, account, uid)
                print('account:' + self.current_user.account + " login success")
                self.deal_with_logined()

            def on_logout(self_callback, session, err_code):
                print('account:%s logout success' % self.current_user.account)
                if (self.account_dialogue_records):
                    self.account_dialogue_records.clear()
                if (self.channel_dialogue_records):
                    self.channel_dialogue_records.clear()
                self.current_user = None
                self.start()

            def on_msg_instant_received(self_callback, session, account, uid, msg):
                print('%s:%s' % (account, msg))

                instant_received_account_dialogue_records = self.account_dialogue_records.get(account)
                if (instant_received_account_dialogue_records == None):
                    instant_received_account_dialogue_records = []
                    self.account_dialogue_records[account] = instant_received_account_dialogue_records

                instant_received_account_dialogue_records.append(DialogueRecord(account, msg, time.time()))

            def on_login_failed(self, session, uid):
                print("login failed, session:{0},uid:{1}".format(session, uid))

        m_l_c_b = MyLoginCallBack()
        self.sig.login(account, token, m_l_c_b)
        if not InteractiveDialogue.is_reactor_running:
            InteractiveDialogue.is_reactor_running = True
            reactor.run()

    def deal_with_logined(self):
        print("****************************************************")
        print("you can input '" + COMMAND_LOGOUT + "' to logout....")
        print("Please choose chart type.....")
        print("*input '1' choose single point chart     *")
        print("*input '2' choose channel chart          *")
        print("choose option:")

        command = raw_input()
        if (self.check_command_logout(command)):
            return

        if (command == COMMAND_TYPE_SINGLE_POINT):
            self.deal_with_p2p()
        elif (command == COMMAND_TYPE_CHANNEL):
            self.deal_with_channel()
        else:
            print("************************************************")
            print("...your command:%s can't understand..." % command)
            self.deal_with_logined()

    def deal_with_p2p(self):
        print("**************************************************")
        print("you can input '%s' to logout" % COMMAND_LOGOUT)
        print("Please enter the target account......")
        target_account = raw_input("Input Target Account:")
        if (self.check_command_logout(target_account)):
            return

        if (self.check_account(target_account)):
            self.into_p2p_conversation(target_account)
        else:
            print("**************************************************")
            print("Please recheck the targetAccount,it has format error")
            self.deal_with_p2p()

    def into_p2p_conversation(self, target_account):
        self.current_account_dialogue_records = self.account_dialogue_records.get(target_account)
        print("***************************************************")
        if (self.current_account_dialogue_records == None):
            self.current_account_dialogue_records = []
            self.account_dialogue_records[target_account] = self.current_account_dialogue_records
        else:
            for dialogue_record in self.current_account_dialogue_records:
                print(dialogue_record.acount + ":" + dialogue_record.dialogue)

        print("************above is history record :%d**************" % len(self.current_account_dialogue_records))
        print("you can send message now and input '%s' to leave this session" % COMMAND_LEAVE_CHERT)
        print("*********************%s**************************" % target_account)
        thread.start_new_thread(self.send_p2p_msg, (target_account,))

    def send_p2p_msg(self, target_account):
        msg = raw_input()
        if self.check_command_leave(msg):
            return

        class MyMessageCallBack(LoginSession.MessageCallback):

            def on_msg_send_success(mscSelf, session):
                dialogueRecord = DialogueRecord(self.current_user.account, msg, time.time())
                self.current_account_dialogue_records.append(dialogueRecord)
                print(self.current_user.account + ":" + msg)
                thread.start_new_thread(self.send_p2p_msg, (target_account,))

            def on_msg_send_error(mscSelf, session, err_code):
                print(self.current_user.account + " msg send error")
                self.send_p2p_msg(target_account)

        m_m_c_b = MyMessageCallBack()
        self.current_user.session.msg_instant_send(target_account, msg, m_m_c_b)

    def deal_with_channel(self):
        print("************************************************")
        print("you can input '" + COMMAND_LOGOUT + "' to logout....")
        print("Please enter the channel name.....")
        channel_name = raw_input("channel name:")
        if (self.check_command_logout(channel_name)):
            return

        if (self.check_channel(channel_name)):
            self.join_channel(channel_name)
        else:
            print("**************************************************")
            print("Please recheck the channel name,it has format error")
            self.deal_with_logined()

    def join_channel(self, channel_name):

        class MyChannelCallBack(Channel.ChannelCallback):

            def on_channel_joined(_self, login_session, channel):
                self.into_channel_conversation(channel_name)

            def on_msg_channel_received(_self, login_session, channel, account, uid, msg):
                if (self.current_channel_dialogue_records != None):
                    print(account + ":" + msg)
                    self.current_channel_dialogue_records.append(DialogueRecord(account, msg, time.time()))
                    if account == self.current_user.account:
                        thread.start_new_thread(self.send_channel_msg, ())

            def on_channel_user_joined(_self, login_session, channel, account, uid):
                print("...%s joined channel..." % account)

            def on_channel_user_left(_self, login_session, channel, account, uid):
                print("...%s leave channel..." % account)

            def on_channel_left(_self, login_session, channel, err_code):
                print("*************leave channel*************")

        m_c_c_b = MyChannelCallBack()
        channel = self.current_user.session.channel_join(channel_name, m_c_c_b)
        self.current_user.channel = channel

    def into_channel_conversation(self, channelName):
        print("******************channel:%s***************" % channelName)
        self.current_channel_dialogue_records = self.channel_dialogue_records.get(channelName)
        if (self.current_channel_dialogue_records == None):
            self.current_channel_dialogue_records = []
            self.channel_dialogue_records[channelName] = self.current_channel_dialogue_records
        else:
            for dialogue_record in self.current_channel_dialogue_records:
                print("%s:%s" % (dialogue_record.acount, dialogue_record.dialogue))

        print("****above is history record :%d****" % len(self.current_channel_dialogue_records))
        print("you can send message now and input '%s' to leave" % COMMAND_LEAVE_CHERT)
        thread.start_new_thread(self.send_channel_msg, ())

    def send_channel_msg(self):
        msg = raw_input()
        if not self.check_command_leave(msg, True):
            self.current_user.channel.msg_channel_send(msg)
