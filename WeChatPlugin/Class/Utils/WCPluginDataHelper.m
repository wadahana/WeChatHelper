//
//  WCPluginDataHelper.m
//  IPAPatch
//
//  Created by wadahana on 10/08/2017.
//  Copyright © 2017 . All rights reserved.
//

#import "WCPluginDataHelper.h"
#import "FMDB.h"
#import <objc/runtime.h>

static NSString * kDataBaseFileName = @"WCPluginDB.sqlite3";
static NSString * sDataBasePath = nil;
static FMDatabase * sDataBase = nil;
static NSDateFormatter* sDateFormatter = nil;

static void __WCPluginSettingInit();

static NSString * kWCPluginDataDirectory        = __kWCPluginDataDirectory;

static NSString * __WCPluginDataBaseFilePath();

static BOOL __WCPluginCreateAccountTable();

BOOL WCPluginDataHelperInit() {

    NSString * path = __WCPluginDataBaseFilePath();
    if (path) {
        if (!sDataBase) {
            sDataBase = [[FMDatabase alloc] initWithPath:path];
        }
        BOOL fRet = [sDataBase open];
        if (!fRet) {
            return NO;
        }
        sDateFormatter = [[NSDateFormatter alloc] init];
        [sDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        [sDataBase setDateFormat:sDateFormatter];
        
        if (!__WCPluginCreateAccountTable()) {
            goto fail;
        }
        __WCPluginSettingInit();
        return YES;
    }
    
fail:
    WCPluginDataHelperClose();
    return NO;
}

void WCPluginDataHelperClose() {
    if (sDataBase) {
        [sDataBase close];
        sDataBase = nil;
    }
    sDateFormatter = nil;
    return;
}

#pragma mark - 数据保持 初始化

static NSString * kWCPluginRedEnvelopEnabled    = __kWCPluginRedEnvelopEnabled;
static NSString * kWCPluginRedEnvelopDelay      = __kWCPluginRedEnvelopDelay;
static NSString * kWCPluginRedEnvelopOpenSelf   = __kWCPluginRedEnvelopOpenSelf;
static NSString * kWCPluginRedEnvelopSerial     = __kWCPluginRedEnvelopSerial;
static NSString * kWCPluginRedEnvelopBlackList  = __kWCPluginRedEnvelopBlackList;
static NSString * kWCPluginHiddenEnabled        = __kWCPluginHiddenEnabled;
static NSString * kWCPluginHiddenPasswd         = __kWCPluginHiddenPasswd;
static NSString * kWCPluginHiddenUserList       = __kWCPluginHiddenUserList;
static NSString * kWCPluginFakeLocationEnabled  = __kWCPluginFakeLocationEnabled;
static NSString * kWCPluginAddFriendSex         = __kWCPluginAddFriendSex;
static NSString * kWCPluginAddFriendOpt         = __kWCPluginAddFriendOpt;
static NSString * kWCPluginAddFriendInterval    = __kWCPluginAddFriendInterval;
static NSString * kWCPluginAddFriendMessage     = __kWCPluginAddFriendMessage;
static NSString * kWCPluginSettingRevokeEnabled = __kWCPluginSettingRevokeEnabled;

static BOOL sSettingRevokeEnabled;
static BOOL sRedEnvelopEnabled;
static BOOL sRedEnvelopOpenSelf;
static BOOL sRedEnvelopSerial;
static NSInteger sRedEnvelopDelay;
static NSArray<NSString *> * sRedEnvelopBlackList;

static BOOL sHiddenEnabled;
static NSString * sHiddenPasswd;
static NSDictionary * sHiddenUserList;

static BOOL sFakeLocationEnabled;

static NSInteger sAddFriendSex;
static NSInteger sAddFriendOpt;
static NSInteger sAddFriendInterval;
static NSArray * sAddFriendMessage;

static NSString * __WCPluginDataBaseFilePath() {
    
    if (sDataBasePath == nil) {
        NSError * error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * path = [docPath stringByAppendingPathComponent:kWCPluginDataDirectory];
        BOOL dir = NO;
        BOOL result = [fileManager fileExistsAtPath:path isDirectory:&dir];
        if (result) {
            if (!dir) {
                [fileManager removeItemAtPath:path error: &error];
            }
        }
        if (!error) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (error) {
            NSLog(@"create script direction %@ fail, %@\n", path, error);
            return nil;
        }
        sDataBasePath = [path stringByAppendingString:kDataBaseFileName];
    }
    
    return sDataBasePath;
}

static void __WCPluginSettingInit() {
    
    sSettingRevokeEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginSettingRevokeEnabled];
    
    sRedEnvelopEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginRedEnvelopEnabled];
    sRedEnvelopOpenSelf = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginRedEnvelopOpenSelf];
    sRedEnvelopSerial = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginRedEnvelopSerial];
   
    NSInteger delay = [[NSUserDefaults standardUserDefaults] integerForKey:kWCPluginRedEnvelopDelay];
    if (delay < 0 || delay > 30) {
        delay = 5;
    }
    sRedEnvelopDelay = delay;
    
    sRedEnvelopBlackList = [[NSUserDefaults standardUserDefaults] arrayForKey:kWCPluginRedEnvelopBlackList];
    
    sHiddenEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginHiddenEnabled];
    sHiddenPasswd = [[NSUserDefaults standardUserDefaults] objectForKey:kWCPluginHiddenPasswd];
    sHiddenUserList = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kWCPluginHiddenUserList];
    
    sFakeLocationEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginFakeLocationEnabled];
    
    NSInteger sex = [[NSUserDefaults standardUserDefaults] integerForKey:kWCPluginAddFriendSex];
    if (sex < 0 || sex > 2) {
        sex = 0;
    }
    sAddFriendSex = sex;
    
    NSInteger opt = [[NSUserDefaults standardUserDefaults] integerForKey:kWCPluginAddFriendOpt];
    if (opt < 0 || opt > 1) {
        opt = 0;
    }
    sAddFriendOpt = opt;
    
    NSInteger interval = [[NSUserDefaults standardUserDefaults] integerForKey:kWCPluginAddFriendInterval];
    if (interval < 15 || interval > 120) {
        interval = 50;
    }
    sAddFriendInterval = interval;
    
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:kWCPluginAddFriendMessage];
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        array = [NSArray new];
    }
}

#pragma mark - 是否防止撤回

BOOL WCPluginGetSettingRevokeEnabled() {
    return sSettingRevokeEnabled;
}

void WCPluginSetSettingRevokeEnabled(BOOL enabled) {
    sSettingRevokeEnabled = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginSettingRevokeEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 是否自动抢红包

BOOL WCPluginGetRedEnvelopEnabled() {
    return sRedEnvelopEnabled;
}

void WCPluginSetRedEnvelopEnabled(BOOL enabled) {
    sRedEnvelopEnabled = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginRedEnvelopEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 防止同时抢多个红包

BOOL WCPluginGetRedEnvelopSerial() {
    return sRedEnvelopSerial;
}

void WCPluginSetRedEnvelopSerial(BOOL enabled) {
    sRedEnvelopSerial = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginRedEnvelopSerial];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 是否抢自己红包

BOOL WCPluginGetRedEnvelopOpenSelf() {
    return sRedEnvelopOpenSelf;
}

void WCPluginSetRedEnvelopOpenSelf(BOOL enabled) {
    sRedEnvelopOpenSelf = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginRedEnvelopOpenSelf];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 自动抢红包延迟

NSInteger WCPluginGetRedEnvelopDelay() {
    return sRedEnvelopDelay;
}

void WCPluginSetRedEnvelopDelay(NSInteger delay) {
    if (delay < 0 || delay > 30) {
        delay = 2;
    }
    sRedEnvelopDelay = delay;
    [[NSUserDefaults standardUserDefaults] setInteger:delay forKey:kWCPluginRedEnvelopDelay];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 抢红包屏蔽群黑名单

NSArray<NSString *> * WCPluginGetRedEnvelopBlackList() {
    return sRedEnvelopBlackList;
}
void WCPluginSetRedEnvelopBlackList(NSArray<NSString *> * blackList) {
    if (blackList && [blackList isKindOfClass:[NSArray class]]) {
        sRedEnvelopBlackList = blackList;
        [[NSUserDefaults standardUserDefaults] setObject:blackList forKey:kWCPluginRedEnvelopBlackList];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

BOOL WCPluginIsInBackList(NSString * groupName) {
    return [sRedEnvelopBlackList containsObject:groupName];
}

#pragma mark - 自动登录账号管理

static BOOL __WCPluginCreateAccountTable() {
    
    if (sDataBase) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS AccountTable (\
        Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,\
        UserName       VARCHAR(128) NOT NULL UNIQUE,\
        Password       VARCHAR(512) NOT NULL)";
        if ([sDataBase executeUpdate:sql]) {
            NSLog(@"AccountTable 建表成功");
            return YES;
        }
    }
    NSLog(@"AccountTable 建表失败");
    return NO;
}

#pragma mark - 是否隐藏好友

BOOL WCPluginGetHiddenEnabled() {
    return sHiddenEnabled;
}

void WCPluginSetHiddenEnabled(BOOL enabled) {
    sHiddenEnabled = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginHiddenEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 隐藏好友开关密码

NSString * WCPluginGetHiddenPasswd() {
    if (sHiddenPasswd) {
        return sHiddenPasswd;
    }
    return @"";
}

void WCPluginSetHiddenPasswd(NSString * passwd) {
    sHiddenPasswd = passwd;
    [[NSUserDefaults standardUserDefaults] setObject:passwd forKey:kWCPluginHiddenPasswd];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 隐藏好友名单

NSDictionary * WCPluginGetHiddenUserList() {
    if (sHiddenUserList && [sHiddenUserList isKindOfClass:[NSDictionary class]]) {
        return sHiddenUserList;
    }
    return nil;
}

BOOL WCPluginSetHiddenUserList(NSDictionary * list) {
    if ([list count] > kWeChatPluginMaxHiddenContact) {
        return NO;
    }
    sHiddenUserList = list;
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:kWCPluginHiddenUserList];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 虚拟定位开关

BOOL WCPluginGetFakeLocationEnabled() {
    return sFakeLocationEnabled;
}

void WCPluginSetFakeLocationEnabled(BOOL enabled) {
    sFakeLocationEnabled = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginFakeLocationEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 暴力加人性别类型

NSInteger WCPluginGetAddFriendSex() {
    return sAddFriendSex;
}

void WCPluginSetAddFriendSex(NSInteger sex) {
    if (sex < 0 || sex > 2) {
        sex = 0;
    }
    sAddFriendSex = sex;
    [[NSUserDefaults standardUserDefaults] setInteger:sex forKey:kWCPluginAddFriendSex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 暴力加人的操作方式

NSInteger WCPluginGetAddFriendOpt() {
    return sAddFriendOpt;
}

void WCPluginSetAddFriendOpt(NSInteger opt) {
    if (opt < 0 || opt > 1) {
        opt = 0;
    }
    sAddFriendOpt = opt;
    [[NSUserDefaults standardUserDefaults] setInteger:opt forKey:kWCPluginAddFriendOpt];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 暴力加人间隔时间

NSInteger WCPluginGetAddFriendInterval() {
    return sAddFriendInterval;
}

void WCPluginSetAddFriendInterval(NSInteger interval) {
    if (interval < 15 || interval > 120) {
        interval = 50;
    }
    sAddFriendInterval = interval;
    [[NSUserDefaults standardUserDefaults] setInteger:interval forKey:kWCPluginAddFriendInterval];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 暴力加人打招呼消息

NSArray * WCPluginGetAddFriendMessage() {
    return sAddFriendMessage;
}

BOOL WCPluginSetAddFriendMessage(NSArray * array) {
    BOOL retval = NO;
    if (array && [array isKindOfClass:[NSArray class]]) {
        NSInteger count = [array count];
        if (count > 0 && count < 10) {
            sAddFriendMessage = array;
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:kWCPluginAddFriendMessage];
            retval = [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return retval;
}
