//
//  YuMIDebugCoreCenter.m
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/18.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import "YuMIDebugCoreCenter.h"
#import "YuMIDebugAdapterFactoary.h"
#import <objc/runtime.h>
#import "YuMIDebugLog.h"
#import "YuMIDebugDetailViewController.h"

@interface YuMIDebugCoreCenter(){
  
  YuMIDebugAdapterFactoary * adapter_faction;
  id object_adapter;
  YuMIDebugCoreCenter *selfCore;
  id provider;
  Method originalM;
  Method exchangeM;
  Method currentM;
  NSDictionary * copyModel;
}

@property(strong,nonatomic)id yumidelegate;
@end

@implementation YuMIDebugCoreCenter


- (instancetype)init
{
  self = [super init];
  if (self) {
    adapter_faction =[[YuMIDebugAdapterFactoary alloc]init];
    selfCore = self;
  }
  return self;
}

-(NSDictionary*)checkModelExistenceOfAdapter:(id)model{
  NSMutableDictionary * returnDic =[[NSMutableDictionary alloc]init];
  if ([model isKindOfClass:[NSMutableArray class]]) {
    for (NSDictionary * dic in (NSArray*)model) {
      NSInteger adtype =[[dic objectForKey:@"adtype"] integerValue];
      NSString* provider_name =[dic objectForKey:@"providerID"];
      if (adtype==2) {
        [returnDic setObject:[NSString stringWithFormat:@"%d",[adapter_faction checkAdapter:[adapter_faction getBannerAllAdapter] adapterName:provider_name]] forKey:@"2"];
      }else if(adtype==3){
        [returnDic setObject:[NSString stringWithFormat:@"%d",[adapter_faction checkAdapter:[adapter_faction getInterAllAdapter] adapterName:provider_name]] forKey:@"3"];
      }else if(adtype==5){
        [returnDic setObject:[NSString stringWithFormat:@"%d",[adapter_faction checkAdapter:[adapter_faction getVideoAllAdapter] adapterName:provider_name]] forKey:@"5"];
      }
    }
  }
  return returnDic;
}

-(void)getAdByModel:(NSDictionary*)model{
  copyModel =model;
  
  NSInteger adtype =[[model objectForKey:@"adtype"] integerValue];
  if (adtype == 2 || adtype==3) {
    if (object_adapter==nil) {
      Class adapter = [adapter_faction createAdapterByAdapterName:[model objectForKey:@"providerID"] adType:[[model objectForKey:@"adtype"]intValue]];
      provider=[adapter_faction createBannerProvider:model];
      if (adapter&&provider) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            object_adapter =[adapter_faction createBannerAdapterWithInit:adapter delegate:selfCore view:nil core:selfCore provider:provider adType:2];
            }else{
            object_adapter =[adapter_faction createBannerAdapterWithInit:adapter delegate:selfCore view:nil core:selfCore provider:provider adType:1];
            }
        [self setViewControllerForPresentBanner:self.viewController];
      }
    }
    if (object_adapter) {
      [adapter_faction requestAd:object_adapter];
    }
  }else if(adtype ==5){
    object_adapter= [copyModel objectForKey:@"videoAdapter"];
    if (object_adapter){
      [self setViewControllerForPresentBanner:self.viewController];
    }
  }
}
-(void)setViewControllerForPresentBanner:(UIViewController*)vc{
  if(!object_adapter)return;
  void(*setVConroller)(id, SEL,UIViewController*);
  setVConroller = (void (*)(id, SEL,UIViewController*))[object_adapter methodForSelector:NSSelectorFromString(@"setDebugViewController:")];
  setVConroller(object_adapter, NSSelectorFromString(@"setDebugViewController:"),vc);
}

-(void)clearViewControllerForPresentBanner{
  if(!object_adapter)return;
  void(*setVConroller)(id, SEL);
  setVConroller = (void (*)(id, SEL))[object_adapter methodForSelector:NSSelectorFromString(@"clearDebugViewController")];
  setVConroller(object_adapter, NSSelectorFromString(@"clearDebugViewController"));
}


-(void)showAd{
  if (copyModel&&[[copyModel objectForKey:@"adtype"] integerValue]==3) {
    [adapter_faction preasentInterstitial:object_adapter];
  }
  if (copyModel&&[[copyModel objectForKey:@"adtype"] integerValue]==5) {
    if ([adapter_faction isAvailableVideo:object_adapter]) {
//      [((YuMIDebugDetailViewController*)_viewController).delegate performSelector:NSSelectorFromString(@"backAction")];
      [adapter_faction playVideo:object_adapter];
    }else{
      DLog(@"video no ad");
    }
  }
}


-(void)removeBanner{
    for (UIView *view in self.viewController.view.subviews) {
        if (view.tag==1987) {
             [view removeFromSuperview];
        }
    }
}

-(void)pauseAd {

}

-(void)continueAd {
    
}


#pragma mark - banner delegate
/**
 *  开始请求广告
 */
- (void)adDidStartRequestAd{
  DLog(@"banner start request");
}
/**
 *  平台请求成功
 *
 *  @param _adapter 平台适配器
 *  @param view     平台展示View
 */
- (void)adapter:(id)_adapter didReceiveAdView:(UIView *)view{
  DLog(@"banner request success");
  
  float screenH = [UIScreen mainScreen].bounds.size.height;
  float screenW = [UIScreen mainScreen].bounds.size.width;

  
  if (([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait || [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown)&&[self filterAdapter]) {
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
      float proportion = 90.0f/728.0f;
      h = screenW * proportion;
    }else{
      float proportion = 50.0f/320.0f;
      h = screenW * proportion;
    }
    
    view.frame=CGRectMake(0, screenH-h,screenW,h);
    
  }else {
    
    view.frame=CGRectMake((screenW-view.frame.size.width)/2, screenH-view.frame.size.height,view.frame.size.width,view.frame.size.height);
  }
    view.tag=1987;
  
  [self.viewController.view addSubview:view];
}


-(BOOL)filterAdapter{
    NSString* provider_name =[copyModel objectForKey:@"providerID"];
    if ([provider_name intValue]>100000) {
        provider_name =[provider_name substringFromIndex:1];
    }else{
        provider_name =provider_name;
    }
    if ([provider_name isEqualToString:@"10043"]) {
        return NO;
    }
    if ([provider_name isEqualToString:@"10026"]) {
        return NO;
    }
    if ([provider_name isEqualToString:@"10022"]) {
        return NO;
    }
    if ([provider_name isEqualToString:@"10039"]) {
        return NO;
    }
    if ([provider_name isEqualToString:@"10010"]) {
        return NO;
    }
    if ([provider_name isEqualToString:@"10014"]) {
        return NO;
    }
    return YES;
}



-(BOOL)isAutoAdSizeAdapter{
    return [self filterAdapter];
}


/**
 *  平台失败
 *
 *  @param _adapter 平台适配器
 *  @param error    错误信息
 */
- (void)adapter:(id)_adapter didFailAd:(NSError *)error{
  DLog(@"banner request fail");
}
/**
 *  平台点击
 *
 *  @param _adapter 平台适配器
 *  @param view     平台点击视图
 */
- (void)adapter:(id)_adapter didClickAdView:(UIView *)view ClickRect:(CGRect)click{
  DLog(@"banner click");
}

#pragma mark - interstital delegate
/**
 *  开始请求插屏广告
 */
-(void)adapterDidStartInterstitialRequestAd{
  DLog(@"interstital start request");
}

/**
 *  广告物料加载成功
 */
-(void)adapterPreloadInterstitialReceiveAd:(AdsYuMIAdNetworkAdapter *)_adapter{
  DLog(@"interstital material load success");

}
/**
 *  广告物料加载失败
 */
- (void)adapter:(AdsYuMIAdNetworkAdapter *)_adapter adapterPreloadInterstitialFailAd:(NSError *)error{
  DLog(@"interstital material load fail");
}

/**
 *  插屏广告预加载成功
 */
- (void)adapterDidInterstitialReceiveAd:(AdsYuMIAdNetworkAdapter *)_adapter{
  DLog(@"interstital preload success");
}

/**
 *  插屏预加载失败
 */
- (void)adapter:(AdsYuMIAdNetworkAdapter *)_adapter didInterstitialFailAd:(NSError *)error{
  DLog(@"interstital preload fail");
}

/**
 *  插屏点击回调
 *
 *  @param _adapter 适配器
 */
- (void)adapterDidInterstitialClick:(AdsYuMIAdNetworkAdapter *)_adapter CPclickArea:(CGRect)click{
  DLog(@"interstital click");
}

/**
 *  插屏将要展示
 *
 *  @param _adapter 适配器
 */
- (void)adapterInterstitialWillPresentScreen:(AdsYuMIAdNetworkAdapter *)_adapter{
  
}
/**
 *  插屏展示成功
 *
 *  @param _adapter 适配器
 */
- (void)adapterInterstitialDidPresentScreen:(AdsYuMIAdNetworkAdapter *)_adapter{
  DLog(@"interstital show success");
}

/**
 *  插屏已经关闭
 *
 *  @param _adapter 适配器
 */
- (void)adapterInterstitialDidDismissScreen:(AdsYuMIAdNetworkAdapter *)_adapter{
  DLog(@"interstital shut down");
}

#pragma mark - video delegate
//奖励
-(void)adapter:(id *)_adapter rewards:(NSInteger)rewards{
  DLog(@"get video reward");
}

//播放开始
-(void)adapterStartPlayVideo:(id *)_adapter{
  DLog(@"video play start");
}
//播放完成
-(void)adapterPlayToComplete:(id *)_adapter{
  DLog(@"video play finished");
}
//关闭视频
-(void)adapterdidCompleteVideo:(id *)_adapter{
  DLog(@"video shut down");
  [object_adapter clearViewControllerForPresentBanner];
  
}




- (void)dealloc
{
  [object_adapter clearViewControllerForPresentBanner];
  _viewController =nil;
  selfCore = nil;
  adapter_faction=nil;
  object_adapter=nil;
  provider = nil;
}


@end
