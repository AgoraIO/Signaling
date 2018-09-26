//
//  ChatViewController.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 04/12/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var chatAccountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout"), style: .plain, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAgoraSignalBlock()
    }
    
    @objc func logout() {
        AgoraSignal.Kit.logout()
    }
    
    @IBAction func chatButtonClicked(_ sender: UIButton) {
        guard let chatAccount = chatAccountTextField.text else {
            return
        }
        if !check(String: chatAccount) {
            return
        }
        self.performSegue(withIdentifier: "ShowChatRoom", sender: chatAccount)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatRoomVC = segue.destination as! ChatRoomViewController
        chatRoomVC.account = sender as! String
        if chatMessages[chatRoomVC.account] != nil {
            chatRoomVC.messageList = chatMessages[chatRoomVC.account]!
        } else {
            chatRoomVC.messageList.identifier = chatRoomVC.account
        }
    }
    
    func addAgoraSignalBlock() {
        AgoraSignal.Kit.onLogout = { [weak self] (ecode) -> () in
            DispatchQueue.main.async(execute: {
                self?.dismiss(animated: true, completion: nil)
            })
        }
        
        AgoraSignal.Kit.onMessageInstantReceive = { (account, uid, msg) -> () in
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

extension ChatViewController {
    func check(String: String) -> Bool {
        if String.isEmpty {
            alert(string: "The account is empty !")
            return false
        }
        if String.count > 128 {
            alert(string: "The accout is longer than 128 !")
            return false
        }
        if String.contains(" ") {
            alert(string: "The accout contains space !")
            return false
        }
        return true
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
}
