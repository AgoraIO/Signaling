//
//  MessageView.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 14/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa

class MessageView: NSButton {

    fileprivate var message : NSString?
    fileprivate var msgWidth : CGFloat?
    fileprivate var msgHeight : CGFloat?
    
    lazy var textDic : NSMutableDictionary = {
        
        var dic = NSMutableDictionary()
        dic.setObject(NSColor.white, forKey: NSAttributedStringKey.foregroundColor as NSCopying)
        dic.setObject(NSFont.systemFont(ofSize: 22), forKey: NSAttributedStringKey.font as NSCopying)
        
        return dic
    }()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if message != nil {
            
            let rect = NSRect(x: 10, y: 10, width: self.frame.width - 10, height: self.frame.height - 10)
            message?.draw(in: rect, withAttributes: (self.textDic as! [NSAttributedStringKey : Any]))
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.wantsLayer = true
        self.image = nil
    }
    
    override func layout() {
        super.layout()
        
        self.layer?.cornerRadius = 5
        self.layer?.borderWidth = 2
    }
    
    
    public func addNewMsg(msg : String, isOther : Bool) {
        message = msg as NSString
        
        if isOther {
            self.layer?.backgroundColor = NSColor(calibratedRed: 70.0 / 255, green: 185.0 / 255, blue: 66.0 / 255, alpha: 1.0).cgColor
            self.layer?.borderColor = NSColor(calibratedRed: 70.0 / 255, green: 185.0 / 255, blue: 66.0 / 255, alpha: 1.0).cgColor
        }
        else {
           
            self.layer?.backgroundColor = NSColor(calibratedRed: 68.0 / 255, green: 159.0 / 255, blue: 227.0 / 255, alpha: 1.0).cgColor
            self.layer?.borderColor = NSColor(calibratedRed: 68.0 / 255, green: 159.0 / 255, blue: 227.0 / 255, alpha: 1.0).cgColor
        }
        
    }
    
}
