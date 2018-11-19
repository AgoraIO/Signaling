//
//  ChannelRoomViewController.h
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/17.
//  Copyright © 2018 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageList;

@interface ChannelRoomViewController : UIViewController
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, strong) MessageList *messageList;
@end
