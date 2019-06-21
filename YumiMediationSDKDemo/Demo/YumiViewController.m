//
//  YumiViewController.m
//  YumiMediationDebugCenter-iOS
//
//  Created by ShunZhi Tang on 2017/7/13.
//  Copyright © 2017年 Zplay. All rights reserved.
//

#import "YumiViewController.h"
#import "CALayer+Transition.h"
#import "UIView+Toast.h"
#import "YumiMediationAppViewController.h"
#import "YumiMediationInitializeInfoUserDefaults.h"
#import "YumiMediationInitializeModel.h"
#import <YumiMediationSDK/YumiTool.h>
#import <YumiMediationSDK/YumiMediationGDPRManager.h>

#define PLACEMENTIDLENGTH 1

@interface YumiViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *placementIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *channelIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *versionIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *gotoYumiDemo;
@property (weak, nonatomic) IBOutlet UITableView *placementIDTableView;
@property (weak, nonatomic) IBOutlet UITableView *adTypeTableView;
@property (weak, nonatomic) IBOutlet UIImageView *triangleImg;
@property (weak, nonatomic) IBOutlet UIButton *selectAdTypeBtn;
@property (weak, nonatomic) IBOutlet UISwitch *bannerH250;
@property (weak, nonatomic) IBOutlet UISwitch *smartBannerLandscape;
@property (weak, nonatomic) IBOutlet UISwitch *smartBannerPortrait;
@property (weak, nonatomic) IBOutlet UISwitch *gdprSwitch;

@property (nonatomic) NSString *placementID;
@property (nonatomic) NSString *channelID;
@property (nonatomic) NSString *versionID;
@property (nonatomic) NSArray *placementIDsInfo;
@property (nonatomic) NSArray *adTypesInfo;

@end

@implementation YumiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.placementIDTableView.tableFooterView = [[UIView alloc] init];
    self.placementIDTextField.delegate = self;
    self.adTypeTableView.layer.cornerRadius = 5.0;
    self.adTypeTableView.layer.borderWidth = 1.0;
    self.adTypeTableView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    self.adTypeTableView.clipsToBounds = YES;

    [self initializePlacementIDs];

    if (!self.placementID) {
        self.placementID = placementID;
    }
    if (!self.channelID) {
        self.channelID = channelID;
    }
    if (!self.versionID) {
        self.versionID = versionID;
    }

    self.placementIDTextField.text = self.placementID;
    self.channelIDTextField.text = self.channelID;
    self.versionIDTextField.text = self.versionID;
    if (self.isPresented) {
        [self updatedAdTypeMessageWith:self.adType];
    }
    if (self.bannerSize == kYumiMediationAdViewBanner300x250) {
        self.bannerH250.on = YES;
    }
    if (self.bannerSize == kYumiMediationAdViewSmartBannerPortrait) {
        self.smartBannerPortrait.on = YES;
    }
    if (self.bannerSize == kYumiMediationAdViewSmartBannerLandscape) {
        self.smartBannerLandscape.on = YES;
    }
    
    self.gdprSwitch.on = ([[YumiMediationGDPRManager sharedGDPRManager] getConsentStatus] == YumiMediationConsentStatusPersonalized) ;
}

- (void)initializePlacementIDs {

    YumiMediationInitializeInfoUserDefaults *yumiUserDefaults =
        [YumiMediationInitializeInfoUserDefaults sharedPlacementIDsUserDefaults];

    self.placementIDsInfo = [yumiUserDefaults fetchMediationPlacementIDs];

    if (self.placementIDsInfo.count > 0) {
        YumiMediationInitializeModel *yumiModel = [self.placementIDsInfo firstObject];
        self.placementID = yumiModel.placementID;
        self.channelID = yumiModel.channelID;
        self.versionID = yumiModel.versionID;
    }
}

#pragma mark : - provate method
- (void)showMessage {
    [self.view makeToast:@"placementID is nil or  The length error " duration:1.0 position:CSToastPositionCenter];
}

- (void)setRootVc {
    YumiMediationAppViewController *rootVc =
        [[YumiMediationAppViewController alloc] initWithPlacementID:self.placementID
                                                          channelID:self.channelID
                                                          versionID:self.versionID
                                                             adType:self.adType];
    [UIApplication sharedApplication].keyWindow.rootViewController = rootVc;
    if (self.bannerH250.on) {
        rootVc.bannerSize = kYumiMediationAdViewBanner300x250;
    }
    if (self.smartBannerPortrait.on) {
        rootVc.bannerSize = kYumiMediationAdViewSmartBannerPortrait;
    }
    if (self.smartBannerLandscape.on) {
        rootVc.bannerSize = kYumiMediationAdViewSmartBannerLandscape;
    }
    [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRamdom
                                                                      subType:TransitionSubtypesFromRamdom
                                                                        curve:TransitionCurveRamdom
                                                                     duration:2.0];
}

#pragma mark :- touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.placementIDTableView.hidden = YES;
    [self setupAdTypeHidden];
}

- (IBAction)popViewToSelectAdType:(UIButton *)sender {
    [self setupAdTypeShow];
}

- (void)setupAdTypeHidden {
    self.triangleImg.hidden = YES;
    self.adTypeTableView.hidden = YES;
}

- (void)setupAdTypeShow {
    self.triangleImg.hidden = NO;
    self.adTypeTableView.hidden = NO;
}

- (void)updatedAdTypeMessageWith:(YumiAdType)adType {
    self.adType = adType;
    NSString *adTypeMsg = [NSString stringWithFormat:@"Selected: %@", self.adTypesInfo[(NSUInteger)self.adType]];
    [self.selectAdTypeBtn setTitle:adTypeMsg forState:UIControlStateNormal];
}

- (NSArray *)adTypesInfo {
    if (!_adTypesInfo) {
        _adTypesInfo = @[ @"Banner", @"Interstitial", @"Video", @"Splash", @"Native" ];
    }
    return _adTypesInfo;
}

- (IBAction)ClickGotoYumiDemo:(UIButton *)sender {

    NSString *placementIDTextString = [self.placementIDTextField.text
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (placementIDTextString.length < PLACEMENTIDLENGTH) {
        [self showMessage];
        return;
    }

    self.placementID = placementIDTextString;
    self.channelID = [self.channelIDTextField.text
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.versionID = [self.versionIDTextField.text
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // save
    [self saveLocalStorage];

    if (self.isPresented) {
        YumiMediationAdViewBannerSize bannerSizeTemp =
            [[YumiTool sharedTool] isiPad] ? kYumiMediationAdViewBanner728x90 : kYumiMediationAdViewBanner320x50;
        if (self.bannerH250.on) {
            bannerSizeTemp = kYumiMediationAdViewBanner300x250;
        }
        if (self.smartBannerPortrait.on) {
            bannerSizeTemp = kYumiMediationAdViewSmartBannerPortrait;
        }
        if (self.smartBannerLandscape.on) {
            bannerSizeTemp = kYumiMediationAdViewSmartBannerLandscape;
        }
        __weak typeof(self) weakSelf = self;
        [self
            dismissViewControllerAnimated:NO
                               completion:^{
                                   if (weakSelf.delegate &&
                                       [weakSelf.delegate respondsToSelector:@selector
                                                          (modifyPlacementID:channelID:versionID:adType:bannerSize:)]) {
                                       [weakSelf.delegate modifyPlacementID:weakSelf.placementID
                                                                  channelID:weakSelf.channelID
                                                                  versionID:weakSelf.versionID
                                                                     adType:weakSelf.adType
                                                                 bannerSize:bannerSizeTemp];
                                   }
                               }];
        [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRamdom
                                                                          subType:TransitionSubtypesFromRamdom
                                                                            curve:TransitionCurveRamdom
                                                                         duration:2.0];
        return;
    }
    [self setRootVc];
}

- (void)saveLocalStorage {
    YumiMediationInitializeInfoUserDefaults *yumiUserDefaults =
        [YumiMediationInitializeInfoUserDefaults sharedPlacementIDsUserDefaults];

    YumiMediationInitializeModel *yumiModel = [[YumiMediationInitializeModel alloc] init];
    yumiModel.placementID = self.placementID;
    yumiModel.channelID = self.channelID;
    yumiModel.versionID = self.versionID;

    [yumiUserDefaults persistMediationInitializeInfo:yumiModel];
}

- (IBAction)handleGDPRValue:(UISwitch *)sender {
    if (sender.on) {
        [[YumiMediationGDPRManager sharedGDPRManager] updateNetworksConsentStatus:YumiMediationConsentStatusPersonalized];
        return;
    }
     [[YumiMediationGDPRManager sharedGDPRManager] updateNetworksConsentStatus:YumiMediationConsentStatusNonPersonalized];
}


#pragma mark : -UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.placementIDTableView.hidden) {
        [self.placementIDTableView reloadData];
        self.placementIDTableView.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *placementIDTextString = [self.placementIDTextField.text
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (placementIDTextString.length < PLACEMENTIDLENGTH) {
        [self showMessage];
    }
    self.channelIDTextField.text = @"";
    self.versionIDTextField.text = @"";
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    if (self.placementIDTableView.hidden) {
        [self.placementIDTableView reloadData];
        self.placementIDTableView.hidden = NO;
    }

    return YES;
}
#pragma mark : - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.adTypeTableView) {
        return self.adTypesInfo.count;
    }
    return self.placementIDsInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.placementIDTableView) {
        static NSString *cellID = @"YumiCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        YumiMediationInitializeModel *yumiModel = self.placementIDsInfo[indexPath.row];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.text = yumiModel.placementID;

        return cell;
    }

    static NSString *adTypeCellId = @"adTypeCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adTypeCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adTypeCellId];
    }
    cell.textLabel.text = self.adTypesInfo[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    return cell;
}

#pragma mark : - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.adTypeTableView) {
        return 32;
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == self.placementIDTableView) {
        YumiMediationInitializeModel *yumiModel = self.placementIDsInfo[indexPath.row];

        self.placementIDTextField.text = yumiModel.placementID;
        self.channelIDTextField.text = yumiModel.channelID;
        self.versionIDTextField.text = yumiModel.versionID;

        self.placementIDTableView.hidden = YES;
    }

    if (tableView == self.adTypeTableView) {
        [self setupAdTypeHidden];
        [self updatedAdTypeMessageWith:(YumiAdType)indexPath.row];
    }
}

@end
