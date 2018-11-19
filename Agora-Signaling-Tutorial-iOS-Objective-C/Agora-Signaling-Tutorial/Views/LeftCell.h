//
//  LeftCell.h
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;

@interface LeftCell : UITableViewCell
- (void)setCellViewWithMessage:(Message *)message;
@end
