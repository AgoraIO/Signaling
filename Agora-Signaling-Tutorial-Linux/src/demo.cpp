
#include "agora_sig.h"
#include <iostream>
#include <vector>
#include <string.h>
#include <thread>
#include <sstream>
#include <unistd.h>
#include <pthread.h>
#include <vector>
#include <map>
#include <algorithm>
using namespace agora_sdk_cpp;
using namespace std;

IAgoraAPI *agora ;
IAgoraAPI* createAgoraSDKInstance();


typedef struct{
  string name;
  uint32_t uid;
}User;
vector<User> peers;

typedef vector<string> ChatHisV_t;
ChatHisV_t ChatHisV;
typedef map<string,ChatHisV_t> P2PChatHisMap_t;
P2PChatHisMap_t P2PChatHisMap;

string g_vendor = "";
string g_username = "";
string g_token = "_no_need_token";
uint32_t g_uid = 0;
string g_channel = "";

int g_call_n = 0;

bool g_queried = false;
bool g_reconnect = false;

bool isJoinChannel = false;
bool stopped = false;


static void do_login(){
  cout << "Login as " << g_username << " ..." << endl;
	agora->login(g_vendor.data(),g_vendor.size(),g_username.data(),g_username.size(),g_token.data(),g_token.size(),g_uid,"",0);
}

void saveP2PChatHistory(const string& account, const string& msg, int direction/*0:send, 1:recv*/){
  P2PChatHisMap_t::iterator iter = P2PChatHisMap.find(string(account));
  string chatHis = "";
  if(direction == 0){
    chatHis = "me:"+msg;
  }else{
    chatHis = account+":"+msg;
  }
  if(iter == P2PChatHisMap.end()){
    ChatHisV.push_back(chatHis);
    P2PChatHisMap.insert(std::make_pair(account, ChatHisV));
    return;
  }
  iter->second.push_back(chatHis);
}
template<typename T>
void printer(const T& val)
{
  cout << val ;
}
void ShowVec(const vector<string>& valList)
{
  for_each(valList.cbegin(), valList.cend(), printer<string>);
}
void displayP2PChatHis(string& account){
  if(account.empty()){
    cout<<"displayP2PChatHis but peername is empty"<<endl;return;
  }
  P2PChatHisMap_t::iterator iter = P2PChatHisMap.find(string(account));
  if(iter == P2PChatHisMap.end()){
    cout<<"no more history!"<<endl;
    return;
  }
	
  ShowVec(iter->second);

}


class CallBack : public ICallBack{
  virtual void onLoginSuccess(uint32_t uid, int fd) override {
    cout << "onLoginSuccess, uid:"<<uid<<endl;
  }
  virtual void onMessageAppReceived(char const * msg, size_t msg_size)  override{
    cout << "onMessageAppReceived " << msg << endl;
  }
  virtual void onChannelQueryUserNumResult(char const * channelID, size_t channelID_size,int ecode,int num)  override {
    cout << "onChannelQueryUserNumResult:" << channelID <<",ecode:"<<ecode << ",num:" << num << endl;
    if (ecode==0){
      g_queried = true;
      if (g_reconnect) 
        agora->logout();
    }
  }
  virtual void onLoginFailed(int ecode)  override{
    cout << "onLoginFailed : ecode = " << ecode << endl;
    stopped = true;
  }
  virtual void onLogout(int ecode)  override{
    cout << "onLogout : ecode = " << ecode << endl;
    stopped = true;
  }
  bool call_next(){
    if (size_t(g_call_n)<peers.size()){
      User &u = peers[g_call_n++];
      if (u.uid == 1){
        cout << "Invite phone : " << u.name << " to channel ..." << endl;
        agora->channelInvitePhone(g_channel.data(), g_channel.size(), u.name.data(), u.name.size());
      }else{
        cout << "Invite user : " << u.name << "(" << u.uid << ") to channel ..." << endl;
        agora->channelInviteUser(g_channel.data(), g_channel.size(),u.name.data(), u.name.size(),u.uid);
      }
			  return true;
    }
    return false;
  }
  virtual void onChannelLeaved(char const * channelID, size_t channelID_size,int ecode) {
    cout<<"onChannelLeaved channelID:"<<channelID<<",ecode:"<<ecode<<endl;
  }
  virtual void onChannelJoined(char const * channelID, size_t channelID_size)  override{
    cout << "onChannelJoined Join channel successfully." << endl;
  }

  virtual void onChannelUserJoined(char const * account, size_t account_size,uint32_t uid)  override{
    cout << "Event : " << account << ":" << uid << " joined" << endl;
  }
  virtual void onChannelUserLeaved(char const * account, size_t account_size,uint32_t uid)  override{
    cout << "Event : " << account << ":" << uid << " leaved" <<  endl;
  }
  virtual void onChannelUserList(int n, char **accounts, uint32_t* uids)  override{
    cout << "Channel User list : " <<  endl;
    for(int i=0;i<n;i++){
      cout << accounts[i] << ":" << uids[i] <<  endl;
    }
  }

  virtual void onInviteReceived(char const * channelID, size_t channelID_size,char const * account, size_t account_size,uint32_t uid, char const * extra, size_t extra_size)  override{
    cout << "Received invitation from " << account << " join channel : " << channelID << endl;
    cout << "Joining " << channelID << endl;
    agora->channelJoin(channelID, channelID_size);

    cout << "Accept invitaction from " << account << endl;
    agora->channelInviteAccept(channelID, channelID_size,account, account_size,uid, "", 0);
  }
  virtual void onInviteReceivedByPeer(char const * channelID, size_t channelID_size,char const * account, size_t account_size,uint32_t uid)  override{
    cout << "Invitation received by " << account << "" << endl;
  }

  virtual void onInviteAcceptedByPeer(char const * channelID, size_t channelID_size,char const * account, size_t account_size,uint32_t uid, char const * extra, size_t extra_size)  override{
    cout << "Invitation acceptd by " << account << endl;
  call_next();
  }

  virtual void onInviteRefusedByPeer(char const * channelID, size_t channelID_size,char const * account, size_t account_size,uint32_t uid, char const * extra, size_t extra_size)  override{
    cout << "Invitation refused by " << account << endl;
  }

  virtual void onInviteEndByPeer(char const * channelID, size_t channelID_size,char const * account, size_t account_size,uint32_t uid, char const * extra, size_t extra_size)  override{
    cout << "Invitation end by " << account << endl;
  }

  virtual void onLog(char const * txt, size_t txt_size)  override{
    //cout << "LOG:" << txt << endl;
  }

  virtual void onMessageInstantReceive(char const * account, size_t account_size,uint32_t uid,char const * msg, size_t msg_size)  override{
    cout << "onMessageInstantReceive from " << account << ",message is:"  << msg << endl;
    saveP2PChatHistory(string(account), string(msg), 1);
  }
  virtual void onMessageChannelReceive(char const * channelID, size_t channelID_size,char const * account, size_t account_size,uint32_t uid,char const * msg, size_t msg_size)  override{
    if(account != g_username)
      cout << "onMessageChannelReceive " << channelID << " from " << account <<",message:"<< msg << endl;
  }
  virtual void onChannelQueryUserIsIn(char const * channelID, size_t channelID_size,char const * account, size_t account_size,int isIn) {
    isJoinChannel = true;
  }
  virtual void onMessageSendError(char const * messageID, size_t messageID_size,int ecode) {
    cout<<"send messageID:"<<messageID <<" failed,error code:"<<ecode<<endl;  
  }
  virtual void onMessageSendSuccess(char const * messageID, size_t messageID_size) {
    cout<<"messageID:"<<messageID<<" send success!"<<endl;
  }
};

uint32_t my_atol(char *n){
	uint32_t x=0;
	while(*n){
		x = x*10 + (*n)-'0';
		n++;
	}
	return x;
}

void p2pHelp(){
  cout<<"Please input ' sendmsg $message' to send p2p message"<<endl;
  cout<<"Please input ' quitp2p ' to quit p2p chat"<<endl;
}
void help(){
  cout<<"Please input ' switchp2p $somebody ' to chat with someone!"<<endl;
  cout<<"Please input ' switchp2c $oneChannel ' to chat in the channel!"<<endl;
  cout<<"Please input ' quit ' to logout!"<<endl;
}
void p2cHelp(){
  cout<<"Please input ' sendmsg $msg ' to send channel message" <<endl;
  cout<<"Please input ' leave ' to leave channel chat"<<endl;
}
string getSendMsgContent(const string& commands){
  string content = "";
  size_t pos = commands.find_first_of(" ");
  if(pos == std::string::npos){
    content = "";
  }else{
    content = commands.substr(pos+1);
  }
  return content;
}
char commands[999] = {0};
string msgID = "";
string dump = "";
void optInChannel(){
  while(fgets(commands, sizeof(commands)-1, stdin)){
    if(strncmp(commands,"sendmsg",strlen("sendmsg"))==0){
      //istringstream is(commands);
      string msg = "";
      //is>>dump>>msg;
      msg = getSendMsgContent(commands);
      cout<<"[optInChannel]: sendmsg:"<<msg<<endl;
      agora->messageChannelSend(g_channel.c_str(), g_channel.size(),msg.data(), msg.size(),msgID.data(), msgID.size());
      cout<<"send channel messge done!"<<endl;
    }else if(strncmp(commands,"leave",strlen("leave"))==0){
      agora->channelLeave(g_channel.data(), g_channel.size()); 
      break;
    }else if(strncmp(commands,"helpp2c",strlen("helpp2c"))==0){
      p2cHelp();
    }else{
      cout<<"Please input helpp2c!"<<endl;
    }
  }
}
void opP2PChat(string& account){
  while(fgets(commands, sizeof(commands)-1, stdin)){
    if(strncmp(commands,"sendmsg",strlen("sendmsg"))==0){ //sendmsg &msg 
      string msg,MsgID = "";
      //istringstream is(commands);
      //is>>dump>>msg;
      msg = getSendMsgContent(commands);
      cout<<"send to:"<<g_username<<", message is:"<<msg<<endl;
      saveP2PChatHistory(account, msg, 0);
      agora->messageInstantSend(account.c_str(), account.size(), 0, msg.data(), msg.size(),msgID.data(), msgID.size());
    }
    else if(strncmp(commands,"quitp2p",strlen("quitp2p"))==0){
      cout<<"quit p2p chat now..."<<endl;
      break;
    }
    else if(strncmp(commands,"helpp2p",strlen("helpp2p"))==0){
      p2pHelp();
    }
    else{
      cout<<"Please input helpp2p!"<<endl;
      continue;
    }
    usleep(1000*15);//sleep 15 ms
  }
}
void do_business(){
  cout << "thead:"<<this_thread::get_id()<<endl;
  string dump;
  while(fgets(commands, sizeof(commands)-1, stdin)){
    if(strncmp(commands,"switchp2p",strlen("switchp2p"))==0){//switch p2p chat!
      istringstream is(commands);
      std::string dump, account = "";
      is>>dump>>account;
      cout<<"chat with "<< account <<" now"<<endl;
      cout<<"history..."<<endl;
      displayP2PChatHis(account);
      opP2PChat(account);
    }
    else if(strncmp(commands,"switchp2c",strlen("switchp2c"))==0){//switch p2c chat!
      istringstream is(commands);
      string channel="";
      is>>dump>>channel;
      if(channel.empty()){
        cout<<"channel is empty,please retry it!"<<endl;
        continue;
      }
      cout<<"switchp2c channel:"<<channel<<endl;
      g_channel = channel;
      //auto join this channel!
      agora->channelJoin(g_channel.data(), g_channel.size());
      optInChannel();
    }
    else if(strncmp(commands, "quit", strlen("quit")) == 0){
      istringstream is(commands);
      agora->logout();
      break;
    }
    else if(strncmp(commands,"help",strlen("help"))==0){
      help();
    }
    else{
      cout<<"Please input help!"<<endl;
      continue;
    }
    usleep(1000*10);//sleep 1 ms
  }
}
std::thread businessThread;

int main(int argc, char** argv){
  agora = getAgoraSDKInstanceCPP();
	agora->callbackSet(new CallBack());
	ICallBack *cb = agora->callbackGet();

  if (argc!=4){
    printf(" Usage : ./sig_demo [vendorKey] [userName] [uid] \n");
    exit(-1);
  }
  cout<<"argc:"<<argc<<endl;
  int i=1;
  g_vendor = argv[i++];
  g_username = argv[i++];
  if(g_username.find(" ") != std::string::npos){
    cout<<"username cannot contain space!"<<endl;
    return 0;
  }
  
  g_uid = my_atol(argv[i++]);
  
  do_login();
  businessThread = std::thread(do_business);
  businessThread.detach();
	//agora->start();
  while(!stopped){
    usleep(1000*10);
  }
  cout << "Bye" << endl;
}

