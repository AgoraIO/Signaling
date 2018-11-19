//
//  LeftCell.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "LeftCell.h"
#import "Message.h"

@interface LeftCell()
@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dialogImageView;

@end

@implementation LeftCell
- (void)setCellViewWithMessage:(Message *)message {
    self.messageLabel.text = message.message;
    self.userNameLabel.text = message.account;
    self.dialogImageView.image = [UIImage imageNamed:@"dialog_left"];
    self.userNameView.layer.cornerRadius = self.userNameView.frame.size.width / 2;
    self.userNameView.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.userNameLabel.adjustsFontSizeToFitWidth = YES;
    self.userNameView.backgroundColor = [MessageCenter sharedCenter].userColor[message.account];
}
@end
