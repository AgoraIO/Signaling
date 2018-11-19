//
//  ChannelViewController.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "ChannelViewController.h"
#import "AgoraSignal.h"
#import "ChannelRoomViewController.h"

@interface ChannelViewController ()
@property (weak, nonatomic) IBOutlet UITextField *channelNameTextField;
@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addAgoraSignalBlock];
}

- (void)addAgoraSignalBlock {
    __weak typeof(self) weakSelf = self;
    [AgoraSignal sharedKit].onChannelJoined = ^(NSString *channelID) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf performSegueWithIdentifier:@"ShowChannelRoom" sender:strongSelf.channelNameTextField.text];
        });
    };
    
    [AgoraSignal sharedKit].onChannelJoinFailed = ^(NSString *channelID, AgoraEcode ecode) {
        [weakSelf alertString:[NSString stringWithFormat:@"Join channel failed with error: %lu", ecode]];
    };
}

- (void)logout {
    [[AgoraSignal sharedKit] logout];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ChannelRoomViewController *channelRoomVC = segue.destinationViewController;
    NSString *channelName = sender;
    channelRoomVC.channelName = channelName;
}

- (IBAction)joinButtonClicked:(UIButton *)sender {
    NSString *channelName = self.channelNameTextField.text;
    if (![self checkString:channelName]) {
        return;
    }
    
    [[AgoraSignal sharedKit] channelJoin:channelName];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
