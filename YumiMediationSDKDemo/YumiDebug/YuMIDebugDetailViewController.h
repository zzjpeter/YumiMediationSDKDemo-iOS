//
//  YuMIDebugDetailViewController.h
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/18.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuMIDebugDetailViewController : UIViewController

/**
 单一平台不同广告类型是否展示成功集合
 */
@property (nonatomic, strong) NSDictionary *singleDict;
/**
 获取广告平台Adapter是否添加集合
 */
@property (nonatomic, strong) NSMutableArray *adArray;
/**
 标题-单一平台的名字
 */
@property (nonatomic, copy)  NSString *providerName;
/**
 代理
 */
@property (nonatomic, assign) id delegate;


- (void)backAction;


@end
