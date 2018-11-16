//
//  ChannelRoomViewController.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 07/12/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import UIKit

class ChannelRoomViewController: UIViewController {
    @IBOutlet weak var channelRoomTableView: UITableView!
    @IBOutlet weak var channelRoomContainBottom: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: UITextField!
    
    var channelName: String!
    
    var messageList = MessageList()
    
    var userNum = 0 {
        didSet {
            DispatchQueue.main.async(execute: {
                self.title = self.channelName + " (\(String(self.userNum)))"
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.channelRoomTableView.rowHeight = UITableView.automaticDimension
        self.channelRoomTableView.estimatedRowHeight = 50
        
        AgoraSignal.Kit.channelQueryUserNum(channelName)
        
        messageList.identifier = channelName
        
        addKeyboardObserver()
        addTouchEventToTableView(self.channelRoomTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAgoraSignalBlock()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AgoraSignal.Kit.channelLeave(channelName)
    }
    
    func addAgoraSignalBlock() {
        AgoraSignal.Kit.onMessageSendError = { [weak self] (messageID, ecode) -> () in
            self?.alert(string: "Message send failed with error: \(ecode.rawValue)")
        }
        
        AgoraSignal.Kit.onMessageChannelReceive = { [weak self] (channelID, account, uid, msg) -> () in
            DispatchQueue.main.async(execute: {
                let message = Message(account: account, message: msg)
                self?.messageList.list.append(message)
                self?.updateTableView((self?.channelRoomTableView)!, with: message)
                self?.inputTextField.text = ""
            })
        }
        
        AgoraSignal.Kit.onChannelQueryUserNumResult = { [weak self] (channelID, ecode, num) -> () in
            self?.userNum = Int(num)
        }
        
        AgoraSignal.Kit.onChannelUserJoined = { [weak self] (account, uid) -> () in
            self?.userNum += 1
        }
        
        AgoraSignal.Kit.onChannelUserLeaved = { [weak self] (account, uid) -> () in
            self?.userNum -= 1
        }
    }
}

extension ChannelRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let message = inputTextField.text else { return false }
        
        AgoraSignal.Kit.messageChannelSend(channelName, msg: message, msgID: String(messageList.list.count))
        
        return true
    }
}

extension ChannelRoomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myAccount = UserDefaults.standard.string(forKey: "myAccount")
        if messageList.list[indexPath.row].account != myAccount {
            if userColor[messageList.list[indexPath.row].account] == nil {
                userColor[messageList.list[indexPath.row].account] = UIColor.randomColor()
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

private extension ChannelRoomViewController {
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
                    strongSelf.channelRoomContainBottom.constant = deltaY
                    strongSelf.view?.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                strongSelf.channelRoomContainBottom.constant = deltaY
            }
            if strongSelf.messageList.list.count > 0 {
                let insterIndexPath = IndexPath(row: strongSelf.messageList.list.count - 1, section: 0)
                strongSelf.channelRoomTableView.scrollToRow(at: insterIndexPath, at: .bottom, animated: false)
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
                    strongSelf.channelRoomContainBottom.constant = 0
                    strongSelf.view?.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                strongSelf.channelRoomContainBottom.constant = 0
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
