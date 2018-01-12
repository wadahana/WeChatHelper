//
//  WCPluginHiddenViewController.m
//  WeChatPlugin
//
//  Created by wadahana on 05/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import "WCPluginHiddenViewController.h"
#import "WCPluginRightSwitchTableViewCell.h"
#import "WCPluginRightLabelTableViewCell.h"
#import "WCPluginContactSelectViewController.h"
#import "WCPluginMethodSwizzling.h"
#import "WCPluginDataHelper.h"
#import "WCPluginUtils.h"

#import "MBProgressHUDManager.h"
#import "SWTableViewCell.h"

#import <WeChatHeader.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

static NSString * const kHiddenSettingCellIdendtifer = @"HiddenSettingCellIdendtifer";
static NSString * const kHiddenSelectViewCellIdendtifer = @"HiddenSelectViewCellIdendtifer";
#define kSelectViewHeight  (kScreenHeight-86-40-44-49)

@interface WCPluginHiddenViewController ()    <UITableViewDelegate,
                                               UITableViewDataSource,
                                               UIAlertViewDelegate,
                                               WCPluginContactSelectViewControllerDelegate>

@property (nonatomic, strong) WCPluginRightSwitchTableViewCell * hiddenCell;
@property (nonatomic, strong) WCPluginRightLabelTableViewCell * passwdCell;
@property (nonatomic, strong) UITableViewCell * selectViewCell;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) ContactSelectView * selectView;
@property (nonatomic, strong) MBProgressHUDManager * hudManager;

@end


@implementation WCPluginHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = self.view.frame;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
    
    [self createTableViewCell];

    self.hudManager = [[MBProgressHUDManager alloc] initWithView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createTableViewCell {
    
    self.hiddenCell = [[WCPluginRightSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHiddenSettingCellIdendtifer];
    self.hiddenCell.selectionStyle = UITableViewCellSelectionStyleGray;
    self.hiddenCell.textLabel.text = @"隐藏联系人";
    [self.hiddenCell.rightSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
    self.hiddenCell.rightSwitch.on = WCPluginGetHiddenEnabled();
    
    self.passwdCell = [[WCPluginRightLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHiddenSettingCellIdendtifer];
    self.passwdCell.selectionStyle = UITableViewCellSelectionStyleGray;
    self.passwdCell.textLabel.text = @"关闭密码";
    self.passwdCell.rightLabel.text = WCPluginGetHiddenPasswd();
    self.passwdCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.selectViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: kHiddenSelectViewCellIdendtifer];
    self.selectViewCell.selectionStyle = UITableViewCellSelectionStyleGray;
    self.selectViewCell.textLabel.text = @"选择要隐藏的好友";
    self.selectViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSwitch:(UISwitch *)sender {
    if (sender.on) {
        NSString * passwd = WCPluginGetHiddenPasswd();
        if (!passwd || ![passwd isKindOfClass:[NSString class]] || [passwd length] <= 0) {
            sender.on = NO;
            [self.hudManager showMessage:@"请先设置密码!" duration:kToastDuration];
            return;
        }
        NSDictionary * dict = WCPluginGetHiddenUserList();
        if (!dict || ![dict isKindOfClass:[NSDictionary class]] || [dict count] <= 0) {
            sender.on = NO;
            [self.hudManager showMessage:@"请先设置要隐藏的好友!" duration:kToastDuration];
            return;
        }
    }
    WCPluginSetHiddenEnabled(sender.on);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 43;
    }
    return kSelectViewHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (row == 0) {
            cell = self.hiddenCell;
        } else if (row == 1) {
            cell = self.passwdCell;
        } else if (row == 2) {
            cell = self.selectViewCell;
        }
    }
    
    cell.backgroundColor = UIColorMake(255, 255, 255);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入关闭隐藏密码"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField * textField = [alert textFieldAtIndex:0];
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.placeholder = WCPluginGetHiddenPasswd();
        alert.tag = 100;
        [alert show];
    } else if (row == 2) {
        NSDictionary * list = WCPluginGetHiddenUserList();
        WCPluginContactSelectViewController * controller = [[WCPluginContactSelectViewController alloc] initWithType:kContactSelectTypeFriend userList:[list allKeys]];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - WCPluginContactSelectViewControllerDelegate

- (void) onSelectCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onSelectDone:(NSArray<NSString *>*)userLsit {
    NSMutableDictionary * dict = [NSMutableDictionary new];
    for (NSString * username in userLsit) {
        [dict setObject:username forKey:username];
    }
    WCPluginSetHiddenUserList(dict);
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) onShouldSelectContact: (CContact *)contact selectedList:(NSDictionary *)list {
    if ([list count] > kWeChatPluginMaxHiddenContact - 1) {
        NSString * msg = [NSString stringWithFormat:@"只能隐藏%d位好友", kWeChatPluginMaxHiddenContact];
        [_hudManager showMessage:msg duration:kToastDuration];
        return NO;
    }
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100 && buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString * text = textField.text;
        if (text && text.length > 0) {
            if (text.length <= 24) {
                WCPluginSetHiddenPasswd(text);
            } else {
                [self.hudManager showMessage:@"密码太长" duration:kToastDuration];
            }
        }
    }
}

@end


#pragma clang diagnostic pop
