//
//  MainViewController.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "MainViewController.h"
#import "AgoraSignal.h"
#import "LogWriter.h"
#import "Message.h"
#import "KeyCenter.h"
#import "UIColor+Extension.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accoutTextField;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.versionLabel.text = [self getSdkVersion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addAgoraSignalBlock];
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    NSString *account = self.accoutTextField.text;
    if (![self checkString:account]) {
        return;
    }
    
    [[AgoraSignal sharedKit] login2:[KeyCenter AppId] account:account token:@"_no_need_token" uid:0 deviceID:nil retry_time_in_s:60 retry_count:5];
    NSString *lastAccount = [[NSUserDefaults standardUserDefaults] stringForKey:@"myAccount"];
    if (![account isEqualToString:lastAccount]) {
        [[NSUserDefaults standardUserDefaults] setValue:account forKey:@"myAccount"];
        [[MessageCenter sharedCenter].chatMessages removeAllObjects];
    }
    
    if ([[MessageCenter sharedCenter] userColor][account] == nil) {
        [[MessageCenter sharedCenter] userColor][account] = [UIColor randomColor];
    }
}

- (void)addAgoraSignalBlock {
    __weak typeof(self) weakSelf = self;
    [AgoraSignal sharedKit].onLoginSuccess = ^(uint32_t uid, int fd) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf performSegueWithIdentifier:@"loginSegue" sender:strongSelf];
        });
    };
    
    [AgoraSignal sharedKit].onLoginFailed = ^(AgoraEcode ecode) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf alertString:[NSString stringWithFormat:@"Login failed with error: %lu", ecode]];
    };
    
    [AgoraSignal sharedKit].onLog = ^(NSString *txt) {
        if (!txt.length) {
            return;
        }
        
        [LogWriter writeLog:txt];
    };
    
    [AgoraSignal sharedKit].onMessageInstantReceive = ^(NSString *account, uint32_t uid, NSString *msg) {
        NSMutableDictionary *chatMessages = [MessageCenter sharedCenter].chatMessages;
        Message *message = [[Message alloc] initWithAccount:account message:msg];
        
        MessageList *messageList = chatMessages[account];
        if (!messageList) {
            chatMessages[account] = [[MessageList alloc] initWithIdentifier:account message:message];
        }
        
        [messageList.list addObject:message];
    };
}

- (BOOL)checkString:(NSString *)string {
    if (!string.length) {
        [self alertString:@"The channel name is empty !"];
        return NO;
    }
    
    if (string.length > 128) {
        [self alertString:@"The channel name is too long !"];
        return NO;
    }
    
    if ([string containsString:@" "]) {
        [self alertString:@"The accout contains space !"];
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

- (NSString *)getSdkVersion {
    return [NSString stringWithFormat:@"Version %@", @AGORA_SDK_VERSION];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
