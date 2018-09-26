//
//  LogWriter.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 04/12/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import UIKit

var documentDir: URL! {
    return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
}
var url: URL! {
    return documentDir.appendingPathComponent("log.txt")
}

class LogWriter: NSObject {

    static func initLogWriter() {
        let data = NSMutableData()
        data.append("".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        data.write(to: url, atomically: true)
    }
    
    static func write(log: String) {
        let logs = log + "\n"
        let appendedData = logs.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        let writeHandler = try? FileHandle(forWritingTo:url)
        writeHandler!.seekToEndOfFile()
        writeHandler!.write(appendedData)
    }
}
