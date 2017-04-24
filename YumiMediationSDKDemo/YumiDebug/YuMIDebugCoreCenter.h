//
//  YuMIDebugCoreCenter.h
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/18.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AdsYuMIAdNetworkAdapter;

@protocol YuMIDebugCoreCenterDelegate <NSObject>

-(UIViewController*)YuMIDebugCoreCenterViewController;
-(void)YuMIDebugCoreCenterRequestSuccess;
-(void)YuMIDebugCoreCenterRequestFail:(NSUInteger)errorCode;

@end


@interface YuMIDebugCoreCenter : NSObject

@property(assign,nonatomic)UIViewController* viewController;

-(NSDictionary*)checkModelExistenceOfAdapter:(id)model;
-(void)getAdByModel:(NSDictionary*)model;
-(void)showAd;
-(void)removeBanner;
-(void)clearViewControllerForPresentBanner;

@end
