//
//  NSBundle+WCPlugin.m
//  WeChatHelper
//
//  Created by wadahana on 08/06/2017.
//  Copyright © 2017 . All rights reserved.
//

#import "NSBundle+WCPlugin.h"
#import "WCPluginMethodSwizzling.h"

const static NSString * kFakeBundleIdentifier = @"com.tencent.xin";
@implementation NSBundle(Hooked)

- (NSDictionary<NSString *, id> *) hooked_infoDictionary {
    NSMutableDictionary<NSString *, id> * dict = [[self hooked_infoDictionary] mutableCopy];
    dict[(NSString *)kCFBundleIdentifierKey] = [kFakeBundleIdentifier copy];
    dict[(NSString *)kCFBundleNameKey] = @"WeChat";
    dict[@"CFBundleDisplayName"] = @"微信";
    return dict;
}

- (NSString *) hooked_bundleIdentifier {
    NSString * bundleID = [kFakeBundleIdentifier copy];
    return bundleID;
}

+ (void) hook {
    
    WCPluginExchangeInstanceMethod([NSBundle class],
                                   @selector(infoDictionary),
                                   @selector(hooked_infoDictionary));
    
    WCPluginExchangeInstanceMethod([NSBundle class],
                                   @selector(bundleIdentifier ),
                                   @selector(hooked_bundleIdentifier));
}

@end
