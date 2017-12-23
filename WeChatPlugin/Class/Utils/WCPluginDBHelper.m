//
//  WCPluginDBHelper.m
//  WeChatPlugin
//
//  Created by 吴昕 on 23/12/2017.
//  Copyright © 2017 wadahana. All rights reserved.
//

#import "WCPluginDBHelper.h"
#import "FMDB.h"

@interface WCPluginDBHelper ()

@property (nonatomic, copy) NSString * dataBasePath;
@property (nonatomic, strong) FMDatabase * dataBase;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;
@end


static NSString * kWCPluginRedEnvelopEnabled    = @"kWCPluginRedEnvelopEnabled";
static NSString * kWCPluginRedEnvelopDelay      = @"kWCPluginRedEnvelopDelay";
static NSString * kWCPluginRedEnvelopOpenSelf   = @"kWCPluginRedEnvelopOpenSelf";
static NSString * kWCPluginRedEnvelopSerial     = @"kWCPluginRedEnvelopSerial";
static NSString * kWCPluginRevokeEnabled        = @"kWCPluginRevokeEnabled";


@implementation WCPluginDBHelper {
    BOOL _revokeEnabled;
    BOOL _redEnvelopEnabled;
    BOOL _redEnvelopOpenSelf;
    BOOL _redEnvelopSerial;
    NSInteger _redEnvelopDelay;
}

+ (instancetype) shareInstance {
    static WCPluginDBHelper * sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCPluginDBHelper alloc] init];
    });
    return sInstance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _revokeEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginRevokeEnabled];
        _redEnvelopEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginRedEnvelopEnabled];
        _redEnvelopOpenSelf = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginRedEnvelopOpenSelf];
        _redEnvelopSerial = [[NSUserDefaults standardUserDefaults] boolForKey:kWCPluginRedEnvelopSerial];
        NSInteger delay = [[NSUserDefaults standardUserDefaults] integerForKey:kWCPluginRedEnvelopDelay];
        _redEnvelopDelay = (delay < 0 || delay > 60) ? 1 : delay;
    }
    return self;
}

#pragma mark - 是否防止撤回

- (BOOL) getRevokeEnabled {
    return _revokeEnabled;
}

- (void) setRevokeEnabled : (BOOL) enabled {
    _revokeEnabled = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginRevokeEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 是否自动抢红包

- (BOOL) getRedEnvelopEnabled {
    return _redEnvelopEnabled;
}

- (void) setRedEnvelopEnabled : (BOOL) enabled {
    _redEnvelopEnabled = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginRedEnvelopEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 防止同时抢多个红包

- (BOOL) getRedEnvelopSerial {
    return _redEnvelopSerial;
}

- (void) setRedEnvelopSerial : (BOOL) enabled {
    _redEnvelopSerial = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginRedEnvelopSerial];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 是否抢自己红包

- (BOOL) getRedEnvelopOpenSelf {
    return _redEnvelopOpenSelf;
}

- (void) setRedEnvelopOpenSelf : (BOOL) enabled {
    _redEnvelopOpenSelf = enabled;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kWCPluginRedEnvelopOpenSelf];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 自动抢红包延迟

- (NSInteger) getRedEnvelopDelay {
    return _redEnvelopDelay;
}

- (void) setRedEnvelopDelay: (NSInteger) delay {
    if (delay < 0 || delay > 30) {
        delay = 2;
    }
    _redEnvelopDelay = delay;
    [[NSUserDefaults standardUserDefaults] setInteger:delay forKey:kWCPluginRedEnvelopDelay];
    [[NSUserDefaults standardUserDefaults] synchronize];
}





@end
