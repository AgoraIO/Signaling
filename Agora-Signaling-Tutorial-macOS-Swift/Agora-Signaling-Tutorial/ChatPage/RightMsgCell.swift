//
//  RightMsgCell.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 13/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa

class RightMsgCell: NSTableCellView {

    @IBOutlet weak var nameLabel: NameLabel!
    @IBOutlet weak var msgView: MessageView!
    @IBOutlet weak var msgConstraintsWidth: NSLayoutConstraint!
    
    func getMsgModel(with message : MessageModel) {
        
        let msg = message.text as NSString
        
        let textRect = (msg as NSString).boundingRect(with: NSMakeSize(self.frame.width - 50 - 20 - 30 - 100, CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: NSFont.systemFont(ofSize: 22)])
        
        msgConstraintsWidth.constant = textRect.width + 20
        msgView.addNewMsg(msg: message.text, isOther: false)
        
        var name : String;
        
        if message.account.count < 4 {
            name = message.account
        }
        else {
            name = (message.account as NSString).substring(to: 3)
        }
        
        nameLabel.drawName(name: name as NSString, isOther: false)
      
        layoutSubtreeIfNeeded()
    }
    
}
