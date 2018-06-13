//
//  PADemoUtils.h
//  PlayableAds_Example
//
//  Created by lgd on 2018/4/18.
//  Copyright © 2018年 on99. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PADemoUtils : NSObject

+ (instancetype)shared;

- (BOOL)createTagFile;
- (BOOL)removeTagFile;
- (BOOL)tagFileExsit;

@end
