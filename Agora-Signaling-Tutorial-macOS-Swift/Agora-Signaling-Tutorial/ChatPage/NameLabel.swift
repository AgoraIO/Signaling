//
//  NameLabel.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 18/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa

class NameLabel: NSTextField {

    fileprivate var name : NSString!
    fileprivate var color : NSColor!
    fileprivate var x : CGFloat!
    fileprivate var y : CGFloat!
    fileprivate var w : CGFloat!
    fileprivate var h : CGFloat!
    
    lazy var textDic : NSMutableDictionary = {
        
        var dic = NSMutableDictionary()
        dic.setObject(NSColor.white, forKey: NSAttributedStringKey.foregroundColor as NSCopying)
        dic.setObject(NSFont.systemFont(ofSize: 18), forKey: NSAttributedStringKey.font as NSCopying)
        
        return dic
    }()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if name != nil {
            
            let context = NSGraphicsContext.current?.cgContext
            let center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
            let radius = self.frame.size.width * 0.5 - 3
            context?.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)

            color.setFill()
            context?.fillPath(using: CGPathFillRule.winding)
            let rect = NSRect(x: x, y: y, width: w, height: h)
            
            name.draw(in: rect, withAttributes: self.textDic as? [NSAttributedStringKey : Any])
        }
        
    }
    

    func drawName(name: NSString, isOther: Bool) {
        
        self.stringValue = ""
        
        self.name = name
        let textRect = name.boundingRect(with: NSMakeSize(self.frame.width - 10, CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: NSFont.systemFont(ofSize: 18)])
        
        x = (self.frame.width - textRect.width) * 0.5
        y = (self.frame.height - textRect.height) * 0.5
        w = (self.frame.width - x)
        h = (self.frame.height - y)
        
        if isOther {
            color = NSColor(calibratedRed: 70.0 / 255, green: 185.0 / 255, blue: 66.0 / 255, alpha: 1.0)
        }
        else {
            color = NSColor(calibratedRed: 68.0 / 255, green: 159.0 / 255, blue: 227.0 / 255, alpha: 1.0)
        }
        
    }
    
}
