//
//  WCPluginRedEnvelopViewController.m
//  IPAPatch
//
//  Created by 吴昕 on 27/07/2017.
//  Copyright © 2017 Weibo. All rights reserved.
//

#import "WCPluginRedEnvelopViewController.h"
#import "WCPluginRightSwitchTableViewCell.h"
#import "WCPluginRightLabelTableViewCell.h"
#import "WCPluginContactSelectViewController.h"

#import "WCPluginDataHelper.h"

#import "MBProgressHUDManager.h"

static NSString * const kRedEnvelopSettingCellIdendtifer = @"kRedEnvelopSettingCellIdendtifer";

@interface WCPluginRedEnvelopViewController () <UITableViewDelegate,
                                                UITableViewDataSource,
                                                WCPluginContactSelectViewControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) WCPluginRightSwitchTableViewCell * startCell;
@property (nonatomic, strong) WCPluginRightSwitchTableViewCell * selfCell;
@property (nonatomic, strong) WCPluginRightSwitchTableViewCell * serialCell;
@property (nonatomic, strong) WCPluginRightLabelTableViewCell * timeCell;
@property (nonatomic, strong) UITableViewCell * selectViewCell;
@property (nonatomic, strong) MBProgressHUDManager *hudManager;
@end

@implementation WCPluginRedEnvelopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self createTableViewCells];
    self.hudManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    
    [self.view addSubview:self.tableView];
}

- (void) createTableViewCells {
    
    self.startCell = [[WCPluginRightSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRedEnvelopSettingCellIdendtifer];
    self.startCell.selectionStyle = UITableViewCellSelectionStyleGray;
    self.startCell.textLabel.text = @"自动抢红包";
    [self.startCell.rightSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
    self.startCell.rightSwitch.on = WCPluginGetRedEnvelopEnabled();
 
    self.timeCell = [[WCPluginRightLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRedEnvelopSettingCellIdendtifer];
    self.timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.timeCell.textLabel.text = @"延迟抢红包";
    self.timeCell.rightLabel.text = [NSString stringWithFormat:@"%ld", (long)WCPluginGetRedEnvelopDelay()];
    self.timeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.selfCell = [[WCPluginRightSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRedEnvelopSettingCellIdendtifer];
    self.selfCell.selectionStyle = UITableViewCellSelectionStyleGray;
    self.selfCell.textLabel.text = @"抢自己的红包";
    [self.selfCell.rightSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
    self.selfCell.rightSwitch.on = WCPluginGetRedEnvelopOpenSelf();
    
    self.serialCell = [[WCPluginRightSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRedEnvelopSettingCellIdendtifer];
    self.serialCell.selectionStyle = UITableViewCellSelectionStyleGray;
    self.serialCell.textLabel.text = @"防止同时抢多个红包";
    [self.serialCell.rightSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
    self.serialCell.rightSwitch.on = WCPluginGetRedEnvelopSerial();
    
    self.selectViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: kRedEnvelopSettingCellIdendtifer];
    self.selectViewCell.selectionStyle = UITableViewCellSelectionStyleGray;
    self.selectViewCell.textLabel.text = @"选择要屏蔽的群";
    self.selectViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSwitch:(UISwitch *)sender {
    if (sender == self.startCell.rightSwitch) {
        WCPluginSetRedEnvelopEnabled(self.startCell.rightSwitch.on);
    } else if (sender == self.selfCell.rightSwitch) {
        WCPluginSetRedEnvelopOpenSelf(self.selfCell.rightSwitch.on);
    } else if (sender == self.serialCell.rightSwitch) {
        WCPluginSetRedEnvelopSerial(self.serialCell.rightSwitch.on);
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
            cell = self.startCell;
        } else if (row == 1) {
            cell = self.timeCell;
        } else if (row == 2) {
            cell = self.selfCell;
        } else if (row == 3) {
            cell = self.serialCell;
        } else if (row == 4) {
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if (section == 0) {
        if (row == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入抢红包延迟"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField * textField = [alert textFieldAtIndex:0];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = self.timeCell.rightLabel.text;
            alert.tag = 100;
            [alert show];
        } else if (row == 4) {
            NSArray<NSString *> * list = WCPluginGetRedEnvelopBlackList();
            WCPluginContactSelectViewController * controller = [[WCPluginContactSelectViewController alloc] initWithType:kContactSelectTypeGroup userList:list];
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100 && buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        int value = [textField.text intValue];
        if (value >= 0 && value <= 30) {
             WCPluginSetRedEnvelopDelay(value);
            self.timeCell.rightLabel.text = textField.text;
            [self.timeCell setNeedsLayout];
        } else {
            [self.hudManager showMessage:@"输入范围[0,30]" duration:kToastDuration];
        }
    }
}

#pragma mark - WCPluginContactSelectViewControllerDelegate

- (void) onSelectCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onSelectDone:(NSArray<NSString *>*)userLsit {
    [self.navigationController popViewControllerAnimated:YES];
    WCPluginSetRedEnvelopBlackList(userLsit);
}

- (BOOL) onShouldSelectContact: (CContact *)contact selectedList:(NSDictionary *)list {
    return YES;
}

@end
