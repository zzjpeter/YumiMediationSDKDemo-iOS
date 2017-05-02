//
//  AdsYuMILogCenter.h
//  AdsYuMI
//
// Copyright (c) 2015年 AdsYuMI. All rights reserved.
//
//
#import <Foundation/Foundation.h>

#ifndef YMLog
#define YMLog(lv, fmt, ...)                                                                                            \
    if ([[AdsYuMILogCenter shareInstance] canLog:lv]) {                                                                \
        if ([[AdsYuMILogCenter shareInstance] getLogLeveFlag] == YuMILogDebug) {                                       \
            NSLog((@"ADYUMI-Debug: " fmt), ##__VA_ARGS__);                                                             \
        } else {                                                                                                       \
            NSLog((@"ADYUMI-"                                                                                          \
                    "<FUNCTION:%s>: " fmt),                                                                            \
                  __FUNCTION__, ##__VA_ARGS__);                                                                        \
        }                                                                                                              \
    }
#endif

typedef enum {
    YuMILogDevelopment = 18 >> 1,
    YuMILogProduction = 1 << 0,
    YuMILogDebug = 1 << 1,
    YuMILogNone = 1 << 2,
    YuMILogTemp = 1 << 3
} YuMILogLeve;

typedef enum {
    /**
     *  生产日志
     */
    YMP = 1 << 0,
    /**
     *  调试日志
     */
    YMD = 1 << 1,
    /**
     *  临时日志
     */
    YMT = 1 << 3
} YuMILogLeveSample;

@interface AdsYuMILogCenter : NSObject

+ (AdsYuMILogCenter *)shareInstance;

- (BOOL)canLog:(int)levelFlag;

- (void)setLogLeveFlag:(YuMILogLeve)levelFlag;

- (YuMILogLeve)getLogLeveFlag;

@end
