//
//  YumiBannerViewController.m
//  YumiMediationSDK-iOS
//
//  Created by 魏晓磊 on 17/6/5.
//  Copyright © 2017年 JiaDingYi. All rights reserved.
//

#import "YumiBannerViewController.h"
#import <YumiMediationSDK/YumiMediationBannerView.h>

@interface YumiBannerViewController () <YumiMediationBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *bannerTextField;
@property (nonatomic, nullable) YumiMediationBannerView *bannerView;

@end

@implementation YumiBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    self.title = @"横幅广告";
}

- (YumiMediationBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[YumiMediationBannerView alloc] initWithYumiID:self.bannerTextField.text
                                                            channelID:@""
                                                            versionID:@""
                                                             position:YumiMediationBannerPositionBottom
                                                   rootViewController:self];
        _bannerView.delegate = self;
    }

    return _bannerView;
}

- (IBAction)requestBanner:(id)sender {
    [self.bannerView loadAd];
    [self.view addSubview:self.bannerView];
}

- (IBAction)removeBanner:(id)sender {
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
}

#pragma mark - YumiMediationBannerViewDelegate

- (void)yumiMediationBannerViewWillRequestAd:(YumiMediationBannerView *)bannerView {
}

- (void)yumiMediationBannerViewDidClick:(YumiMediationBannerView *)adView {
    NSLog(@"did click");
}

- (void)yumiMediationBannerViewDidLoad:(YumiMediationBannerView *)adView {
}

- (void)yumiMediationBannerView:(YumiMediationBannerView *)adView didFailWithError:(YumiMediationError *)error {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
