//
//  YumiVideoViewController.m
//  YumiMediationSDK-iOS
//
//  Created by 魏晓磊 on 17/6/5.
//  Copyright © 2017年 JiaDingYi. All rights reserved.
//

#import "YumiVideoViewController.h"
#import <YumiMediationSDK/YumiMediationVideo.h>

@interface YumiVideoViewController () <YumiMediationVideoDelegate>

@property (weak, nonatomic) IBOutlet UITextField *videoTextField;

@end

@implementation YumiVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    self.title = @"视频广告";
}

- (IBAction)requestVideo:(id)sender {
    [[YumiMediationVideo sharedInstance] loadAdWithYumiID:self.videoTextField.text channelID:@"" versionID:@""];
}

- (IBAction)isReadyForVideo:(id)sender {
    NSString *alertTitle =
        [NSString stringWithFormat:@"%@", [[YumiMediationVideo sharedInstance] isReady] ? @"有视频可以播放"
                                                                                        : @"没有视频播放"];
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    if ([[YumiMediationVideo sharedInstance] isReady]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"暂不播放"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action){

                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"播放视频"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [[YumiMediationVideo sharedInstance]
                                                        presentFromRootViewController:self];
                                                }]];
    } else {
        [alert addAction:[UIAlertAction actionWithTitle:@"需要再加载一会"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action){

                                                }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)playVideo:(id)sender {
    [[YumiMediationVideo sharedInstance] presentFromRootViewController:self];
}

#pragma mark - YumiMediationVideoDelegate
- (void)yumiMediationVideoDidClose:(YumiMediationVideo *)video {
}

- (void)yumiMediationVideoDidReward:(YumiMediationVideo *)video {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
