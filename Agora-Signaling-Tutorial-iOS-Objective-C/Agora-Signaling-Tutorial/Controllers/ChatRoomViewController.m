//
//  ChatRoomViewController.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "Message.h"
#import "UIColor+Extension.h"
#import "LeftCell.h"
#import "RightCell.h"
#import "AgoraSignal.h"

@interface ChatRoomViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *chatRoomContainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatRoomContainBottom;
@property (weak, nonatomic) IBOutlet UITableView *chatRoomTableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isOnline;
@end

@implementation ChatRoomViewController
- (void)setIsOnline:(BOOL)isOnline {
    _isOnline = isOnline;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.title = [NSString stringWithFormat:@"%@ (%@)", strongSelf.account, strongSelf.isOnline ? @"online" : @"offline"];
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
    
    self.chatRoomTableView.rowHeight = UITableViewAutomaticDimension;
    self.chatRoomTableView.estimatedRowHeight = 50;
    
    [self checkStatus];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkStatus) userInfo:nil repeats:YES];
    [self addTouchEventToTableView:self.chatRoomTableView];
    [self addKeyboardObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addAgoraSignalBlock];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.messageList.list.count) {
        return;
    }
    NSIndexPath *insterIndexPath = [NSIndexPath indexPathForRow:self.messageList.list.count - 1 inSection:0];
    [self.chatRoomTableView scrollToRowAtIndexPath:insterIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MessageCenter sharedCenter].chatMessages[self.account] = self.messageList;
    [self.timer invalidate];
}

- (void)addAgoraSignalBlock {
    __weak typeof(self) weakSelf = self;
    [AgoraSignal sharedKit].onQueryUserStatusResult = ^(NSString *name, NSString *status) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL isOnline = [status isEqualToString:@"1"];
        
        if (strongSelf.isFirstLoad) {
            strongSelf.isOnline = isOnline;
            strongSelf.isFirstLoad = NO;
        } else if (self.isOnline != isOnline) {
            self.isOnline = isOnline;
        }
    };
    
    [AgoraSignal sharedKit].onMessageSendSuccess = ^(NSString *messageID) {
        NSString *myAccount = [[NSUserDefaults standardUserDefaults] stringForKey:@"myAccount"];
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            Message *message = [[Message alloc] initWithAccount:myAccount message:strongSelf.inputTextField.text];
            [strongSelf.messageList.list addObject:message];
            [strongSelf updateTableView:strongSelf.chatRoomTableView withMessage:message];
            strongSelf.inputTextField.text = @"";
        });
    };
    
    [AgoraSignal sharedKit].onMessageSendError = ^(NSString *messageID, AgoraEcode ecode) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf alertString:[NSString stringWithFormat:@"Message send failed with error: %lu", (unsigned long)ecode]];
    };
    
    [AgoraSignal sharedKit].onMessageInstantReceive = ^(NSString *account, uint32_t uid, NSString *msg) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        Message *message = [[Message alloc] initWithAccount:account message:msg];
        
        if ([account isEqualToString:strongSelf.account]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.messageList.list addObject:message];
                [strongSelf updateTableView:strongSelf.chatRoomTableView withMessage:message];
            });
        } else {
            MessageList *messageList = [MessageCenter sharedCenter].chatMessages[account];
            if (messageList) {
                [messageList.list addObject:message];
            } else {
                [MessageCenter sharedCenter].chatMessages[account] = [[MessageList alloc] initWithIdentifier:account message:message];
            }
        }
    };
}

- (void)checkStatus {
    [[AgoraSignal sharedKit] queryUserStatus:self.account];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = textField.text;
    if (!text.length) {
        return NO;
    }
    
    [[AgoraSignal sharedKit] messageInstantSend:self.account uid:0 msg:text msgID:[NSString stringWithFormat:@"%lu", (unsigned long)self.messageList.list.count]];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageList.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.messageList.list[indexPath.row].account isEqualToString:self.account] && ![self.account isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"myAccount"]] ) {
        UIColor *color = [MessageCenter sharedCenter].userColor[self.account];
        if (!color) {
            [MessageCenter sharedCenter].userColor[self.account] = [UIColor randomColor];
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
