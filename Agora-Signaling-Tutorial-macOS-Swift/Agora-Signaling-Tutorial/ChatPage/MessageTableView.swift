//
//  MessageTableView.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 13/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa

class MessageTableView: NSTableView {

    var msgRecordArrDic : [String : [MessageModel]]!
    var currentChatWith : String!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        if msgRecordArrDic == nil {
            msgRecordArrDic = [String: [MessageModel]]()
            self.delegate = self
            self.dataSource = self
            
            self.wantsLayer = true
            self.layer?.backgroundColor = NSColor.blue.cgColor
        }
        
    }
   

    public func changeRecord(with account : String) {
        
        currentChatWith = account
        
        if msgRecordArrDic[currentChatWith] == nil {
            let newRecordArray = [MessageModel]()
            msgRecordArrDic[currentChatWith] = newRecordArray
        }
        
        reloadData()
        
        let lastRow = (msgRecordArrDic[currentChatWith!]?.count)! - 1
        scrollRowToVisible(lastRow)
    }
    
    
    public func addNewMsg(message: MessageModel, currentChat: String) {
        
        
        if msgRecordArrDic[message.account] == nil {
            let newRecordArray = [MessageModel]()
            msgRecordArrDic[message.account] = newRecordArray
        }
        
        var isChannelMsg : Bool
        
        if currentChatWith == nil {
            isChannelMsg = false
        }
        else {
            isChannelMsg = currentChatWith.hasPrefix("010203")
        }
        
     
        if (currentChatWith != currentChat && isChannelMsg == false) || (currentChat != message.account && message.isOther == true && isChannelMsg == false) {
            msgRecordArrDic[message.account]?.append(message)
            return
        }
        
        msgRecordArrDic[currentChatWith]?.append(message)
        
        let lastRow = (msgRecordArrDic[currentChatWith!]?.count)! - 1
        let index = IndexSet(integer: lastRow)
        
        insertRows(at: index, withAnimation: NSTableView.AnimationOptions())
        scrollRowToVisible(lastRow)
    }
    
    
    public func removeChannelReocrd(with accout : String) {
        
        if msgRecordArrDic[accout] != nil {
            msgRecordArrDic.removeValue(forKey: accout)
        }
        
    }
    
}

extension MessageTableView : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let message = msgRecordArrDic[currentChatWith!]![row]
        
        if message.isOther == true {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Other"), owner: self) as! LeftMsgCell
            cell.getMsgModel(with: message)
            return cell
        }
        else {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Own"), owner: self) as! RightMsgCell
            cell.getMsgModel(with: message)
            return cell
        }
        
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        let message = msgRecordArrDic[currentChatWith!]![row]
        let msg = message.text

        let textRect = (msg! as NSString).boundingRect(with: NSMakeSize(self.frame.width - 50 - 20 - 100, CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: NSFont.systemFont(ofSize: 22)])

        return CGFloat(textRect.height + 20 + 20)
    }
    
}

extension MessageTableView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        if currentChatWith == nil {
            return 0
        }
        
        if msgRecordArrDic[currentChatWith] == nil {
            return 0
        }
        else {
            return (msgRecordArrDic[currentChatWith]?.count)!
        }
        
    }
    
}
