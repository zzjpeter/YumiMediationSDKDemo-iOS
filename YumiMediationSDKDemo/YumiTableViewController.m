//
//  YumiTableViewController.m
//  YumiMediationSDK-iOS
//
//  Created by 魏晓磊 on 17/6/5.
//  Copyright © 2017年 JiaDingYi. All rights reserved.
//

#import "YumiTableViewController.h"
#import <YumiMediationSDK/YumiTest.h>

@interface YumiTableViewController ()

@property (nonatomic, nonnull) NSArray *textArray;
@property (nonatomic, nonnull) NSArray *adTypeNameArray;

@end

@implementation YumiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"玉米广告";
    self.textArray = @[ @"横幅", @"插屏", @"视频", @"原生", @"开屏" ];
    self.adTypeNameArray = @[
        @"YumiBannerViewController", @"YumiInterstitalViewController", @"YumiVideoViewController",
        @"YumiStreamViewController", @"YumiSplashViewController"
    ];

    [self implementTestFeature];
}

- (void)implementTestFeature {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择测试环境"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action){
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [YumiTest enableTestMode];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifuer = @"YumiTableViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifuer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifuer];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = self.textArray[indexPath.row];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class myClass = NSClassFromString(self.adTypeNameArray[indexPath.row]);
    UIViewController *viewController = (UIViewController *)[myClass new];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
