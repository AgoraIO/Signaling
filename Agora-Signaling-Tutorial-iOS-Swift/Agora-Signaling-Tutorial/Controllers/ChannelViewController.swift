//
//  ChannelViewController.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 07/12/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    @IBOutlet weak var channelNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout"), style: .plain, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAgoraSignalBlock()
    }
    
    func addAgoraSignalBlock() {
        AgoraSignal.Kit.onChannelJoined = { (channelID) -> () in
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "ShowChannelRoom", sender: self.channelNameTextField.text)
            })
        }
        
        AgoraSignal.Kit.onChannelJoinFailed = { (channelID, ecode) -> () in
            self.alert(string: "Join channel failed with error: \(ecode.rawValue)")
        }
    }

    @objc func logout() {
        AgoraSignal.Kit.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let channelRoomCV = segue.destination as? ChannelRoomViewController, let channelName = sender as? String {
            channelRoomCV.channelName = channelName
        }
    }
    
    @IBAction func joinButtonClicked(_ sender: UIButton) {
        
        guard let channelName = channelNameTextField.text else {
            return
        }
        if !check(String: channelName) {
            return
        }
        AgoraSignal.Kit.channelJoin(channelName)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ChannelViewController {
    func check(String: String) -> Bool {
        if String.isEmpty {
            alert(string: "The channel name is empty !")
            return false
        }
        if String.count > 128 {
            alert(string: "The channel name is too long !")
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
