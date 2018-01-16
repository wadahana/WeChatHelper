//
//  WCPluginLocationViewController.m
//  WeChatPlugin
//
//  Created by 吴昕 on 13/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import "WCPluginLocationViewController.h"
#import "WCPluginRightSwitchTableViewCell.h"
#import "WCPluginMapViewController.h"
#import "WCPluginDataHelper.h"

#import "MBProgressHUDManager.h"

#import <WeChatHeader.h>

static NSString * kLocationCellIdendtifer = @"kLocationCellIdendtifer";

@interface WCPluginLocationViewController ()

@property (nonatomic, strong) MMTableViewInfo * tableViewInfo;

@property (nonatomic, strong) MBProgressHUDManager * hudManager;

@end

@implementation WCPluginLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewInfo = [[NSClassFromString(@"MMTableViewInfo") alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
     MMTableView * tableView = [self.tableViewInfo getTableView];
    [self.view addSubview:tableView];
    
    [self createTableViewCell];
    
    self.hudManager = [[MBProgressHUDManager alloc] initWithView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createTableViewCell {
    
    MMTableViewSectionInfo * sectionInfo = [NSClassFromString(@"MMTableViewSectionInfo") sectionInfoDefaut];
    
    Class clazz = NSClassFromString(@"MMTableViewCellInfo");
    MMTableViewCellInfo * cell1 = [clazz switchCellForSel:@selector(onSwitchFakeLocation:) target:self title:@"虚拟定位开关" on:WCPluginGetFakeLocationEnabled()];
    MMTableViewCellInfo * cell2 = [clazz normalCellForSel:@selector(onMapkitController) target:self title:@"地图" accessoryType:1];
    
    [sectionInfo addCell:cell1];
    [sectionInfo addCell:cell2];
    
    [self.tableViewInfo addSection:sectionInfo];
}

- (void) onSwitchFakeLocation : (UISwitch *)sender {
    WCPluginSetFakeLocationEnabled(sender.on);
}

- (void) onMapkitController {
    WCPluginMapViewController * controller = [[WCPluginMapViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
