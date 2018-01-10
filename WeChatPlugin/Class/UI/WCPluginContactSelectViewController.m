//
//  WCPluginContactSelectViewController.m
//  WeChatPlugin
//
//  Created by wadahana on 08/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import <WeChatHeader.h>

#import "WCPluginContactSelectViewController.h"
#import "WCPluginRightSwitchTableViewCell.h"
#import "WCPluginRightLabelTableViewCell.h"

#import "WCPluginMethodSwizzling.h"
#import "MBProgressHUDManager.h"
#import "SWTableViewCell.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@interface WCPluginContactSelectViewController()   <ContactSelectViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray<NSString *> * userList;
@property (nonatomic, strong) ContactSelectView * selectView;
@property (nonatomic, strong) MBProgressHUDManager * hudManager;
@property (nonatomic, assign) ContactSelectType selectType;
@end

@implementation WCPluginContactSelectViewController {
    
}

- (instancetype) initWithType:(ContactSelectType)type userList:(NSArray<NSString *> *)userList {
    self = [super init];
    if (self) {
        self.userList = userList;
        self.selectType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavigation];
    [self initSelectView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MMServiceCenter * serviceCenter = [NSClassFromString(@"MMServiceCenter") defaultCenter];
    id contactMgr = [serviceCenter getService:NSClassFromString(@"CContactMgr")];
    
    for (NSString * name in self.userList) {
        id contact = [contactMgr performSelector:@selector(getContactByName:) withObject:name];
        [self.selectView performSelector:@selector(addSelect:) withObject:contact];
    }
}

- (void)initNavigation {
    self.navigationItem.leftBarButtonItem = [objc_getClass("MMUICommonUtil") getBarButtonWithTitle:@"取消" target:self action:@selector(onCancel:) style:0];
    self.navigationItem.rightBarButtonItem = [self rightBarButtonWithSelectCount:self.userList.count];
    
    self.title = @"黑名单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]}];
}

- (UIBarButtonItem *)rightBarButtonWithSelectCount:(unsigned long)selectCount {
    Class clazz = NSClassFromString(@"MMUICommonUtil");
    UIBarButtonItem *barButtonItem = nil;
    if (selectCount == 0) {
        barButtonItem = [clazz getBarButtonWithTitle:@"确定" target:self action:@selector(onDone:) style:2];
    } else {
        NSString *title = [NSString stringWithFormat:@"确定(%lu)", selectCount];
        barButtonItem = [objc_getClass("MMUICommonUtil") getBarButtonWithTitle:title target:self action:@selector(onDone:) style:4];
    }
    return barButtonItem;
}

- (void)initSelectView {
    CGRect rc = [UIScreen mainScreen].bounds;
    self.selectView =  [[objc_getClass("ContactSelectView") alloc] initWithFrame:rc delegate:self];
    self.selectView.m_bMultiSelect = YES;
    if (self.selectType == kContactSelectTypeGroup) {
        self.selectView.m_uiGroupScene = 5;
        [self.selectView initData:5];
    } else if (self.selectType == kContactSelectTypeFriend) {
        self.selectView.m_uiGroupScene = 13;
        [self.selectView initData:2];
    }

    [self.selectView initView];
    
    [self.view addSubview:self.selectView];
}

- (void)onCancel:(UIBarButtonItem *)item {
    NSLog(@"onCancel");
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectCancel)]) {
        [self.delegate onSelectCancel];
    }
}

- (void)onDone:(UIBarButtonItem *)item {

    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectDone:)]) {
        NSMutableArray<NSString *> * list = [NSMutableArray new];
        NSDictionary * dict = (NSDictionary *)[self.selectView valueForKey:@"m_dicMultiSelect"];
        for (NSString * usrname in [dict allKeys]) {
            [list addObject:usrname];
        }
        [self.delegate onSelectDone:list];
    }
}

#pragma mark - ContactSelectViewDelegate
- (void) onSelectContact:(CContact *)contact {
    NSDictionary * dict = (NSDictionary *)[self.selectView valueForKey:@"m_dicMultiSelect"];
    self.navigationItem.rightBarButtonItem = [self rightBarButtonWithSelectCount:(long)[dict count]];
}

- (BOOL)onShouldSelectContact:(CContact *)contact {
    NSDictionary * dict = (NSDictionary *)[self.selectView valueForKey:@"m_dicMultiSelect"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectoronShouldSelectContact:selectedList:)]) {
        [self.delegate onShouldSelectContact:contact selectedList:dict];
    }
    
    if ([dict count] > kWeChatPluginMaxHiddenContact - 1) {
        NSString * msg = [NSString stringWithFormat:@"只能隐藏%d位好友", kWeChatPluginMaxHiddenContact];
        [_hudManager showMessage:msg duration:kToastDuration];
        return NO;
    }
    return YES;
}

@end

#pragma clang diagnostic pop
