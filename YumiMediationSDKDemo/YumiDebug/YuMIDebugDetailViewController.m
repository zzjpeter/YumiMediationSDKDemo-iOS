//
//  YuMIDebugDetailViewController.m
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/18.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import "YuMIDebugDetailViewController.h"
#import "YuMIDebugCoreCenter.h"
#import "YuMIDebugLog.h"

#define NavigationHeight 64
#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define widthS [[UIScreen mainScreen] bounds].size.width
#define heightS [[UIScreen mainScreen] bounds].size.height
#define AutoSizeScaleX widthS/375.f
#define AutoSizeScaleY heightS/667.f
CG_INLINE CGRect
CGRectMake1(CGFloat x,CGFloat y,CGFloat width,CGFloat height){
  CGRect rect;
  rect.origin.x = x*AutoSizeScaleX;
  rect.origin.y = y*AutoSizeScaleY;
  rect.size.width = width *AutoSizeScaleX;
  rect.size.height = height*AutoSizeScaleY;
  return rect;
}

@interface YuMIDebugDetailViewController () {
  YuMIDebugCoreCenter *bannerCoreCenter;
  YuMIDebugCoreCenter *ingterCoreCenter;
  YuMIDebugCoreCenter *videoCoreCenter;
  NSMutableDictionary *dic_ad;
  NSTimer             *logTimer;
  UISegmentedControl  *segment;
  UITextView          *textView;
}
@end

@implementation YuMIDebugDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[YuMIDebugLog defaultDebugLog] clearDebugLog];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = self.providerName;
  dic_ad =[[NSMutableDictionary alloc]init];
  
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setFrame:CGRectMake(0, 10, 50, 27)];
  [btn setTitle:@"<back" forState:UIControlStateNormal];
  [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
  [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
  self.navigationItem.leftBarButtonItem = left;
  
  bannerCoreCenter =[[YuMIDebugCoreCenter alloc]init];
  NSDictionary *adapterDic = [bannerCoreCenter checkModelExistenceOfAdapter:self.adArray];
  bannerCoreCenter.viewController=self;
  
  ingterCoreCenter =[[YuMIDebugCoreCenter alloc]init];
  ingterCoreCenter.viewController=self;
  
  videoCoreCenter =[[YuMIDebugCoreCenter alloc]init];
  videoCoreCenter.viewController=self;
  
  [self createTimer];
  [self handleDataArray];
  
  if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait || [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
    [self createUIWithAdapterDict:adapterDic];
  }else {
    [self createLandscapeUIWithAdapterDict:adapterDic];
  }
  
  [self setBtnStatusWithAdapterDict:adapterDic];
}

-(void)viewDidAppear:(BOOL)animated{

    [UIView animateWithDuration:0.3 animations:^{
        CGRect main_frame =self.view.frame;
        CGSize viewSize = [[UIScreen mainScreen]bounds].size;
        [self.view setFrame:CGRectMake(0, 0, main_frame.size.width, viewSize.height)];
    }];
}

- (void)backAction {
  [videoCoreCenter clearViewControllerForPresentBanner];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTimer {
  logTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLog) userInfo:nil repeats:YES];
}

- (void)updateLog {
  textView.text = [[YuMIDebugLog defaultDebugLog] getDebugLog];
}

-(void)handleDataArray{
  for (NSDictionary*dic in self.adArray) {
    [dic_ad setObject:dic forKey:[dic objectForKey:@"adtype"]];
  }
}

- (void)createUIWithAdapterDict:(NSDictionary *)adapterDict {
  
  NSMutableArray *tArray = [self createAdapterMutableArrayWithAdapterDict:adapterDict];
  
  //起始高度
  int origonY = 20+NavigationHeight;
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    origonY = NavigationHeight;
  }
  for (int i=0; i<tArray.count; i++) {
    
    int y = origonY+i*50;
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake1(20, y, 20, 20)];
    statusView.backgroundColor = [UIColor redColor];
    [self.view addSubview:statusView];
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake1(54, y, 280, 20)];
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.text = tArray[i];
    [self.view addSubview:statusLabel];
    
    if (i == adapterDict.count-1) {
      origonY = y+20+20;
    }
  }
  
  //Banner、cp、video的按钮排列
  NSArray *segmentArray = @[@"banner",@"interstital",@"video"];
  segment = [[UISegmentedControl alloc] initWithItems:segmentArray];
  [segment setFrame:CGRectMake1(20, origonY, 375-40, 35)];
  [segment addTarget:self action:@selector(cutAdType:) forControlEvents:UIControlEventValueChanged];
  segment.selectedSegmentIndex = 0;
  [self.view addSubview:segment];
  
  //请求和展示按钮
  NSArray *titleArray = @[@"request",@"show"];
  for (int i=0; i<2; i++) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake1(20+i*(135+100), origonY+35+20, 100, 35)];
    [btn addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:titleArray[i] forState:UIControlStateNormal];
    [btn setBackgroundColor:COLOR(13, 95, 255)];
    [btn setTag:100+i];
    [btn.layer setCornerRadius:5];
    [btn.layer setMasksToBounds:YES];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:btn];
  }
  
  //广告日志
  textView = [[UITextView alloc] initWithFrame:CGRectMake1(20, origonY+35+20+35+20, 375-40, 400)];
  textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
  textView.text = [[YuMIDebugLog defaultDebugLog] getDebugLog];
  [self.view addSubview:textView];
  
}

- (void)createLandscapeUIWithAdapterDict:(NSDictionary *)adapterDict {

  NSMutableArray *tArray = [self createAdapterMutableArrayWithAdapterDict:adapterDict];
  
  //起始高度
  int origonY = 20+22;
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    origonY = NavigationHeight+22;
  }
  
  for (int i=0; i<tArray.count; i++) {
    
    int y = origonY+i*50;
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(20, y, 20, 20)];
    statusView.backgroundColor = [UIColor redColor];
    [self.view addSubview:statusView];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, y, 280, 20)];
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.text = tArray[i];
    [self.view addSubview:statusLabel];
    
    if (i == adapterDict.count-1) {
      origonY = y+20+20;
    }
    
  }
  
  //Banner、cp、video的按钮排列
  NSArray *segmentArray = @[@"banner",@"interstital",@"video"];
  segment = [[UISegmentedControl alloc] initWithItems:segmentArray];
  [segment setFrame:CGRectMake(20, origonY, 375-40, 35)];
  [segment addTarget:self action:@selector(cutAdType:) forControlEvents:UIControlEventValueChanged];
  segment.selectedSegmentIndex = 0;
  [self.view addSubview:segment];
  
  //请求和展示按钮
  NSArray *titleArray = @[@"request",@"show"];
  for (int i=0; i<2; i++) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(segment.frame.origin.x+segment.frame.size.width+10+(90+5)*i, origonY, 90, 35)];
    [btn addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:titleArray[i] forState:UIControlStateNormal];
    [btn setBackgroundColor:COLOR(13, 95, 255)];
    [btn setTag:100+i];
    [btn.layer setCornerRadius:5];
    [btn.layer setMasksToBounds:YES];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:btn];
  }
  
  //广告日志
  textView = [[UITextView alloc] initWithFrame:CGRectMake(20, segment.frame.origin.y+segment.frame.size.height+10, widthS-40, heightS-segment.frame.origin.y-35-10-50)];
  textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
  textView.text = [[YuMIDebugLog defaultDebugLog] getDebugLog];
  [self.view addSubview:textView];
  
}

- (NSMutableArray *)createAdapterMutableArrayWithAdapterDict:(NSDictionary *)adapterDict {
  NSMutableArray *tArray = [[NSMutableArray alloc] init];
  for (NSString *text in adapterDict.allKeys) {
    if ([text isEqualToString:@"2"]&&[adapterDict[text] isEqualToString:@"0"]) {
      [tArray addObject:@"banner of adapter not integration"];
    }else if ([text isEqualToString:@"3"]&&[adapterDict[text] isEqualToString:@"0"]) {
      [tArray addObject:@"interstital of adapter not integration"];
    }else if ([text isEqualToString:@"5"]&&[adapterDict[text] isEqualToString:@"0"]) {
      [tArray addObject:@"video of adapter not integration"];
    }else {
      break;
    }
  }
  return tArray;
}

- (void)setBtnStatusWithAdapterDict:(NSDictionary *)adapterDict  {
  
  UIButton *req_btn = (UIButton *)[self.view viewWithTag:100];
  UIButton *show_btn = (UIButton *)[self.view viewWithTag:101];
  
  //隐藏banner的请求按钮
  if (segment.selectedSegmentIndex==0) {
    req_btn.hidden = YES;
  }else {
    req_btn.hidden = NO;
  }
  
  //adapter不存在的话，request和show按钮都不可点击
  if ((segment.selectedSegmentIndex==0&&[adapterDict[@"2"] isEqualToString:@"0"]) ||
      (segment.selectedSegmentIndex==1&&[adapterDict[@"3"] isEqualToString:@"0"]) ||
      (segment.selectedSegmentIndex==2&&[adapterDict[@"5"] isEqualToString:@"0"]))
  {
    req_btn.enabled = NO;
    show_btn.enabled = NO;
    
    req_btn.backgroundColor = [UIColor redColor];
    show_btn.backgroundColor = [UIColor redColor];
    
  }
  //后台无配置的广告类型按钮置灰
  else if   ((segment.selectedSegmentIndex==0&&[adapterDict[@"2"] isEqualToString:@"1"]) ||
             (segment.selectedSegmentIndex==1&&[adapterDict[@"3"] isEqualToString:@"1"]) ||
             (segment.selectedSegmentIndex==2&&[adapterDict[@"5"] isEqualToString:@"1"]))
  {
    req_btn.enabled = YES;
    show_btn.enabled = YES;
    
    req_btn.backgroundColor = COLOR(13, 95, 255);
    show_btn.backgroundColor = COLOR(13, 95, 255);
    
  }
  else {
    req_btn.enabled = NO;
    show_btn.enabled = NO;
    
    req_btn.backgroundColor = [UIColor grayColor];
    show_btn.backgroundColor = [UIColor grayColor];
  }
  
  //源码SDK播放成功||Debug播放成功，show按钮变绿
  if ((segment.selectedSegmentIndex==0&&[self.singleDict[@"2"] isEqualToString:@"YES"]) ||
      (segment.selectedSegmentIndex==1&&[self.singleDict[@"3"] isEqualToString:@"YES"]) ||
      (segment.selectedSegmentIndex==2&&[self.singleDict[@"5"] isEqualToString:@"YES"]))
  {
    show_btn.backgroundColor = [UIColor greenColor];
  }
  
}

- (void)adClick:(UIButton *)b {
  
  if (b.tag == 100) {
    if (segment.selectedSegmentIndex==1) {//inter
      [ingterCoreCenter getAdByModel:[dic_ad objectForKey:@"3"]];
    }
    if (segment.selectedSegmentIndex==2) {//video
      DLog(@"video request");
      [videoCoreCenter getAdByModel:[dic_ad objectForKey:@"5"]];
    }
    
  }else if (b.tag == 101) {
    
    if (segment.selectedSegmentIndex==0) {//banner
      [bannerCoreCenter removeBanner];
      [bannerCoreCenter getAdByModel:[dic_ad objectForKey:@"2"]];
    }
    if (segment.selectedSegmentIndex==1) {//inter
      [ingterCoreCenter showAd];
    }
    if (segment.selectedSegmentIndex==2) {//inter
      [videoCoreCenter showAd];
    }
    
  }
}

- (void)cutAdType:(UISegmentedControl *)segment {
  NSDictionary *adapterDic = [bannerCoreCenter checkModelExistenceOfAdapter:self.adArray];
  [self setBtnStatusWithAdapterDict:adapterDic];
  
}

-(void)dealloc {
  textView = nil;
  if (logTimer) {
    [logTimer invalidate];
    logTimer = nil;
  }
  if (bannerCoreCenter) {
    [bannerCoreCenter removeBanner];
    bannerCoreCenter.viewController=nil;
    bannerCoreCenter = nil;
  }
  if (ingterCoreCenter) {
    [ingterCoreCenter removeBanner];
    ingterCoreCenter.viewController=nil;
    ingterCoreCenter = nil;
  }
  if (videoCoreCenter) {
    [videoCoreCenter removeBanner];
    videoCoreCenter.viewController=nil;
    videoCoreCenter = nil;
  }
  
  segment=nil;
  dic_ad=nil;
  _delegate = nil;
  _singleDict=nil;
  _providerName=nil;
  _adArray=nil;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
