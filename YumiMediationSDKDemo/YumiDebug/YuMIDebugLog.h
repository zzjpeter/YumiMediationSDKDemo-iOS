//
//  YuMIDebugLog.h
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/21.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef DLog
#define DLog(fmt, ...) \
[[YuMIDebugLog defaultDebugLog] setDebugLog:fmt]
#endif

@interface YuMIDebugLog : NSObject

+ (YuMIDebugLog*)defaultDebugLog;
- (BOOL)setDebugLog:(NSString *)logString;
- (NSString *)getDebugLog;
- (void)clearDebugLog;

@end
