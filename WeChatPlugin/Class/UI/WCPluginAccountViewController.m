//
//  WCPluginAccountViewController.m
//  IPAPatch
//
//  Created by wadahana on 10/08/2017.
//  Copyright © 2017 wadahana. All rights reserved.
//

#import "WCPluginAccountViewController.h"
#import "MBProgressHUDManager.h"
#import "SWTableViewCell.h"

static NSString * const kAccountCellIdendtifer = @"AccountCellIdendtifer";

@interface WCPluginAccountViewController ()    <UITableViewDelegate,
                                                UITableViewDataSource,
                                                UIAlertViewDelegate,
                                                SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * accountArray;
@property (nonatomic, strong) MBProgressHUDManager * hudManager;

@end

@implementation WCPluginAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    
    self.accountArray = [NSMutableArray new];
    [self.accountArray addObject:@"wadahana"];
    [self.accountArray addObject:@"wadahana2"];
    [self.accountArray addObject:@"wadahana3"];
    
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(onRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    rightButton.imageInsets = UIEdgeInsetsMake(0, 20, 0, -20);
    self.hudManager = [[MBProgressHUDManager alloc] initWithView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRightButton: (UIBarButtonItem *) button {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加账号"
                                                    message:@"输入微信账号和密码"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    UITextField * passwdField = [alert textFieldAtIndex:1];
    passwdField.secureTextEntry = YES;
    alert.tag = 100;
    [alert show];
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
    return self.accountArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
   
    SWTableViewCell * swCell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kAccountCellIdendtifer];
    if (!swCell) {
        swCell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kAccountCellIdendtifer];
        NSMutableArray* rightButtons = [NSMutableArray new];
        [rightButtons sw_addUtilityButtonWithColor:UIColorMake(0xFE, 0x54, 0x43) title:@"删除"];
        [swCell setRightUtilityButtons:rightButtons];
        swCell.delegate = self;
    }
    cell = swCell;
    cell.textLabel.text = self.accountArray[row];


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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改账号"
                                                    message:@"输入微信账号和密码"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    UITextField * userField = [alert textFieldAtIndex:0];
    UITextField * passwdField = [alert textFieldAtIndex:1];
    passwdField.secureTextEntry = YES;
    userField.placeholder = self.accountArray[row];
    passwdField.placeholder = @"123456";
    alert.tag = 101;
    [alert show];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100 && buttonIndex == 1) {
        NSString * userName = [alertView textFieldAtIndex:0].text;
        NSString *passwd = [alertView textFieldAtIndex:1].text;
        NSLog(@"%@:%@", userName, passwd);
        if (userName && passwd && userName.length > 0 && passwd.length > 0) {
            [self.accountArray addObject:userName];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    } else if (alertView.tag == 101 && buttonIndex == 1) {
        NSString * userName = [alertView textFieldAtIndex:0].text;
        NSString *passwd = [alertView textFieldAtIndex:1].text;
        NSLog(@"%@:%@", userName, passwd);
        if (userName && passwd && userName.length > 0 && passwd.length > 0) {
            //[self.accountArray addObject:userName];
        }
    }
}

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    return;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
//    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (row < self.accountArray.count) {
        [self.accountArray removeObjectAtIndex:row];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
