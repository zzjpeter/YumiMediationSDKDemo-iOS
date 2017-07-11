//
//  YumiInterstitalViewController.m
//  YumiMediationSDK-iOS
//
//  Created by 魏晓磊 on 17/6/5.
//  Copyright © 2017年 JiaDingYi. All rights reserved.
//

#import "YumiInterstitalViewController.h"
#import <YumiMediationSDK/YumiMediationInterstitial.h>

@interface YumiInterstitalViewController () <YumiMediationInterstitialDelegate>

@property (weak, nonatomic) IBOutlet UITextField *interstitialTextField;

@property (nonatomic) YumiMediationInterstitial *interstitial;

@end

@implementation YumiInterstitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    self.title = @"插屏广告";
}

- (IBAction)requestInterstitial:(id)sender {
    self.interstitial = [[YumiMediationInterstitial alloc] initWithYumiID:self.interstitialTextField.text
                                                                channelID:@""
                                                                versionID:@""
                                                       rootViewController:self];
    self.interstitial.delegate = self;
}

- (IBAction)presentInterstitial:(id)sender {
    if ([self.interstitial isReady]) {
        [self.interstitial present];
    }
}

#pragma mark - YumiMediationInterstitialDelegate
- (void)yumiMediationInterstitialWillRequestAd:(YumiMediationInterstitial *)interstitial {
}

- (void)yumiMediationInterstitialDidReceiveAd:(YumiMediationInterstitial *)interstitial {
}

- (void)yumiMediationInterstitial:(YumiMediationInterstitial *)interstitial
                 didFailWithError:(YumiMediationError *)error {
}

- (void)yumiMediationInterstitialwillDismissScreen:(YumiMediationInterstitial *)interstitial {
}

- (void)yumiMediationInterstitialDidClick:(YumiMediationInterstitial *)interstitial {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
