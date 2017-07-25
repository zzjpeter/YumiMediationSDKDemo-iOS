//
//  YumiStreamViewController.m
//  YumiMediationSDK-iOS
//
//  Created by 魏晓磊 on 2017/7/7.
//  Copyright © 2017年 JiaDingYi. All rights reserved.
//

#import "YumiStreamViewController.h"
#import <YumiMediationSDK/YUMIStream.h>
#import <YumiMediationSDK/YUMIStreamCustomView.h>
#import <YumiMediationSDK/YUMIStreamLogCenter.h>
#import <YumiMediationSDK/YUMIStreamModel.h>

@interface YumiStreamViewController () <YUMIStreamDelegate, YMAdCustomViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *streamTextField;
@property (nonatomic) YUMIStream *stream;
@property (nonatomic) YUMIStreamCustomView *customView;
@property (nonatomic, assign) NSUInteger streamNumber;

@end

@implementation YumiStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    self.title = @"原生广告";

    [[YUMIStreamLogCenter shareInstance] setLogLeveFlag:9];
}

- (YUMIStreamCustomView *)customView {
    if (!_customView) {
        _customView =
            [[YUMIStreamCustomView alloc] initWithCustomView:CGRectMake((self.view.frame.size.width - 320) / 2,
                                                                        self.view.frame.size.height - 50, 320, 50)
                                                   clickType:CustomViewClickTypeOpenSystem
                                                    delegate:self];
    }

    return _customView;
}

- (NSString *)streamHtmlWithStreamModel:(YUMIStreamModel *)smodel {
    NSBundle *bundle =
        [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"YumiMediationSDK" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:@"stream320x50_icon" ofType:@"html"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *streamHtml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    streamHtml = [NSString stringWithFormat:streamHtml, @"100%", @"100%", @"100%", @"76%", smodel.iconUrl, smodel.desc];
    return streamHtml;
}

- (YUMIStream *)stream {
    if (!_stream) {
        _stream = [[YUMIStream alloc] initWithYumiID:self.streamTextField.text channelID:@"" versionID:@""];
        _stream.delegate = self;
    }

    return _stream;
}

- (IBAction)requestStream:(id)sender {
    [self.stream loadStream];
}

- (IBAction)removeStream:(id)sender {
    [self.customView removeFromSuperview];
}

- (IBAction)present:(id)sender {
    if (![_stream isExistStream]) {
        return;
    }
    YUMIStreamModel *smodel = [_stream getStreamModel];
    switch (smodel.showType) {
        case showOfData: {
            self.customView.streamModel = smodel;
            [self.customView loadHTMLString:[self streamHtmlWithStreamModel:smodel]];
            break;
        }
        case showOfView:
            [smodel reloadWebview];
            break;
        default:
            break;
    }
}

#pragma mark - YUMIStreamDelegate
- (UIViewController *)viewControllerForPresentStream {
    return self;
}
- (void)returnStreamModel:(YUMIStreamModel *)model impressionSize:(CGSize)adSize{
    
}

- (void)returnStreamModel:(YUMIStreamModel *)model {
    UIView *view = [[UIView alloc]
        initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 162, self.view.frame.size.width, 162)];
    [model showInview:view];
    [self.view addSubview:view];
}

- (void)streamAdStartToRequest {
}

- (void)streamAdDidReceiveNumber:(NSUInteger)number {
}

- (void)streamAdFailToReceive:(NSError *)error {
}

#pragma mark - CustomViewdelegate

- (void)adCustomViewDidFail:(NSError *)error {
}

- (void)adCustomViewDidFinsh:(YUMIStreamCustomView *)customView {
    [self.view addSubview:customView];
    [customView.streamModel showInview:self.view];
}

- (void)adCustomViewDidClick:(YUMIStreamCustomView *)customView {
    [customView.streamModel clickStreamAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
