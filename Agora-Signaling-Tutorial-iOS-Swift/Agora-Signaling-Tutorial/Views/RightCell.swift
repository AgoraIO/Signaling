//
//  RightCell.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 08/12/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import UIKit

class RightCell: UITableViewCell {
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dialogImageView: UIImageView!
    
    func setCellViewWith(message: Message) {
        self.messageLabel.text = message.message
        self.userNameLabel.text = message.account
        self.dialogImageView.image = #imageLiteral(resourceName: "dialog_right")
        self.userNameView.layer.cornerRadius = self.userNameView.frame.size.width / 2
        self.userNameView.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.userNameLabel.adjustsFontSizeToFitWidth = true
        self.userNameView.backgroundColor = userColor[message.account]
    }
}
