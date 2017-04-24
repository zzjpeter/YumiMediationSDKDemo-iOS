//
//  YuMIDebugLog.m
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/21.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import "YuMIDebugLog.h"

@interface YuMIDebugLog()

@property (nonatomic, strong)NSMutableString *debugLogString;

@end

@implementation YuMIDebugLog

static YuMIDebugLog *debugLog = nil;
+ (YuMIDebugLog*)defaultDebugLog {
  if (!debugLog) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      debugLog = [[YuMIDebugLog alloc] init];
      debugLog.debugLogString = [[NSMutableString alloc] init];
    });
  }
  return debugLog;
}

- (BOOL)setDebugLog:(NSString *)logString {
  [debugLog.debugLogString appendFormat:@"%@\n",logString];
  return YES;
}

- (NSString *)getDebugLog {
  
  return debugLog.debugLogString ;
}

- (void)clearDebugLog {
  debugLog.debugLogString = [[NSMutableString alloc] init];
}


@end
