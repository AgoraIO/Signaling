//
//  ChatViewController.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 12/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa
import AgoraSigKit

enum TextFieldActive {
    case FriendNameTextFieldActive, ChannelTextFieldActive, OtherTextFieldActive
}

protocol ChatViewControllerDelegate {
    func chatViewControllerDismiss(_ chatVC : ChatViewController)
}

class ChatViewController: NSViewController {

    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var currentAccountLabel: NSTextField!
    @IBOutlet weak var friendNameTextField: InputTextField!
    @IBOutlet weak var friendNameLabel: NSTextField!
    
    @IBOutlet weak var channelTextField: InputTextField!
    @IBOutlet weak var messageTextField: NSTextField!
    @IBOutlet weak var msgTableView: MessageTableView!
    
    @IBOutlet weak var peerView: BlackBorderView!
    @IBOutlet weak var channelView: BlackBorderView!
    
    
    fileprivate var agoraAPI : AgoraAPI!
    fileprivate var textFieldActive : TextFieldActive!
    fileprivate var currentChannelCount : Int!
    
    var delegate : ChatViewControllerDelegate?
    var currentAccountStr : String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldActive = .OtherTextFieldActive
        setupViews()
        getAgoraAPIAndAddCallBack()
    }
        
    //MARK: <Click Action>
    @IBAction func backAction(_ sender: NSButton) {
        agoraAPI.logout()
        delegate?.chatViewControllerDismiss(self)
    }
    
    @IBAction func sendMessageClick(_ sender: NSButton) {
        
        sendMessage()
    }
    
}

private extension ChatViewController {
    
    func setupViews() {
        peerView.wantsLayer = true
        channelView.wantsLayer = true
        
        currentAccountLabel.stringValue = currentAccountStr
        currentAccountLabel.delegate = self
        friendNameTextField.delegate = self
        friendNameTextField.responderDelegate = self
        channelTextField.delegate = self
        channelTextField.responderDelegate = self
        peerView.delegate = self
        channelView.delegate = self
        messageTextField.delegate = self
    }
    
    //MARK: <Agora Signal Call Back>
    func getAgoraAPIAndAddCallBack() {
    
        agoraAPI = AgoraAPI.getInstanceWithoutMedia(KeyCenter.appID)
        
        agoraAPI.onQueryUserStatusResult =  {(name,status) -> () in
            
            DispatchQueue.main.async { [unowned self]  in
                if self.friendNameTextField.stringValue == name {
                    
                    if status! == "1" {
                        self.friendNameLabel.stringValue = self.friendNameTextField.stringValue + "(Online)"
                    }
                    else {
                        self.friendNameLabel.stringValue = self.friendNameTextField.stringValue + "(Offline)"
                    }
                    
                }
            }
            
        }
        
        agoraAPI.onMessageInstantReceive = { (account, uid, message) -> () in

            DispatchQueue.main.async { [unowned self]  in
                
                let messageModel = MessageModel(text: message, account: account, uid: uid, isOther: true)
                self.msgTableView.addNewMsg(message: messageModel, currentChat: self.friendNameTextField.stringValue)
            }
            
        }
        
        agoraAPI.onMessageChannelReceive = { (channelID, account, uid, msg) -> () in
            
            
            if self.currentAccountStr == account! {
                return
            }
            
            let chaID = UInt32((channelID! as NSString).intValue)
            
            DispatchQueue.main.async { [unowned self]  in
                
                let messageModel = MessageModel(text: msg, account: account, uid: chaID, isOther: true)
                self.msgTableView.addNewMsg(message: messageModel, currentChat: self.channelTextField.stringValue)
            }
        }
        
        agoraAPI.onChannelJoined = { (channelID) -> () in
            print("Self Join Channel Success")
        }
        
        agoraAPI.onChannelJoinFailed = { (channelID, ecode) -> () in
            print("Self Join Channel Fail")
        }
        
        agoraAPI.onChannelUserList = { (accounts, uids) -> () in
            
            DispatchQueue.main.async { [unowned self]  in
                self.currentChannelCount = accounts?.count
                self.friendNameLabel.stringValue = self.channelTextField.stringValue + "(" + String(self.currentChannelCount) + ")"
            }
        }
        
        agoraAPI.onChannelUserJoined = { (account, uid) -> () in
            
            DispatchQueue.main.async { [unowned self]  in
                self.currentChannelCount = self.currentChannelCount + 1
                self.friendNameLabel.stringValue = self.channelTextField.stringValue + "(" + String(describing: self.currentChannelCount) + ")"
            }
        }
        
        agoraAPI.onChannelUserLeaved = { (account, uid) -> () in
            
            DispatchQueue.main.async { [unowned self]  in
                self.currentChannelCount = self.currentChannelCount - 1
                self.friendNameLabel.stringValue = self.channelTextField.stringValue + "(" + String(describing: self.currentChannelCount) + ")"
            }
        }
        
        agoraAPI.onMessageSendSuccess = { (messageID) -> () in
            print("Message Send Success")
        }
        
        
        agoraAPI.onMessageSendError = { (messageID, ecode) -> () in
            print("Message Send Error: \(ecode)")
        }
        
        agoraAPI.onLogout = { (ecode) -> () in
            
            DispatchQueue.main.async { [unowned self]  in
                self.delegate?.chatViewControllerDismiss(self)
            }
        
        }
        
    }
    
    func startChatWithFriend() {
        
        leaveChannel()
        
        if friendNameTextField.stringValue.count != 0 {
            agoraAPI.queryUserStatus(friendNameTextField.stringValue)
        }
        
        msgTableView.changeRecord(with: friendNameTextField.stringValue)
        
        friendNameTextField.abortEditing()
        
        
        peerView.layer?.backgroundColor = NSColor(calibratedRed: 68.0 / 255, green: 159.0 / 255, blue: 227.0 / 255, alpha: 1.0).cgColor
    }
    
    func startChatInChannel() {
        
        if channelTextField.stringValue.count != 0 {
            agoraAPI.channelJoin(channelTextField.stringValue)
        }
        // Custome Prefix to distinguish peer to peer and channel when they have the same title
        let channel = "010203" + channelTextField.stringValue

        msgTableView.changeRecord(with: channel)
        channelTextField.abortEditing()
        
        channelView.layer?.backgroundColor = NSColor(calibratedRed: 68.0 / 255, green: 159.0 / 255, blue: 227.0 / 255, alpha: 1.0).cgColor
    }
    
    func leaveChannel() {
        
        agoraAPI.channelLeave(channelTextField.stringValue)
        let channel = "010203" + channelTextField.stringValue
        if channelTextField.stringValue.count == 0 {
            return
        }
      
        msgTableView.removeChannelReocrd(with: channel)
    }
    
    func sendMessage() {
        
        if textFieldActive == .FriendNameTextFieldActive && friendNameTextField.stringValue.count != 0 {
            
            if friendNameTextField.stringValue == currentAccountStr {
                messageTextField.stringValue = ""
                return
            }
            
            agoraAPI.messageInstantSend(friendNameTextField.stringValue, uid: 0, msg: messageTextField.stringValue, msgID: String(arc4random_uniform(100)))
            let message = MessageModel(text: messageTextField.stringValue, account: currentAccountStr, uid: 0, isOther: false)
            msgTableView.addNewMsg(message: message, currentChat: friendNameTextField.stringValue)
        }
        else if textFieldActive == .ChannelTextFieldActive && channelTextField.stringValue.count != 0 {
            agoraAPI.messageChannelSend(channelTextField.stringValue, msg: messageTextField.stringValue, msgID: String(arc4random_uniform(100)))
            let message = MessageModel(text: messageTextField.stringValue, account: currentAccountStr, uid: 0, isOther: false)
            msgTableView.addNewMsg(message: message, currentChat: channelTextField.stringValue)
        }
        messageTextField.stringValue = ""
    }
    
    func whichTextFieldActiveNow(textField : NSTextField) {
        
        if textField == friendNameTextField {
            textFieldActive = .FriendNameTextFieldActive
        }
        else if textField == channelTextField {
            textFieldActive = .ChannelTextFieldActive
        }
        
    }
    
}


//MARK: <NSTextFieldDelegate> Return Click
extension ChatViewController : NSTextFieldDelegate {
 
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        
        whichTextFieldActiveNow(textField: control as! NSTextField)
        
        if commandSelector.description == "insertNewline:" {
            
            // Send Message
            if control as? NSTextField == messageTextField {
                sendMessage()
                return false
            }
            
            if textFieldActive == .FriendNameTextFieldActive {
                startChatWithFriend()
            }
            else if textFieldActive == .ChannelTextFieldActive {
                startChatInChannel()
            }
            
        }

        return false
    }
    
    func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        
        whichTextFieldActiveNow(textField: control as! NSTextField)
        
        return true
    }

}

//MARK: <InputTextFieldDelegate>
extension ChatViewController : InputTextFieldDelegate {
    
    func inputTextFieldBecomeFirstResponder(_ textField: InputTextField) {
        
        if friendNameTextField == textField {
            textFieldActive = .FriendNameTextFieldActive
        }
        else if channelTextField == textField {
            textFieldActive = .ChannelTextFieldActive
        }
        else {
            textFieldActive = .OtherTextFieldActive
        }
    }
    
}

//MARK: <BlackBorderViewDelegate>
extension ChatViewController : BlackBorderViewDelegate {
    
    func blackBorderViewMouseDown(_ touchedView: BlackBorderView) {
        
        if textFieldActive == TextFieldActive.FriendNameTextFieldActive {
            startChatWithFriend()
        }
        else if textFieldActive == TextFieldActive.ChannelTextFieldActive {
            startChatInChannel()
        }
        
    }
    
}

