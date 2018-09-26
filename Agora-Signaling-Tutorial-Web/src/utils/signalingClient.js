/**
 * Wrapper for Agora Signaling SDK
 * Transfer some action to Promise and use Event instead of Callback
 */
import EventEmitter from 'events';

export default class SignalingClient {
  constructor(appId, appcertificate) {
    this._appId = appId;
    this._appcert = appcertificate;
    // Init signal using signal sdk
    this.signal = Signal(appId) // eslint-disable-line 
    // init event emitter for channel/session/call
    this.channelEmitter = new EventEmitter();
    this.sessionEmitter = new EventEmitter();
  }

  /**
   * @description login agora signaling server and init 'session'
   * @description use sessionEmitter to resolve session's callback
   * @param {String} account
   * @param {*} token default to be omitted
   * @returns {Promise}
   */
  login(account, token = '_no_need_token') {
    this.account = account;
    return new Promise((resolve, reject) => {
      this.session = this.signal.login(account, token);
      // Proxy callback on session to sessionEmitter
      [
        'onLoginSuccess',
        'onError',
        'onLoginFailed',
        'onLogout',
        'onMessageInstantReceive',
        'onInviteReceived'
      ].map(event => {
        return (this.session[event] = (...args) => {
          this.sessionEmitter.emit(event, ...args);
        });
      });
      // Promise.then
      this.sessionEmitter.once('onLoginSuccess', uid => {
        this._uid = uid;
        resolve(uid);
      });
      // Promise.catch
      this.sessionEmitter.once('onLoginFailed', (...args) => {
        reject(...args);
      });
    });
  }

  /**
   * @description logout agora signaling server
   * @returns {Promise}
   */
  logout() {
    return new Promise((resolve, reject) => {
      this.session.logout();
      this.sessionEmitter.once('onLogout', (...args) => {
        resolve(...args);
      });
    });
  }

  /**
   * @description join channel
   * @description use channelEmitter to resolve channel's callback
   * @param {String} channel
   * @returns {Promise}
   */
  join(channel) {
    this._channel = channel;
    return new Promise((resolve, reject) => {
      if (!this.session) {
        throw {
          Message: '"session" must be initialized before joining channel'
        };
      }
      this.channel = this.session.channelJoin(channel);
      // Proxy callback on channel to channelEmitter
      [
        'onChannelJoined',
        'onChannelJoinFailed',
        'onChannelLeaved',
        'onChannelUserJoined',
        'onChannelUserLeaved',
        'onChannelUserList',
        'onChannelAttrUpdated',
        'onMessageChannelReceive'
      ].map(event => {
        return (this.channel[event] = (...args) => {
          this.channelEmitter.emit(event, ...args);
        });
      });
      // Promise.then
      this.channelEmitter.once('onChannelJoined', (...args) => {
        resolve(...args);
      });
      // Promise.catch
      this.channelEmitter.once('onChannelJoinFailed', (...args) => {
        this.channelEmitter.removeAllListeners()
        reject(...args);
      });
    });
  }

  /**
   * @description leave channel
   * @returns {Promise}
   */
  leave() {
    return new Promise((resolve, reject) => {
      if (this.channel) {
        this.channel.channelLeave();
        this.channelEmitter.once('onChannelLeaved', (...args) => {
          this.channelEmitter.removeAllListeners()
          resolve(...args);
        });
      } else {
        resolve();
      }
    });
  }

  /**
   * @description send p2p message
   * @description if you want to send an object, use JSON.stringify
   * @param {String} peerAccount
   * @param {String} text
   */
  sendMessage(peerAccount, text) {
    this.session && this.session.messageInstantSend(peerAccount, text);
  }

  /**
   * @description broadcast message in the channel
   * @description if you want to send an object, use JSON.stringify
   * @param {String} text
   */
  broadcastMessage(text) {
    this.channel && this.channel.messageChannelSend(text);
  }
}
