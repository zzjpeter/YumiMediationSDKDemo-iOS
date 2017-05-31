//
//  ViewController.m
//  YumiMediationSDKDemo
//
//  Created by 甲丁乙_ on 2017/3/30.
//  Copyright © 2017年 Zplay. All rights reserved.
//

#import "ViewController.h"

#import <YumiMediationSDK/AdsYuMIView.h>
#import <YumiMediationSDK/YuMIInterstitial.h>
#import <YumiMediationSDK/YuMIInterstitialManager.h>
#import <YumiMediationSDK/YMVideoManager.h>
#import "YUMIStatisticTableViewController.h"
#import <YumiMediationDebugCenter-iOS/YuMIDebugCenter.h>
#import "AdsYUMILogCenter.h"

#define YUMIBANNER_ID         @"a6e37382df13a389d138ebf6cc567dcf"
#define YUMIINTERSTITIAL_ID   @"a6e37382df13a389d138ebf6cc567dcf"
#define YUMIVIDEO_ID          @"a6e37382df13a389d138ebf6cc567dcf"


#define YUMI_CHANNELID @""
#define YUMI_VERSIONID @""
#define TestServerKey @"testServer"

@interface ViewController () <AdsYuMIDelegate, YuMIInterstitialDelegate,YMVideoDelegate> {
    AdsYuMIView *adView;
    AdsYuMIView *adView_second;
    AdsYuMIView *adView_offset;
    AdsYuMIView *adView_auto;
    YuMIInterstitial *inter;
    YuMIInterstitial *inter_second;
    UILabel *onLabel1;
    UILabel *onAllLabel1;
    UILabel *onLabel2;
    UILabel *onAllLabel2;
    UIAlertController *alertVC;
    BOOL once;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    once = YES;
    [self removeTestService];
    
    [[AdsYuMILogCenter shareInstance] setLogLeveFlag:9];

}

- (void)viewDidAppear:(BOOL)animated {
    
    if (once) {
        alertVC = [UIAlertController alertControllerWithTitle:@"WARNING" message:@"PLEASE SELECT SERVER" preferredStyle:UIAlertControllerStyleAlert ];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"测试服务器" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self openTestService:YES];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"正式服务器" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self openTestService:NO];
        }]];
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
        once = NO;
    }
}

- (IBAction)createBanner:(id)sender {
    [self createAdsYumiView:YES YumiKey:YUMIBANNER_ID];
}


- (IBAction)doubleCreateBanner:(id)sender {
    [self createAdsYumiView:NO YumiKey:YUMIBANNER_ID];
}

- (IBAction)createOffsetBanner:(id)sender {
    int height = [UIScreen mainScreen].bounds.size.height;
    adView_offset = [[AdsYuMIView alloc] initWithAppKey:YUMIBANNER_ID
                                              channleId:YUMI_CHANNELID
                                          versionNumber:YUMI_VERSIONID
                                             AdViewType:AdViewYMTypeNormalBanner
                                           StopRotation:NO];
    adView_offset.frame = CGRectMake(-50, height-3*50, 320, 50);
    adView_offset.delegate = self;
    [self.view addSubview:adView_offset];
}

- (void)createAdsYumiView:(BOOL)test YumiKey:(NSString *)yumiKey {
    
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (test) {
        adView = [[AdsYuMIView alloc] initWithAppKey:yumiKey
                                           channleId:YUMI_CHANNELID
                                       versionNumber:YUMI_VERSIONID
                                          AdViewType:AdViewYMTypeNormalBanner
                                        StopRotation:NO];
        adView.frame = CGRectMake((width-320)/2, height-50, 320, 50);
        adView.delegate = self;
        [self.view addSubview:adView];
    }else {
        adView_second = [[AdsYuMIView alloc] initWithAppKey:yumiKey
                                                  channleId:YUMI_CHANNELID
                                              versionNumber:YUMI_VERSIONID
                                                 AdViewType:AdViewYMTypeNormalBanner
                                               StopRotation:NO];
        adView_second.frame = CGRectMake((width-320)/2, height-50, 320, 50);
        adView_second.delegate = self;
        [self.view addSubview:adView_second];
    }
}

- (IBAction)createAutoBanner:(id)sender {
    float h;
    float w = [UIScreen mainScreen].bounds.size.width;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        float proportion = 90.0f / 728.0f;
        h = w * proportion;
    } else {
        float proportion = 50.0f / 320.0f;
        h = w * proportion;
    }
    adView_auto = [[AdsYuMIView alloc] initWithAppKey:YUMIBANNER_ID
                                            channleId:YUMI_CHANNELID
                                        versionNumber:YUMI_VERSIONID
                                           AdViewType:AdViewYMTypeNormalBanner
                                         StopRotation:NO
                                         isAutoAdSize:YES];
    adView_auto.frame = CGRectMake(0, self.view.frame.size.height - h, 0, 0);
    adView_auto.delegate = self;
    [self.view addSubview:adView_auto];
}

- (IBAction)removeBanner:(id)sender {
    if (adView) {
        [adView removeFromSuperview];
        adView = nil;
        adView.delegate = nil;
    }
}

- (IBAction)removeDoubleBanner:(id)sender {
    if (adView_second) {
        [adView_second removeFromSuperview];
        adView_second = nil;
        adView_second.delegate = nil;
    }
}

- (IBAction)removeOffsetBanner:(id)sender {
    if (adView_offset) {
        [adView_offset removeFromSuperview];
        adView_offset = nil;
        adView_offset.delegate = nil;
    }
}

- (IBAction)removeAutoBanner:(id)sender {
    if (adView_auto) {
        [adView_auto removeFromSuperview];
        adView_auto = nil;
        adView_auto.delegate = nil;
    }
}


- (IBAction)onBanner:(id)sender {
    if (!onLabel1&&adView) {
        onLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(50,[UIScreen mainScreen].bounds.size.height-adView.frame.size.height,
                                                             adView.frame.size.width-50, adView.frame.size.height)];
        onLabel1.text = @"部分遮挡视图";
        onLabel1.textColor = [UIColor whiteColor];
        onLabel1.backgroundColor = [UIColor blackColor];
        onLabel1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:onLabel1];
    }
    if (!onLabel2&&adView_second) {
        onLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(50,[UIScreen mainScreen].bounds.size.height-2*adView_second.frame.size.height,
                                                             adView_second.frame.size.width-50, adView_second.frame.size.height)];
        onLabel2.text = @"部分遮挡视图";
        onLabel2.textColor = [UIColor whiteColor];
        onLabel2.backgroundColor = [UIColor blackColor];
        onLabel2.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:onLabel2];
    }
    
}

- (IBAction)onAllBanner:(id)sender {
    if (!onAllLabel1&&adView) {
        onAllLabel1 = [[UILabel alloc] initWithFrame:adView.frame];
        onAllLabel1.text = @"全部遮挡视图";
        onAllLabel1.backgroundColor = [UIColor clearColor];
        onAllLabel1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:onAllLabel1];
    }
    if (!onAllLabel2&&adView_second) {
        onAllLabel2 = [[UILabel alloc] initWithFrame:adView_second.frame];
        onAllLabel2.text = @"全部遮挡视图";
        onAllLabel2.backgroundColor = [UIColor clearColor];
        onAllLabel2.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:onAllLabel2];
    }
}

- (IBAction)removeOnView:(id)sender {
    if (onLabel1) {
        [onLabel1 removeFromSuperview];
        onLabel1 = nil;
    }
    if (onLabel2) {
        [onLabel2 removeFromSuperview];
        onLabel2 = nil;
    }
    if (onAllLabel1) {
        [onAllLabel1 removeFromSuperview];
        onAllLabel1 = nil;
    }
    if (onAllLabel2) {
        [onAllLabel2 removeFromSuperview];
        onAllLabel2 = nil;
    }
}

- (IBAction)clickInterstitialUpload:(id)sender {
    inter = [[YuMIInterstitialManager shareInstance] adYuMIInterstitialByAppKey:YUMIINTERSTITIAL_ID
                                                                      channleId:YUMI_CHANNELID
                                                                  versionNumber:YUMI_VERSIONID
                                                                 isStopRotation:NO];
    inter.delegate = self;
}

- (IBAction)clickInterstitialShow:(id)sender {
    if (inter) {
        [inter interstitialShow:NO];
    }
}

- (IBAction)interstitialDoubleInit:(id)sender {
    inter_second = [[YuMIInterstitialManager shareInstance] adYuMIInterstitialByAppKey:YUMIINTERSTITIAL_ID
                                                                             channleId:YUMI_CHANNELID
                                                                         versionNumber:YUMI_VERSIONID
                                                                        isStopRotation:NO];
    inter_second.delegate = self;
}

- (IBAction)interstitialDoubleShow:(id)sender {
    if (inter_second) {
        [inter_second interstitialShow:NO];
    }
}

- (IBAction)videoInit:(id)sender {
    [YMVideoManager startWithYuMIId:YUMIVIDEO_ID channleId:YUMI_CHANNELID versionNumber:YUMI_VERSIONID delegate:self];
}

- (IBAction)videoDoubleInit:(id)sender {
    [YMVideoManager startWithYuMIId:YUMIVIDEO_ID channleId:YUMI_CHANNELID versionNumber:YUMI_VERSIONID delegate:self];
}


- (IBAction)isExistVideo:(id)sender {
    
    if ( [[YMVideoManager sharedVideoManager]isReadVideo]) {
        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"可以播放广告" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"没广告" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (IBAction)playVideo:(id)sender {
    [[YMVideoManager sharedVideoManager]playVideo];
}

#pragma mark - YUMIVideo delegate
- (UIViewController *)viewControllerVideoModalView{
    return self;
}

- (void)didCompleteVideo {
    
}

-(void)rewardsVideo {
    
}


#pragma mark - Banner Delegate
- (UIViewController *)viewControllerForPresentingYUMIModalView {
    return self;
}

- (void)adsYuMIDidStartAd:(AdsYuMIView *)adView {
}

- (void)adsYuMIDidReceiveAd:(AdsYuMIView *)adView {
}

- (void)adsYuMIDidFailToReceiveAd:(AdsYuMIView *)adView didFailWithError:(NSError *)error {
}

- (void)adsYuMIClickAd:(AdsYuMIView *)adView {
}

#pragma mark - Interstitial Delegate
- (UIViewController *)viewControllerForPresentingInterstitialModalView {
    return self;
}

- (void)YuMIInterstitialDidReceiveAd:(YuMIInterstitial *)ad {
}

- (void)YuMIInterstitial:(YuMIInterstitial *)ad didFailToReceiveAdWithError:(NSError *)error {
}

- (void)YuMIInterstitialDidDismissScreen:(YuMIInterstitial *)ad {
}

- (void)adapterDidInterstitialClick {
}


#pragma mark - other feature
- (IBAction)debugModel:(id)sender {
    [[YuMIDebugCenter shareInstance] startDebugging:self];
}
- (IBAction)dataStatistic:(id)sender {
    YUMIStatisticTableViewController * statistic = [[YUMIStatisticTableViewController alloc] initWithNibName:@"YUMIStatisticTableViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:statistic];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)openTestService:(BOOL)openService {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", openService]
                                              forKey:TestServerKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isOpenTestService {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:TestServerKey] boolValue];
}

- (void)removeTestService {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TestServerKey];
}


@end
