//
//  YuMIToolDevice.h
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/18.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YuMIToolDevice : NSObject


/**
 工具类单例

 @return 返回一个单例
 */
+ (YuMIToolDevice*)shareToolDevice;

/**
 判断当前字符串是否为空

 @param str 需要判空的字符串

 @return YES 为空  NO 不为空
 */
- (BOOL)isBlankString:(NSString *)str;
/**
 生成缓冲路径地址

 @param cache_path 地址

 @return 路径地址
 */
- (NSString *)getCacheFilePath:(NSString *)cache_path;
/**
 根据路径获取缓冲数据

 @param path 路径地址

 @return 缓冲数据
 */
- (NSData *)getDataFromFile:(NSString *)path;
/**
 本地配置的地址拼接

 @param appid   玉米ID
 @param channel 渠道ID
 @param version 版本ID
 @param adType  广告类型ID

 @return 配置key
 */
- (NSString *)getSaveConfigStr:(NSString *)appid  channel:(NSString *)channel  version:(NSString *)version  adType:(NSUInteger)adType;
/**
 根据平台ID获取平台名称

 @param providerId 平台ID

 @return 平台名称
 */
- (NSString *)getProviderNameById:(NSString *)providerId;

@end
