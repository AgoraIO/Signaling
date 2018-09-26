
package model;

import io.agora.signal.Signal;
import io.agora.signal.Signal.LoginSession;
import io.agora.signal.Signal.LoginSession.Channel;

import java.util.concurrent.CountDownLatch;

public class User {
	

	public User(LoginSession session, String account, int uid) {
		super();
		this.session = session;
		this.account = account;
		this.uid = uid;
	}
	
	private Signal.LoginSession session;
	private Channel channel;
	private String account;
	private int uid;
    private CountDownLatch loginLatch;
    private CountDownLatch logoutLatch = new CountDownLatch(1);
	public Signal.LoginSession getSession() {
		return session;
	}
	public void setSession(Signal.LoginSession session) {
		this.session = session;
	}
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	public int getUid() {
		return uid;
	}
	public void setUid(int uid) {
		this.uid = uid;
	}
	public CountDownLatch getLoginLatch() {
		return loginLatch;
	}
	public CountDownLatch getLogoutLatch() {
		return logoutLatch;
	}
	public void setLoginLatch(CountDownLatch loginLatch) {
		this.loginLatch = loginLatch;
	}
	public Channel getChannel() {
		return channel;
	}
	public void setChannel(Channel channel) {
		this.channel = channel;
	}
	
}
