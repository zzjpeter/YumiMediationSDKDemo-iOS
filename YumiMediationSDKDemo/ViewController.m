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
#import <YumiMediationSDK/AdsYuMIDeviceInfo.h>

#define YUMIBANNER_ID       @"3f521f0914fdf691bd23bf85a8fd3c3a"
#define YUMIINTERSTITIAL_ID @"3f521f0914fdf691bd23bf85a8fd3c3a"
#define YUMIVIDEO_ID        @"3f521f0914fdf691bd23bf85a8fd3c3a"
#define YUMI_CHANNELID      @""
#define YUMI_VERSIONID      @""

@interface ViewController ()<AdsYuMIDelegate,YuMIInterstitialDelegate,UIAlertViewDelegate,YMVideoDelegate> {
    AdsYuMIView * adView;
    YuMIInterstitial * inter;
    UIAlertController *alertVC;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *appname = [[AdsYuMIDeviceInfo shareDevice]getAppName];
    [self.btn_banner_start addTarget:self action:@selector(createBanner) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_banner_end addTarget:self action:@selector(removeBanner) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_load_inter addTarget:self action:@selector(clickInterstitialUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_show_inter addTarget:self action:@selector(clickInterstitialShow:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)viewDidAppear:(BOOL)animated{
    
    alertVC = [UIAlertController alertControllerWithTitle:@"WARNING" message:@"PLEASE SELECT SERVER" preferredStyle:UIAlertControllerStyleAlert ];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"测试服务器" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[AdsYuMIDeviceInfo shareDevice] openTestService:YES];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"正式服务器" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[AdsYuMIDeviceInfo shareDevice] openTestService:NO];
    }]];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    
}
-(void)createBanner{
    if (adView) {
        return;
    }
    
    float h;
    float w = [UIScreen mainScreen].bounds.size.width;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        float proportion = 90.0f/728.0f;
        h = w * proportion;
    }else{
        float proportion = 50.0f/320.0f;
        h = w * proportion;
    }
    
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
                adView =[[AdsYuMIView alloc]initWithAppKey:YUMIBANNER_ID  AdViewType:AdViewYMTypeLargeBanner StopRotation:NO isAutoAdSize:YES];
                adView.frame=CGRectMake(0,self.view.frame.size.height-h,0, 0);
            }else {
                adView =[[AdsYuMIView alloc]initWithAppKey:YUMIBANNER_ID AdViewType:AdViewYMTypeLargeBanner StopRotation:NO isAutoAdSize:NO];
                adView.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width-720)/2,self.view.frame.size.height-90,720,90);
            }
            
        }else {
            
            if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
                adView =[[AdsYuMIView alloc]initWithAppKey:YUMIBANNER_ID AdViewType:AdViewYMTypeNormalBanner StopRotation:NO isAutoAdSize:YES];
                adView.frame=CGRectMake(0,self.view.frame.size.height-h,0, 0);
            }else {
                adView =[[AdsYuMIView alloc]initWithAppKey:YUMIBANNER_ID AdViewType:AdViewYMTypeNormalBanner StopRotation:NO isAutoAdSize:NO];
                adView.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width-320)/2,self.view.frame.size.height-50,320,50);
            }
        }
    
    adView.delegate=self;
    [self.view addSubview:adView];
}

-(void)removeBanner{
    if (adView) {
        [adView removeFromSuperview];
        adView =nil;
        adView.delegate=nil;
    }
}


- (void) clickInterstitialUpload :(UIButton *)sender{
    if (inter) {
        return;
    }
    inter= [[YuMIInterstitialManager shareInstance]adYuMIInterstitialByAppKey:YUMIINTERSTITIAL_ID isStopRotation:NO];
    inter.delegate=self;
}

- (void)clickInterstitialShow:(UIButton *)sender {
    if (inter) {
        [inter interstitialShow:NO];
    }
}


- (IBAction)videoInit:(id)sender {
        [YMVideoManager startWithYuMIId:YUMIVIDEO_ID delegate:self];
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
- (UIViewController *)viewControllerForPresentingYUMIModalView{
    return self;
}

- (void)adsYuMIDidStartAd:(AdsYuMIView *)adView{
}

- (void)adsYuMIDidReceiveAd:(AdsYuMIView *)adView{
    
    
}

- (void)adsYuMIDidFailToReceiveAd:(AdsYuMIView *)adView didFailWithError:(NSError *)error{
    
}

- (void)adsYuMIClickAd:(AdsYuMIView *)adView{
}


#pragma mark - Interstitial Delegate
- (UIViewController *)viewControllerForPresentingInterstitialModalView{
    return self;
}

- (void)YuMIInterstitialDidReceiveAd:(YuMIInterstitial *)ad{
    
}

- (void)YuMIInterstitial:(YuMIInterstitial *)ad didFailToReceiveAdWithError:(NSError *)error{
    
}

- (void)YuMIInterstitialDidDismissScreen:(YuMIInterstitial *)ad{
    
}

- (void)adapterDidInterstitialClick{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
