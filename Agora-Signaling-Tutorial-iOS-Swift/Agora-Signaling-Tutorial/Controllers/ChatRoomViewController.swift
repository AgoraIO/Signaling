//
//  ChatRoomViewController.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 07/12/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {
    @IBOutlet weak var chatRoomContainView: UIView!
    @IBOutlet weak var chatRoomContainBottom: NSLayoutConstraint!
    @IBOutlet weak var chatRoomTableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var account: String!
    var isFirstLoad = true
    var timer: Timer!
    
    var isOnline = false {
        didSet {
            DispatchQueue.main.async(execute: {
                self.title = self.account + " (" + (self.isOnline ? "online" : "offline") + ")"
            })
        }
    }
    
    var messageList = MessageList()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatRoomTableView.rowHeight = UITableView.automaticDimension
        self.chatRoomTableView.estimatedRowHeight = 50

        checkStatus()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(checkStatus), userInfo: nil, repeats: true)
    
        addTouchEventToTableView(self.chatRoomTableView)
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        addAgoraSignalBlock()
    }

    override func viewDidAppear(_ animated: Bool) {
        if messageList.list.count == 0 {
            return
        }
        let insterIndexPath = IndexPath(row: self.messageList.list.count - 1, section: 0)
        self.chatRoomTableView.scrollToRow(at: insterIndexPath, at: .bottom, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)

        chatMessages[account] = messageList
        timer?.invalidate()
    }

    func addAgoraSignalBlock() {
        AgoraSignal.Kit.onQueryUserStatusResult = { [weak self] (name, status) -> () in
            if (self?.isFirstLoad)! {
                self?.isOnline = status == "1" ? true : false
                self?.isFirstLoad = false
                return
            }
            if status == "1" {
                if !(self?.isOnline)! {
                    self?.isOnline = true
                    return
                }
            } else {
                if (self?.isOnline)! {
                    self?.isOnline = false
                    return
                }
            }
        }
        
        AgoraSignal.Kit.onMessageSendSuccess = { [weak self] (messageID) -> () in
            let myAccount = UserDefaults.standard.string(forKey: "myAccount")
            DispatchQueue.main.async(execute: {
                let message = Message(account: myAccount, message: self?.inputTextField.text)
                self?.messageList.list.append(message)
                self?.updateTableView((self?.chatRoomTableView)!, with: message)
                self?.inputTextField.text = ""
            })
        }
        
        AgoraSignal.Kit.onMessageSendError = { [weak self] (messageID, ecode) -> () in
            self?.alert(string: "Message send failed with error: \(ecode.rawValue)")
        }
        
        AgoraSignal.Kit.onMessageInstantReceive = { [weak self] (account, uid, msg) -> () in
            if account == self?.account {
                DispatchQueue.main.async(execute: {
                    let message = Message(account: account, message: msg)
                    self?.messageList.list.append(message)
                    self?.updateTableView((self?.chatRoomTableView)!, with: message)
                    self?.inputTextField.text = ""
                })
            } else {
                if chatMessages[account!] == nil {
                    let message = Message(account: account, message: msg)
                    var messagelist = [Message]()
                    messagelist.append(message)
                    let chatMsg = MessageList(identifier: account, list: messagelist)
                    chatMessages[account!] = chatMsg
                    return
                }
                let message = Message(account: account, message: msg)
                chatMessages[account!]?.list.append(message)
            }
        }
    }
    
    @objc func checkStatus() {
        AgoraSignal.Kit.queryUserStatus(account)
    }
}

extension ChatRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let message = inputTextField.text else { return false }
        
        AgoraSignal.Kit.messageInstantSend(account, uid: 0, msg: message, msgID: String(messageList.list.count))
        
        return true
    }
}

extension ChatRoomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messageList.list[indexPath.row].account == account && account != UserDefaults.standard.string(forKey: "myAccount") {
            if userColor[account] == nil {
                userColor[account] = UIColor.randomColor()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftcell", for: indexPath) as! LeftCell
            cell.setCellViewWith(message: messageList.list[indexPath.row])
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightcell", for: indexPath) as! RightCell
        cell.setCellViewWith(message: messageList.list[indexPath.row])
        return cell
    }
}

private extension ChatRoomViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notify in
            guard let strongSelf = self, let userInfo = (notify as NSNotification).userInfo,
                let keyBoardBoundsValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
                let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
                    return
            }
            
            let keyBoardBounds = keyBoardBoundsValue.cgRectValue
            let duration = durationValue.doubleValue
            let deltaY = keyBoardBounds.size.height
            
            if duration > 0 {
                var optionsInt: UInt = 0
                if let optionsValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
                    optionsInt = optionsValue.uintValue
                }
                let options = UIView.AnimationOptions(rawValue: optionsInt)
                
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    strongSelf.chatRoomContainBottom.constant = deltaY
                    strongSelf.view?.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                strongSelf.chatRoomContainBottom.constant = deltaY
            }
            if strongSelf.messageList.list.count > 0 {
                let insterIndexPath = IndexPath(row: strongSelf.messageList.list.count - 1, section: 0)
                strongSelf.chatRoomTableView.scrollToRow(at: insterIndexPath, at: .bottom, animated: false)
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notify in
            guard let strongSelf = self else {
                return
            }
            
            let duration: Double
            if let userInfo = (notify as NSNotification).userInfo, let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
                duration = durationValue.doubleValue
            } else {
                duration = 0
            }
            
            if duration > 0 {
                var optionsInt: UInt = 0
                if let userInfo = (notify as NSNotification).userInfo, let optionsValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
                    optionsInt = optionsValue.uintValue
                }
                let options = UIView.AnimationOptions(rawValue: optionsInt)
                
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    strongSelf.chatRoomContainBottom.constant = 0
                    strongSelf.view?.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                strongSelf.chatRoomContainBottom.constant = 0
            }
        }
    }
    
    func alert(string: String) {
        guard !string.isEmpty else {
            return
        }
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: nil, message: string, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func updateTableView(_ tableView: UITableView, with message: Message) {
        let insterIndexPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [insterIndexPath], with: .none)
        tableView.endUpdates()
        tableView.scrollToRow(at: insterIndexPath, at: .bottom, animated: false)
    }
    
    func addTouchEventToTableView(_ tableView: UITableView) {
        let tableViewGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTouchInSide))
        tableViewGesture.numberOfTapsRequired = 1
        tableViewGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tableViewGesture)
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc func tableViewTouchInSide() {
        inputTextField.resignFirstResponder()
    }
}
