//
//  WCPluginDataHelper.h
//  IPAPatch
//
//  Created by wadahana on 10/08/2017.
//  Copyright © 2017 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#pragma mark - SQLite3数据库操作

BOOL WCPluginDataHelperInit();
void WCPluginDataHelperClose();

#pragma mark - 是否防止撤回

BOOL WCPluginGetSettingRevokeEnabled();
void WCPluginSetSettingRevokeEnabled(BOOL enabled);

#pragma mark - 是否自动抢红包

BOOL WCPluginGetRedEnvelopEnabled();
void WCPluginSetRedEnvelopEnabled(BOOL enabled);

#pragma mark - 是否抢自己红包

BOOL WCPluginGetRedEnvelopOpenSelf();
void WCPluginSetRedEnvelopOpenSelf(BOOL enabled);

#pragma mark - 防止同时抢多个红包

BOOL WCPluginGetRedEnvelopSerial();
void WCPluginSetRedEnvelopSerial(BOOL enabled);

#pragma mark - 自动抢红包延迟

NSInteger WCPluginGetRedEnvelopDelay();
void WCPluginSetRedEnvelopDelay(NSInteger delay);

#pragma mark - 抢红包屏蔽群黑名单

NSArray<NSString *> * WCPluginGetRedEnvelopBlackList();
void WCPluginSetRedEnvelopBlackList(NSArray<NSString *> * blackList);
BOOL WCPluginIsInBackList(NSString * groupName);

#pragma mark - 是否隐藏好友

BOOL WCPluginGetHiddenEnabled();
void WCPluginSetHiddenEnabled(BOOL enabled);

#pragma mark - 隐藏好友开关密码

NSString * WCPluginGetHiddenPasswd();
void WCPluginSetHiddenPasswd(NSString * passwd);

#pragma mark - 隐藏好友名单

NSDictionary * WCPluginGetHiddenUserList();
BOOL WCPluginSetHiddenUserList(NSDictionary * list);

#pragma mark - 虚拟定位开关

BOOL WCPluginGetFakeLocationEnabled();
void WCPluginSetFakeLocationEnabled(BOOL enabled);

#pragma mark - 虚拟定位位置
//CLLocationCoordinate2D WCPluginGetFakeLocationCurrentCoordinate();
//void WCPluginGet

#pragma mark - 暴力加人性别类型

NSInteger WCPluginGetAddFriendSex();
void WCPluginSetAddFriendSex(NSInteger sex);
#pragma mark - 暴力加人的操作方式

NSInteger WCPluginGetAddFriendOpt();
void WCPluginSetAddFriendOpt(NSInteger opt);

#pragma mark - 暴力加人间隔时间

NSInteger WCPluginGetAddFriendInterval();
void WCPluginSetAddFriendInterval(NSInteger interval);

#pragma mark - 暴力加人打招呼消息

NSArray * WCPluginGetAddFriendMessage();
BOOL WCPluginSetAddFriendMessage(NSArray * array);
