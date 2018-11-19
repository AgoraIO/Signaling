//
//  LogWriter.h
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogWriter : NSObject
+ (void)initLogWriter;
+ (void)writeLog:(NSString *)log;
@end
