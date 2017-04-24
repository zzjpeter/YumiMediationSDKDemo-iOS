//
//  YuMIDebugAdapterFactoary.m
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/18.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import "YuMIDebugAdapterFactoary.h"
#import <objc/runtime.h>
@class AdsYuMIConfig;
@implementation YuMIDebugAdapterFactoary



-(Class)createAdapterByAdapterName:(NSString*)name  adType:(NSUInteger)adType{
  if (adType==2) {
    if (![[self getBannerAllAdapter] objectForKey:name]) {
      return nil;
    }
    return [self getAdapterClass:[[self getBannerAllAdapter] objectForKey:name]];
  }
  if (adType==3) {
    if (![[self getInterAllAdapter] objectForKey:name]) {
      return nil;
    }
    return [self getAdapterClass:[[self getInterAllAdapter] objectForKey:name]];
  }
  if (adType==5) {
    if (![[self getVideoAllAdapter] objectForKey:name]) {
      return nil;
    }
    return [self getAdapterClass:[[self getVideoAllAdapter] objectForKey:name]];
  }
  return nil;
}

//挂钩代理实现方法
-(void)changeMethodWithClass:(Class)class methodName:(NSString*)name chagneClass:(Class)changeClass changeMethodName:(NSString*)change_name{
  Method originalM = class_getInstanceMethod([class class],NSSelectorFromString(name));
  Method exchangeM = class_getInstanceMethod(changeClass,NSSelectorFromString(change_name));
  method_exchangeImplementations(originalM, exchangeM);
}


//替换的viewController
-(UIViewController*)YuMIDebugAdapterFactoaryViewController{
  return _viewController;
}

//检查是否引入该适配器
-(BOOL)checkAdapter:(NSMutableDictionary*)dictionary  adapterName:(NSString*)name {
  
  if ([dictionary objectForKey:name]==nil) {
    return NO;
  }
  id adapter= [self getAdapterClass:[dictionary objectForKey:name]];
  return adapter?YES:NO;
}


//开始请求banner和插屏
-(void)requestAd:(Class)class{
  if (!class) {
    return;
  }
  void (*netTypeMethod)(id, SEL);
  netTypeMethod =(void (*)(id, SEL))[class methodForSelector:NSSelectorFromString(@"getAd")];
  netTypeMethod(class, NSSelectorFromString(@"getAd"));
}

-(void)preasentInterstitial:(Class)class{
  if (!class) {
    return;
  }
  void (*netTypeMethod)(id, SEL);
  netTypeMethod =(void (*)(id, SEL))[class methodForSelector:NSSelectorFromString(@"preasentInterstitial")];
  netTypeMethod(class, NSSelectorFromString(@"preasentInterstitial"));
}

//初始化视频广告
-(void)initVideoAd:(Class)class{
  if (!class) {
    return;
  }
  void (*netTypeMethod)(id, SEL);
  netTypeMethod =(void (*)(id, SEL))[class methodForSelector:NSSelectorFromString(@"initplatform")];
  netTypeMethod(class, NSSelectorFromString(@"initplatform"));
}

//询问视频广告是否播放完成
-(BOOL)isAvailableVideo:(Class)class{
  if (!class) {
    return NO;
  }
  BOOL (*netTypeMethod)(id, SEL);
  netTypeMethod =(BOOL (*)(id, SEL))[class methodForSelector:NSSelectorFromString(@"isAvailableVideo")];
  return netTypeMethod(class, NSSelectorFromString(@"isAvailableVideo"));
}
//开始播放
-(void)playVideo:(Class)class{
  if (!class) {
    return;
  }
  void (*netTypeMethod)(id, SEL);
  netTypeMethod =(void (*)(id, SEL))[class methodForSelector:NSSelectorFromString(@"playVideo")];
  netTypeMethod(class, NSSelectorFromString(@"playVideo"));
}




-(id)createBannerProvider:(NSDictionary*)dic{
  Class  provider_class = NSClassFromString(@"AdsYuMIProvider");
  id provider  =[[provider_class alloc]init];
  [self setValueByClass:provider attribute:@"providerId" value:[dic objectForKey:@"providerID"]];
  [self setValueByClass:provider attribute:@"outTime" value:[NSNumber numberWithInt:[[dic objectForKey:@"outTime"] intValue]]];
  [self setValueByClass:provider  attribute:@"key1" value:[dic objectForKey:@"key1"]];
  [self setValueByClass:provider  attribute:@"key2" value:[dic objectForKey:@"key2"]];
  [self setValueByClass:provider attribute:@"key3" value:[dic objectForKey:@"key3"]];
  return provider;
}

-(id)createVideoProvider:(NSDictionary*)dic{
  Class  provider_class = NSClassFromString(@"YuMIVideoProvider");
  id provider  =[[provider_class alloc]init];
  [self setValueByClass:provider  attribute:@"providerName" value:[dic objectForKey:@"providerID"]];
  [self setValueByClass:provider  attribute:@"outTime" value:[NSNumber numberWithInt:[[dic objectForKey:@"outTime"] intValue]]];
  [self setValueByClass:provider  attribute:@"key1" value:[dic objectForKey:@"key1"]];
  [self setValueByClass:provider  attribute:@"key2"value:[dic objectForKey:@"key2"]];
  [self setValueByClass:provider  attribute:@"key3" value:[dic objectForKey:@"key3"]];
  return provider;
}




//初始化 横幅和插屏adapter
-(id)createBannerAdapterWithInit:(Class)class delegate:(id)delegate view:(id)view core:(id)core provider:(id)provider adType:(NSInteger)adtype {
  id object=[class alloc];
  id (*netTypeMethod)(id, SEL,id,id,id,id,NSInteger);
  netTypeMethod = (id (*)(id, SEL,id,id,id,id,NSInteger))[object methodForSelector:NSSelectorFromString(@"initWithAdsYuMIAdapterDelegate:view:core:networkConfig:adType:")];
  id tmpclass= netTypeMethod(object, NSSelectorFromString(@"initWithAdsYuMIAdapterDelegate:view:core:networkConfig:adType:"),delegate,view,core,provider,adtype);
  return  tmpclass;
}

//初始化 视频 adapter
-(Class)createVideoAdapterWithInit:(Class)class delegate:(id)delegate core:(id)core provider:(id)provider adType:(NSInteger)adtype{
  
  id object=[class alloc];
  Class (*netTypeMethod)(id, SEL,id,id,id,NSInteger);
  netTypeMethod = (Class (*)(id, SEL,id,id,id,NSInteger))[object methodForSelector:NSSelectorFromString(@"initWithYuMIVideoAdapterDelegate:core:networkConfig:adType:")];
  Class tmpclass= netTypeMethod(object, NSSelectorFromString(@"initWithYuMIVideoAdapterDelegate:core:networkConfig:adType:"),delegate,core,provider,adtype);
  return  tmpclass;
}


//获取所有横幅适配器
-(NSMutableDictionary*)getBannerAllAdapter{
  Class  tmpclass =[self getAdapterClassByName:@"AdsYuMIBannerSDKAdNetworkRegistry"];
  return [self getAllAdapterNameByAdapterClass:tmpclass];
}
//获取所有插屏适配器
-(NSMutableDictionary*)getInterAllAdapter{
  Class  inter_class =[self getAdapterClassByName:@"AdsYuMIInterstitialSDKAdNetworkRegistry"];
  return [self getAllAdapterNameByAdapterClass:inter_class];
}
//获取所有视频适配器
-(NSMutableDictionary*)getVideoAllAdapter{
  Class  video_class =[self getAdapterClassByName:@"YuMIVideoSDKAdNetworkRegistry"];
  return [self getAllAdapterNameByAdapterClass:video_class];
}
//获取注册类Calss
-(Class)getAdapterClassByName:(NSString*)name{
  Class  class =NSClassFromString(name);
  Class (*netTypeMethod)(id, SEL);
  netTypeMethod = (Class (*)(id, SEL))[class methodForSelector:NSSelectorFromString(@"sharedRegistry")];
  Class tmpclass= netTypeMethod(class, NSSelectorFromString(@"sharedRegistry"));
  return  tmpclass;
}
//获取注册adapter 集合
-(NSMutableDictionary*)getAllAdapterNameByAdapterClass:(Class)class{
  NSMutableDictionary* (*netTypeMethod)(id, SEL);
  netTypeMethod = (NSMutableDictionary* (*)(id, SEL))[class methodForSelector:NSSelectorFromString(@"getAdapterDict")];
  NSMutableDictionary* adapter_dic = netTypeMethod(class, NSSelectorFromString(@"getAdapterDict"));
  return adapter_dic;
}
//解封注册类class
-(Class)getAdapterClass:(Class)class{
  Class (*netTypeMethod)(id, SEL);
  netTypeMethod = (Class (*)(id, SEL))[class methodForSelector:NSSelectorFromString(@"theClass")];
  Class tmpclass= netTypeMethod(class, NSSelectorFromString(@"theClass"));
  return  tmpclass;
}

-(void)setValueByClass:(id)object attribute:(NSString*)attribute value:(id)value{
  [object setValue:value forKey:attribute];
}


@end
