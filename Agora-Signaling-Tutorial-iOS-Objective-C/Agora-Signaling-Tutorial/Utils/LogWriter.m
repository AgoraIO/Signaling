//
//  LogWriter.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "LogWriter.h"

@implementation LogWriter
+ (NSURL *)documentDir {
    return [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
}

+ (NSURL *)url {
    return [[self documentDir] URLByAppendingPathComponent:@"log.txt"];
}

+ (void)initLogWriter {
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [data writeToURL:[self url] atomically:YES];
}

+ (void)writeLog:(NSString *)log {
    NSString *logs = [NSString stringWithFormat:@"%@\n", log];
    NSData *appendedData = [logs dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSFileHandle *writeHandler = [NSFileHandle fileHandleForWritingToURL:[self url] error:nil];
    [writeHandler seekToEndOfFile];
    [writeHandler writeData:appendedData];
}
@end
