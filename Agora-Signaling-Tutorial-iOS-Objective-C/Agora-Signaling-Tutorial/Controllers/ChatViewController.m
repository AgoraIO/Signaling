//
//  ChatViewController.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "ChatViewController.h"
#import "AgoraSignal.h"
#import "Message.h"
#import "ChatRoomViewController.h"

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *chatAccountTextField;
@end

@implementation ChatViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addAgoraSignalBlock];
}

- (void)logout {
    [[AgoraSignal sharedKit] logout];
}

- (IBAction)chatButtonClicked:(UIButton *)sender {
    NSString *chatAccount = self.chatAccountTextField.text;
    if (!chatAccount.length) {
        return;
    }
    if (![self checkString:chatAccount]) {
        return;
    }
    [self performSegueWithIdentifier:@"ShowChatRoom" sender:chatAccount];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ChatRoomViewController *chatRoomVC = (ChatRoomViewController *)(segue.destinationViewController);
    NSString *account = sender;
    chatRoomVC.account = account;
    MessageList *messageList = [MessageCenter sharedCenter].chatMessages[account];
    if (messageList) {
        chatRoomVC.messageList = messageList;
    } else {
        chatRoomVC.messageList.identifier = account;
    }
}

- (void)addAgoraSignalBlock {
    __weak typeof(self) weakSelf = self;
    [AgoraSignal sharedKit].onLogout = ^(AgoraEcode ecode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    };
    
    [AgoraSignal sharedKit].onMessageInstantReceive = ^(NSString *account, uint32_t uid, NSString *msg) {
        NSMutableDictionary *chatMessages = [MessageCenter sharedCenter].chatMessages;
        MessageList *messageList = chatMessages[account];
        
        if (!messageList) {
            chatMessages[account] = [[MessageList alloc] initWithIdentifier:account];
        }
        Message *message = [[Message alloc] initWithAccount:account message:msg];
        
        [messageList.list addObject:message];
    };
}

- (BOOL)checkString:(NSString *)string {
    if (!string.length || string.length > 128) {
        return NO;
    }
    
    if ([string containsString:@" "]) {
        return NO;
    }
    
    return YES;
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
@end
