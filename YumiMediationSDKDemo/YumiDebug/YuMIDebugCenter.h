//
//  YuMIDebugCore.h
//  YuMIDebugCenter
//
//  Created by chenzhangtao on 2016/11/17.
//  Copyright © 2016年 CastielChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YuMIDebugCenter : NSObject

/**
 获取DebugCenter的单例

 @return 单例对象
 */
+ (YuMIDebugCenter *)shareInstance;

/**
 获取存储路径的字典，为了刷新使用

 @return 路径字典
 */
- (NSMutableDictionary *)getPathDictionary;

/**
 调起Debug调试视图

 @param viewController 传入视图，在该视图上面调起Debug视图
 */
-(void)startDebugging:(UIViewController*)viewController;

@end
