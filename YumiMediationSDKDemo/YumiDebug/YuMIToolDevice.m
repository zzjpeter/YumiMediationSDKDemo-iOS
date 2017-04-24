//
//  YuMIToolDevice.m
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/18.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import "YuMIToolDevice.h"

@implementation YuMIToolDevice


+(YuMIToolDevice*)shareToolDevice{
  static YuMIToolDevice* sharedDevice = nil;
  if (!sharedDevice) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedDevice = [[self alloc] init];
    });
  }
  return sharedDevice;
}

- (NSString *)getCacheFilePath:(NSString*)cache_path{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString *libDirectory = [paths objectAtIndex:0];
  NSString *path = [libDirectory stringByAppendingPathComponent:cache_path];
  return path;
}

- (NSData *)getDataFromFile:(NSString *)path{
  NSData *configData = nil;
  NSFileManager *fileManager = [[NSFileManager alloc] init];
  if([fileManager fileExistsAtPath:path]){
    configData = [[NSData alloc] initWithContentsOfFile:path];
  }
  return configData;
}

-(BOOL)isBlankString:(NSString*)str{
  if (str==nil) {
    return YES;
  }
  if (str==NULL) {
    return YES;
  }
  if ([str isKindOfClass:[NSNull class]]) {
    return YES;
  }
  if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
    return YES;
  }
  return NO;
}

-(NSString*)getSaveConfigStr:(NSString*)appid  channel:(NSString*)channel  version:(NSString*)version  adType:(NSUInteger)adType{
  if ([[YuMIToolDevice shareToolDevice] isBlankString:channel]) {
    channel=@"channel";
  }
  if ([[YuMIToolDevice shareToolDevice] isBlankString:version]) {
    version =@"version";
  }
  return [NSString stringWithFormat:@"%@_%@_%@_%d",appid,channel,version,(int)adType];
}

-(NSString*)getProviderNameById:(NSString*)providerId{
  switch ([providerId integerValue]) {
    case 10022: return @"BaiDu";
    case 10026: return @"GDT";
    case 10010: return @"InMobi";
    case 10023: return @"Chance";
    case 10007: return @"Facebook";
    case 10008: return @"Flurry";
    case 10027: return @"IFLY";
    case 10002: return @"Admob";
    case 10006: return @"Chartboost";
    case 20001: return @"Yumi";
    case 10028: return @"MoGo";
    case 10005: return @"Applovin";
    case 10012: return @"Loopme";
    case 10015: return @"Smatto";
    case 10003: return @"Adview";
    case 10009: return @"iAd";
    case 10024: return @"Dianru";
    case 10016: return @"StartApp";
    case 10014: return @"Mopub";
    case 10013: return @"MMedia";
    case 10029: return @"YiMa";
    case 30001: return @"Yumimobi";
    case 10033: return @"InMobiNative";
    case 10032: return @"GDTNative";
    case 10039: return @"AdmobNative";
    case 10041: return @"PubNative";
    case 10042: return @"GlispaNative";
    case 10043: return @"SouHu";
    case 10045: return @"Alimama";
    case 10001: return @"Adcolony";
    case 10025: return @"DoMob";
    case 10021: return @"Vungle";
    case 10019: return @"Unity";
    case 10018: return @"Tapjoy";
    case 10017: return @"Supersonic";
    case 10047: return @"Ironsource";
    case 10049: return @"FacebookNative";
  }
  return @"未知";
}

@end
