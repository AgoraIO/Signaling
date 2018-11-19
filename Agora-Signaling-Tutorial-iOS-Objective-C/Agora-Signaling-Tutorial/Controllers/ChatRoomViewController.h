//
//  ChatRoomViewController.h
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageList;

@interface ChatRoomViewController : UIViewController
@property (nonatomic, copy) NSString *account;
@property (nonatomic, strong) MessageList *messageList;
@end
