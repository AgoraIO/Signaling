//
//  MainViewController.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 29/11/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import UIKit
import AgoraSigKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var accoutTextField: UITextField!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.versionLabel.text = self.getSdkVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAgoraSignalBlock()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        guard let account = accoutTextField.text else {
            return
        }
        if !check(String: account) {
            return
        }
        
        AgoraSignal.Kit.login2(KeyCenter.AppId, account: account, token: "_no_need_token", uid: 0, deviceID: nil, retry_time_in_s: 60, retry_count: 5)
        
        let lastAccount = UserDefaults.standard.string(forKey: "myAccount")
        if lastAccount != account {
            let userDefault = UserDefaults.standard
            userDefault.set(account, forKey: "myAccount")
            chatMessages.removeAll()
        }
        
        if userColor[account] == nil {
            userColor[account] = UIColor.randomColor()
        }
    }
    
    func addAgoraSignalBlock() {
        AgoraSignal.Kit.onLoginSuccess = { [weak self] (uid,fd) -> () in
            DispatchQueue.main.async(execute: {
                self?.performSegue(withIdentifier: "loginSegue", sender: self)
            })
        }
        
        AgoraSignal.Kit.onLoginFailed = { [weak self] (ecode) -> () in
            self?.alert(string: "Login failed with error: \(ecode.rawValue)")
        }
        
        AgoraSignal.Kit.onLog = { (txt) -> () in
            guard var log = txt else {
                return
            }
            let time = log[..<log.index(log.startIndex, offsetBy: 10)]
            let dformatter = DateFormatter()
            let timeInterval = TimeInterval(Int(time)!)
            let date = Date(timeIntervalSince1970: timeInterval)
            dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            log.replaceSubrange(log.startIndex..<log.index(log.startIndex, offsetBy: 10), with: dformatter.string(from: date) + ".")
            
            LogWriter.write(log: log)
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
    
    func getSdkVersion() -> String {
        var version = String(AgoraSignal.Kit.getSdkVersion())
        for _ in 0 ..< 2 {
            version.removeFirst()
        }
        for (index, ch) in version.enumerated() {
            if index < 6 && index % 2 == 1 {
                if ch == "0" {
                    version.remove(at: version.index(version.startIndex, offsetBy: index))
                    version.insert(".", at: version.index(version.startIndex, offsetBy: index))
                }
            }
        }
        return "Version " + version
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
