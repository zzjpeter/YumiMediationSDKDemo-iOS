//
//  YumiViewController.h
//  YumiMediationDebugCenter-iOS
//
//  Created by ShunZhi Tang on 2017/7/13.
//  Copyright © 2017年 Zplay. All rights reserved.
//

@import UIKit;

@protocol YumiViewControllerDelegate <NSObject>

- (void)modifyYumiID:(NSString *)yumiID channelID:(NSString *)channelID versionID:(NSString *)versionID;

@end

@interface YumiViewController : UIViewController

@property (nonatomic, weak) id<YumiViewControllerDelegate> delegate;
@property (nonatomic, assign, getter=isPresented) BOOL presented;

@end
