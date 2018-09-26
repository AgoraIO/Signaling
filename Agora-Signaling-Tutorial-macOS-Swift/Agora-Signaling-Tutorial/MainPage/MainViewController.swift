//
//  MainViewController.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 01/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa
import AgoraSigKit

class MainViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var accountTextField: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    fileprivate var agoraAPI : AgoraAPI!
    fileprivate var currentUID : UInt32!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountTextField.delegate = self
        
        initAgoraAPI()
        setupSignalCallBack()
    }
    
    @IBAction func loginBtnClick(_ sender: NSButton) {
        
      agoraAPI.login2(KeyCenter.appID, account: accountTextField.stringValue, token: "_no_need_token", uid: 0, deviceID: nil, retry_time_in_s: 5, retry_count: 10)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier , !segueID.rawValue.isEmpty else {
            return
        }
        
        let VC = segue.destinationController as! ChatViewController
        VC.currentAccountStr = accountTextField.stringValue
        VC.delegate = self
    }
    
}

private extension MainViewController {
    func initAgoraAPI() {
        agoraAPI = AgoraAPI.getInstanceWithoutMedia(KeyCenter.appID)
        versionLabel.stringValue = getSdkVersion()
    }


    //MARK:Signal Call Back
    func setupSignalCallBack() {

        agoraAPI.onLoginSuccess = { (uid, fd) -> () in
            
            self.currentUID = uid
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "mainToChat"), sender: nil)
                print("login success")
            }
            
        }

        agoraAPI.onLoginFailed = { (ecode) -> () in
            print("Login Failed : \(ecode.rawValue)" )
        }
        
        
        agoraAPI.onReconnecting = { (nretry) -> () in
            print("Reconnecting")
        }

    }

  
    func getSdkVersion() -> String {
        var version = String(agoraAPI.getSdkVersion())
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
    
}

extension MainViewController : ChatViewControllerDelegate {
    func chatViewControllerDismiss(_ chatVC: ChatViewController) {
        chatVC.view.window?.contentViewController = self
    }
}
