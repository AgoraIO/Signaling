//
//  BlackBorderView.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 12/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa

protocol BlackBorderViewDelegate {
    
    func blackBorderViewMouseDown(_ touchedView : BlackBorderView)
}

class BlackBorderView: NSView {
    
    var delegate : BlackBorderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wantsLayer = true
        layer?.borderWidth = 1
        layer?.borderColor = NSColor.lightGray.cgColor
    }
    
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        delegate?.blackBorderViewMouseDown(self)
    }
    
}
