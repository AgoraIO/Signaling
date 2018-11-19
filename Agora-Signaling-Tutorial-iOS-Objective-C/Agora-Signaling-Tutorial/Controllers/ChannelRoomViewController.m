//
//  ChannelRoomViewController.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/17.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "ChannelRoomViewController.h"
#import "Message.h"
#import "UIColor+Extension.h"
#import "LeftCell.h"
#import "RightCell.h"
#import "AgoraSignal.h"

@interface ChannelRoomViewController ()
@property (weak, nonatomic) IBOutlet UITableView *channelRoomTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelRoomContainBottom;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic, assign) NSInteger userNum;
@end

@implementation ChannelRoomViewController
- (void)setUserNum:(NSInteger)userNum {
    _userNum = userNum;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.title = [NSString stringWithFormat:@"%@ (%lu)", self.channelName, userNum];
    });
}

- (MessageList *)messageList {
    if (!_messageList) {
        _messageList = [[MessageList alloc] init];
    }
    return _messageList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.channelRoomTableView.rowHeight = UITableViewAutomaticDimension;
    self.channelRoomTableView.estimatedRowHeight = 50;
    
    [[AgoraSignal sharedKit] channelQueryUserNum:self.channelName];
    self.messageList.identifier = self.channelName;
    
    [self addKeyboardObserver];
    [self addTouchEventToTableView:self.channelRoomTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addAgoraSignalBlock];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[AgoraSignal sharedKit] channelLeave:self.channelName];
}

- (void)addAgoraSignalBlock {
    __weak typeof(self) weakSelf = self;
    
    [AgoraSignal sharedKit].onMessageSendError = ^(NSString *messageID, AgoraEcode ecode) {
        [weakSelf alertString:[NSString stringWithFormat:@"Message send failed with error: %lu", ecode]];
    };
    
    [AgoraSignal sharedKit].onMessageChannelReceive = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            Message *message = [[Message alloc] initWithAccount:account message:msg];
            [strongSelf.messageList.list addObject:message];
            [strongSelf updateTableView:strongSelf.channelRoomTableView withMessage:message];
            strongSelf.inputTextField.text = @"";
        });
    };
    
    [AgoraSignal sharedKit].onChannelQueryUserNumResult = ^(NSString *channelID, AgoraEcode ecode, int num) {
        weakSelf.userNum = num;
    };
    
    [AgoraSignal sharedKit].onChannelUserJoined = ^(NSString *account, uint32_t uid) {
        weakSelf.userNum ++;
    };
    
    [AgoraSignal sharedKit].onChannelUserLeaved = ^(NSString *account, uint32_t uid) {
        weakSelf.userNum --;
    };
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = textField.text;
    if (!text.length) {
        return NO;
    }
    
    [[AgoraSignal sharedKit] messageChannelSend:self.channelName msg:text msgID:[NSString stringWithFormat:@"%lu", (unsigned long)self.messageList.list.count]];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageList.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *myAccount = [[NSUserDefaults standardUserDefaults] stringForKey:@"myAccount"];
    NSString *indexAccount = self.messageList.list[indexPath.row].account;
    if (![indexAccount isEqualToString:myAccount]) {
        UIColor *color = [MessageCenter sharedCenter].userColor[indexAccount];
        if (!color) {
            [MessageCenter sharedCenter].userColor[indexAccount] = [UIColor randomColor];
        }
        LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftcell" forIndexPath:indexPath];
        [cell setCellViewWithMessage:self.messageList.list[indexPath.row]];
        return cell;
    } else {
        RightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightcell" forIndexPath:indexPath];
        [cell setCellViewWithMessage:self.messageList.list[indexPath.row]];
        return cell;
    }
}

- (void)addKeyboardObserver {
    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        NSDictionary *userInfo = note.userInfo;
        CGRect keyBoardBounds = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGFloat deltaY = CGRectGetHeight(keyBoardBounds);
        
        if (duration > 0) {
            UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                strongSelf.channelRoomContainBottom.constant = deltaY;
                [strongSelf.view layoutIfNeeded];
            } completion:nil];
        } else {
            strongSelf.channelRoomContainBottom.constant = deltaY;
        }
        
        if (strongSelf.messageList.list.count) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:strongSelf.messageList.list.count - 1 inSection:0];
            [strongSelf.channelRoomTableView scrollToRowAtIndexPath:insertIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        NSDictionary *userInfo = note.userInfo;
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if (duration > 0) {
            UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                strongSelf.channelRoomContainBottom.constant = 0;
                [strongSelf.view layoutIfNeeded];
            } completion:nil];
        } else {
            strongSelf.channelRoomContainBottom.constant = 0;
        }
    }];
}

- (void)alertString:(NSString *)string {
    if (!string.length) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    });
}

- (void)updateTableView:(UITableView *)tableView withMessage:(Message *)message {
    NSIndexPath *insterIndexPath = [NSIndexPath indexPathForRow:[tableView numberOfRowsInSection:0] inSection:0];
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:@[insterIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
    [tableView scrollToRowAtIndexPath:insterIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)addTouchEventToTableView:(UITableView *)tableView {
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [tableView addGestureRecognizer:tableViewGesture];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)tableViewTouchInSide {
    [self.inputTextField resignFirstResponder];
}
@end
