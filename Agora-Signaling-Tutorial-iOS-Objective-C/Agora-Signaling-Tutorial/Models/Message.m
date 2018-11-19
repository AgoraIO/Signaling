//
//  Message.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "Message.h"

@implementation Message
- (instancetype)initWithAccount:(NSString *)account message:(NSString *)message {
    if (self = [super init]) {
        self.account = account;
        self.message = message;
    }
    return self;
}
@end

@implementation MessageList
- (instancetype)init {
    if (self = [super init]) {
        self.list = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        self.identifier = identifier;
        self.list = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier message:(Message *)message {
    if (self = [super init]) {
        self.identifier = identifier;
        self.list = [@[message] mutableCopy];
    }
    return self;
}
@end

@implementation MessageCenter
+ (instancetype)sharedCenter {
    static MessageCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[MessageCenter alloc] init];
        center.chatMessages = [[NSMutableDictionary alloc] init];
        center.userColor = [[NSMutableDictionary alloc] init];
    });
    return center;
}
@end
