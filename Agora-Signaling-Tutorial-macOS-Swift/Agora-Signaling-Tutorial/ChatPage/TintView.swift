//
//  TintView.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 19/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa

class TintView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        wantsLayer = true
        layer?.borderWidth = 1
        layer?.borderColor = NSColor.lightGray.cgColor
        
        layer?.backgroundColor = NSColor(calibratedRed: 68.0 / 255, green: 159.0 / 255, blue: 227.0 / 255, alpha: 1.0).cgColor
    }
    
}
