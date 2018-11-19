//
//  AgoraSignal.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "AgoraSignal.h"
#import "KeyCenter.h"

@implementation AgoraSignal
+ (AgoraAPI *)sharedKit {
    static AgoraAPI *kit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kit = [AgoraAPI getInstanceWithoutMedia:[KeyCenter AppId]];
    });
    return kit;
}
@end
