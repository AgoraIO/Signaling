//
//  InputTextField.swift
//  Agora-Signaling-Tutorial
//
//  Created by CavanSu on 18/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

import Cocoa

protocol InputTextFieldDelegate {
    func inputTextFieldBecomeFirstResponder(_ textField : InputTextField)
}

class InputTextField: NSTextField {

    var responderDelegate : InputTextFieldDelegate?
    var isActive : Bool?
    
    override func becomeFirstResponder() -> Bool {
        isActive = true
        responderDelegate?.inputTextFieldBecomeFirstResponder(self)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        isActive = false
        return super.resignFirstResponder()
    }
        
}
