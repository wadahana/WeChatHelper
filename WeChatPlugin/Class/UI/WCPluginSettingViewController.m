//
//  WCPluginSettingViewController.m
//  IPAPatch
//
//  Created by wadahana on 23/07/2017.
//  Copyright © 2017 wadahana. All rights reserved.
//

#import "WCPluginSettingViewController.h"
#import "WCPluginAboutViewController.h"

static NSString * kTableViewCellIdentifier = @"WCPluginSettingTableViewCellIdentifier";

@interface WCPluginSettingViewController ()

@property (nonatomic, strong) UITableViewCell * aboutCell;
@property (nonatomic, strong) NSMutableArray * cellArray;
@property (nonatomic, strong) NSMutableArray * controllerArray;
@end

@implementation WCPluginSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kWeChatPluginSettingTitle;
    self.tableView.backgroundColor = UIColorMake(239,239,244);
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    
    self.cellArray = [NSMutableArray new];
    self.controllerArray = [NSMutableArray new];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self createTableViewCell];
}

- (void)createTableViewCell {

    self.aboutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCellIdentifier"];
    self.aboutCell.textLabel.text = @"关于";
    self.aboutCell.imageView.image = [UIImage imageNamed:@"MoreMyFavorites.png"];
    self.aboutCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.cellArray addObject:self.aboutCell];
    [self.controllerArray addObject:[WCPluginAboutViewController class]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    NSInteger row = indexPath.row;
    if (row < self.cellArray.count) {
        cell = self.cellArray[row];
    }
    cell.backgroundColor = UIColorMake(255, 255, 255);
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
/*
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [UIView new];
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [UIView new];
    return view;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIViewController * viewController = nil;
    NSInteger row = indexPath.row;
    if (row < self.controllerArray.count) {
        Class clazz = self.controllerArray[row];
        viewController = [[clazz alloc] init];
    }

    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }

    return;
}

@end
