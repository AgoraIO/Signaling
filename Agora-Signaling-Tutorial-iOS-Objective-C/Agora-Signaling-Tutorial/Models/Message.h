//
//  Message.h
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Message : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *message;
- (instancetype)initWithAccount:(NSString *)account message:(NSString *)message;
@end

@interface MessageList : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSMutableArray<Message *> *list;
- (instancetype)initWithIdentifier:(NSString *)identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier message:(Message *)message;
@end

@interface MessageCenter : NSObject
@property (nonatomic, strong) NSMutableDictionary<NSString *, MessageList *> *chatMessages;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIColor *> *userColor;
+ (instancetype)sharedCenter;
@end
