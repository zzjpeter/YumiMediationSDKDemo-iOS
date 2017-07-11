//
//  YumiSplashViewController.m
//  YumiMediationSDK-iOS
//
//  Created by ShunZhi Tang on 2017/7/10.
//  Copyright © 2017年 JiaDingYi. All rights reserved.
//

#import "YumiSplashViewController.h"
#import <YumiMediationSDK/YumiAdsSplash.h>

@interface YumiSplashViewController () <YumiAdsSplashDelegate>

@property (weak, nonatomic) IBOutlet UITextField *yumiIDTextField;
@property (nonatomic) YumiAdsSplash *yumiSplash;

@end

@implementation YumiSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSplashAd:(UIButton *)sender {
    NSString *yumiID = self.yumiIDTextField.text;
    self.yumiSplash = [YumiAdsSplash sharedInstance];
    [self.yumiSplash showYumiAdsSplashWith:yumiID rootViewController:self delegate:self];
}

#pragma mark : - YumiAdsSplashDelegate

- (void)yumiAdsSplashDidLoad:(YumiAdsSplash *)splash {
}
- (void)yumiAdsSplash:(YumiAdsSplash *)splash DidFailToLoad:(NSError *)error {
}
- (void)yumiAdsSplashDidClicked:(YumiAdsSplash *)splash {
}
- (void)yumiAdsSplashDidClosed:(YumiAdsSplash *)splash {
}
- (nullable UIImage *)yumiAdsSplashDefaultImage {
    return nil;
}

@end
