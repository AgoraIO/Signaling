//
//  CustomSegue.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 12/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa

class CustomSegue: NSStoryboardSegue {
    override func perform() {
        (sourceController as AnyObject).view.window?.contentViewController = destinationController as? NSViewController
    }
}
