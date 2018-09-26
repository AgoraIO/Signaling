//
//  Message.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 08/12/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import Foundation
import UIKit

struct Message {
    var account: String!
    var message: String!
}

struct MessageList {
    var identifier: String!
    var list = [Message]()
}

var chatMessages = Dictionary<String, MessageList>()

var userColor = Dictionary<String, UIColor>()
