//
//  YuMIDebugAdapterFactoary.h
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/18.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YuMIDebugAdapterFactoary : NSObject

@property(assign,nonatomic)UIViewController* viewController;

-(BOOL)checkAdapter:(NSMutableDictionary*)dictionary  adapterName:(NSString*)name;
-(NSMutableDictionary*)getBannerAllAdapter;
-(NSMutableDictionary*)getInterAllAdapter;
-(NSMutableDictionary*)getVideoAllAdapter;
-(void)requestAd:(Class)_class;
-(void)preasentInterstitial:(Class)_class;
//初始化视频广告
-(void)initVideoAd:(Class)_class;
//询问视频广告是否播放完成
-(BOOL)isAvailableVideo:(Class)_class;//开始播放
-(void)playVideo:(Class)_class;
-(id)createVideoProvider:(NSDictionary*)dic;
-(Class)createAdapterByAdapterName:(NSString*)name  adType:(NSUInteger)adType;
-(id)createBannerProvider:(NSDictionary*)dic;
-(id)createBannerAdapterWithInit:(Class)class delegate:(id)delegate view:(id)view core:(id)core provider:(id)provider adType:(NSInteger)adtype;
-(Class)createVideoAdapterWithInit:(Class)class delegate:(id)delegate core:(id)core provider:(id)provider adType:(NSInteger)adtype;
-(void)changeMethodWithClass:(Class)class methodName:(NSString*)name chagneClass:(Class)changeClass changeMethodName:(NSString*)change_name;
@end
