//
//  AgoraSignalKit.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 04/12/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import Foundation
import AgoraSigKit

struct AgoraSignal {
    static let Kit : AgoraAPI = AgoraAPI.getInstanceWithoutMedia(KeyCenter.AppId)
}
