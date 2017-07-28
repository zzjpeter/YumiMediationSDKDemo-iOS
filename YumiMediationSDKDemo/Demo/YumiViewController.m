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

#define YUMIIDLENGTH 32
static NSString *const yumiID = @"3f521f0914fdf691bd23bf85a8fd3c3a";
static NSString *const channelID = @"";
static NSString *const versionID = @"";

@interface YumiViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *yumiIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *channelIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *versionIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *gotoYumiDemo;
@property (weak, nonatomic) IBOutlet UITableView *yumiIDTableView;

@property (nonatomic) NSString *yumiID;
@property (nonatomic) NSString *channelID;
@property (nonatomic) NSString *versionID;
@property (nonatomic) NSArray *yumiIDsInfo;

@end

@implementation YumiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.yumiIDTableView.tableFooterView = [[UIView alloc] init];
    self.yumiIDTextField.delegate = self;

    [self initializeYumiIDs];

    if (!self.yumiID) {
        self.yumiID = yumiID;
    }
    if (!self.channelID) {
        self.channelID = channelID;
    }
    if (!self.versionID) {
        self.versionID = versionID;
    }

    self.yumiIDTextField.text = self.yumiID;
    self.channelIDTextField.text = self.channelID;
    self.versionIDTextField.text = self.versionID;
}

- (void)initializeYumiIDs {

    YumiMediationInitializeInfoUserDefaults *yumiUserDefaults =
        [YumiMediationInitializeInfoUserDefaults sharedYumiIDsUserDefaults];

    self.yumiIDsInfo = [yumiUserDefaults fetchMediationYumiIDs];

    if (self.yumiIDsInfo.count > 0) {
        YumiMediationInitializeModel *yumiModel = [self.yumiIDsInfo firstObject];
        self.yumiID = yumiModel.yumiID;
        self.channelID = yumiModel.channelID;
        self.versionID = yumiModel.versionID;
    }
}

#pragma mark : - provate method

- (void)showMessage {
    [self.view makeToast:@"yumiID is nil or  The length error " duration:1.0 position:CSToastPositionCenter];
}

- (void)setRootVc {
    YumiMediationAppViewController *rootVc = [[YumiMediationAppViewController alloc] initWithYumiID:self.yumiID
                                                                                          channelID:self.channelID
                                                                                          versionID:self.versionID];
    [UIApplication sharedApplication].keyWindow.rootViewController = rootVc;

    [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRamdom
                                                                      subType:TransitionSubtypesFromRamdom
                                                                        curve:TransitionCurveRamdom
                                                                     duration:2.0];
}

#pragma mark :- touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.yumiIDTableView.hidden = YES;
}

- (IBAction)ClickGotoYumiDemo:(UIButton *)sender {

    NSString *yumiIDTextString =
        [self.yumiIDTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (yumiIDTextString.length != YUMIIDLENGTH) {
        [self showMessage];
        return;
    }

    self.yumiID = yumiIDTextString;
    self.channelID = [self.channelIDTextField.text
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.versionID = [self.versionIDTextField.text
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // save
    [self saveLocalStorage];

    if (self.isPresented) {

        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:NO
                                 completion:^{
                                     if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector
                                                                                 (modifyYumiID:channelID:versionID:)]) {
                                         [weakSelf.delegate modifyYumiID:weakSelf.yumiID
                                                               channelID:weakSelf.channelID
                                                               versionID:weakSelf.versionID];
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
        [YumiMediationInitializeInfoUserDefaults sharedYumiIDsUserDefaults];

    YumiMediationInitializeModel *yumiModel = [[YumiMediationInitializeModel alloc] init];
    yumiModel.yumiID = self.yumiID;
    yumiModel.channelID = self.channelID;
    yumiModel.versionID = self.versionID;

    [yumiUserDefaults persistMediationInitializeInfo:yumiModel];
}

#pragma mark : -UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.yumiIDTableView.hidden) {
        [self.yumiIDTableView reloadData];
        self.yumiIDTableView.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *yumiIDTextString =
        [self.yumiIDTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (yumiIDTextString.length != YUMIIDLENGTH) {
        [self showMessage];
    }
    self.channelIDTextField.text = @"";
    self.versionIDTextField.text = @"";
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    if (self.yumiIDTableView.hidden) {
        [self.yumiIDTableView reloadData];
        self.yumiIDTableView.hidden = NO;
    }

    return YES;
}
#pragma mark : - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.yumiIDsInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"YumiCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    YumiMediationInitializeModel *yumiModel = self.yumiIDsInfo[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = yumiModel.yumiID;

    return cell;
}

#pragma mark : - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YumiMediationInitializeModel *yumiModel = self.yumiIDsInfo[indexPath.row];

    self.yumiIDTextField.text = yumiModel.yumiID;
    self.channelIDTextField.text = yumiModel.channelID;
    self.versionIDTextField.text = yumiModel.versionID;

    self.yumiIDTableView.hidden = YES;
}

@end
