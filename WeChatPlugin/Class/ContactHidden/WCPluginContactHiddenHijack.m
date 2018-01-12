//
//  WCPluginContactHiddenHijack.m
//  WeChatPlugin
//
//  Created by wadahana on 12/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCPluginContactHiddenHijack.h"
#import "WCPluginMethodSwizzling.h"
#import "WCPluginSettingViewController.h"
#import "WCPluginDataHelper.h"
#import "WCPluginUtils.h"
#import "MBProgressHUDManager.h"
#import "WeChatHeader.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

static __strong MBProgressHUDManager * __hudManager = nil;

static void __NewMainFrameViewController_MMVoiceSearchBar_textDidChange(id this, SEL cmd, id bar, NSString * text);

static id __CContactMgr_getContactList_contactType_needLoadExt(id this, SEL cmd, NSUInteger arg1, NSUInteger type, BOOL needLoadExt);

static unsigned int __MMNewSessionMgr_GetSessionCount(id this, SEL cmd);

static id __MMNewSessionMgr_GetSessionAtIndex(id this, SEL cmd, unsigned int index);

static id __MMNewSessionMgr_GetSessionInfoList(id this, SEL cmd);

static id __LocalSearch_50b1b628d316c80912deec312b8e6864(id this, SEL cmd, id arg1, id arg2, id arg3, id arg4, id arg5, id arg6);

void WCPluginContactHiddenHijackStart() {
    WCPluginReplaceInstanceMethod(@"NewMainFrameViewController",
                                  @"MMVoiceSearchBar:textDidChange:",
                                  (IMP)__NewMainFrameViewController_MMVoiceSearchBar_textDidChange,
                                  nil);
    
    // 屏蔽通讯录
    WCPluginReplaceInstanceMethod(@"CContactMgr",
                                  @"getContactList:contactType:needLoadExt:",
                                  (IMP)__CContactMgr_getContactList_contactType_needLoadExt,
                                  @"@28@0:8I16I20B24");
    // 屏蔽对话
    WCPluginReplaceInstanceMethod(@"MMNewSessionMgr",
                                  @"GetSessionCount",
                                  (IMP)__MMNewSessionMgr_GetSessionCount,
                                  nil);
    
    WCPluginReplaceInstanceMethod(@"MMNewSessionMgr",
                                  @"GetSessionAtIndex:",
                                  (IMP)__MMNewSessionMgr_GetSessionAtIndex,
                                  nil);
    
    WCPluginReplaceInstanceMethod(@"MMNewSessionMgr",
                                  @"GetSessionInfoList",
                                  (IMP)__MMNewSessionMgr_GetSessionInfoList,
                                  nil);
    // 屏蔽对话搜索
    WCPluginReplaceClassMethod(@"LocalSearch",
                               @"searchFromContacts:allContact:dicAddressBook:dicCheckList:dicMatchTip:helpDataItem:",
                               (IMP)__LocalSearch_50b1b628d316c80912deec312b8e6864,
                               nil);
}

static void __NewMainFrameViewController_MMVoiceSearchBar_textDidChange(id this, SEL cmd, id bar, NSString * text) {
    if (WCPluginGetHiddenEnabled()) {
        NSString * passwd = WCPluginGetHiddenPasswd();
        if ([text isEqualToString:passwd]) {
            WCPluginSetHiddenEnabled(NO);
            if (!__hudManager) {
                UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
                __hudManager = [[MBProgressHUDManager alloc] initWithView:keyWindow];
            }
            [__hudManager showMessage:@"好友隐藏功能关闭" duration:kToastDuration];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWCPluginSettingViewControllerRefreshNotification object:nil];
        }
    }
    [this performSelector:@selector(ORIGMMVoiceSearchBar:textDidChange:) withObject:bar withObject:text];
}

#pragma mark - 隐藏通讯录

typedef id (*fn_CContactMgr_getContactList_contactType_needLoadExt)(id this, SEL cmd, NSUInteger arg1, NSUInteger type, BOOL needLoadExt);

static id __CContactMgr_getContactList_contactType_needLoadExt(id this, SEL cmd, NSUInteger arg1, NSUInteger type, BOOL needLoadExt) {
    
    SEL selector = @selector(ORIGgetContactList:contactType:needLoadExt:);
    id retVal = nil;
    
    fn_CContactMgr_getContactList_contactType_needLoadExt imp_getContactList = (fn_CContactMgr_getContactList_contactType_needLoadExt)class_getMethodImplementation(NSClassFromString(@"CContactMgr"), selector);
    assert(imp_getContactList != nil);
    retVal = imp_getContactList(this, cmd, arg1, type, needLoadExt);
    if (retVal && WCPluginGetHiddenEnabled()){
        NSDictionary * hiddenUserList = WCPluginGetHiddenUserList();
        if (hiddenUserList && [hiddenUserList count] > 0) {
            NSMutableArray * newArray = [NSMutableArray new];
            for(id contact in retVal) {
                NSString * userName = [contact valueForKey:@"m_nsUsrName"];
                if ([hiddenUserList objectForKey:userName] == nil) {
                    [newArray addObject:contact];
                }
            }
            return newArray;
        }
    }
    return retVal;
}

#pragma mark - 隐藏回话

static unsigned int __MMNewSessionMgr_GetSessionCount(id this, SEL cmd) {
    NSLog(@"GetSessionCount ->");
    NSMutableArray * array = [this valueForKey:@"m_arrSession"];
    if (array) {
        NSDictionary * hiddenUserList = WCPluginGetHiddenUserList();
        if (WCPluginGetHiddenEnabled() && hiddenUserList && [hiddenUserList count] > 0) {
            NSUInteger count = 0;
            for(id info in array) {
                NSString * userName = [info valueForKey:@"m_nsUserName"];
                if ([hiddenUserList objectForKey:userName] == nil) {
                    count += 1;
                }
            }
            return (unsigned int)count;
        }
        return (unsigned int)[array count];
    }
    return 0;
}

typedef id (*fn_MMNewSessionMgr_GetSessionAtIndex)(id this, SEL cmd, unsigned int index);

static id __MMNewSessionMgr_GetSessionAtIndex(id this, SEL cmd, unsigned int index) {
    NSLog(@"GetSessionAtIndex:%u ->", index);
    unsigned int new_index = index;
    Class clazz = NSClassFromString(@"MMNewSessionMgr");
    SEL selector = @selector(ORIGGetSessionAtIndex:);
    fn_MMNewSessionMgr_GetSessionAtIndex imp_getSessionAtIndex = (fn_MMNewSessionMgr_GetSessionAtIndex)class_getMethodImplementation(clazz, selector);
    if (WCPluginGetHiddenEnabled()) {
        NSArray * array = [this performSelector:@selector(ORIGGetSessionInfoList) withObject:nil];
        NSDictionary * hiddenUserList = WCPluginGetHiddenUserList();
        if (array && hiddenUserList && [hiddenUserList count] > 0) {
            int count = (int)[array count];
            for (unsigned int i = 0; i <= new_index && i < count; i++) {
                id info = [array objectAtIndex:i];
                NSString * userName = [info valueForKey:@"m_nsUserName"];
                if ([hiddenUserList objectForKey:userName] != nil) {
                    new_index += 1;
                }
            }
        }
    }
    id session = imp_getSessionAtIndex(this, cmd, new_index);
    return session;
}

static id __MMNewSessionMgr_GetSessionInfoList(id this, SEL cmd) {
    id list = [this performSelector:@selector(ORIGGetSessionInfoList) withObject:nil];
    if (list && WCPluginGetHiddenEnabled()) {
        NSDictionary * hiddenUserList = WCPluginGetHiddenUserList();
        if (hiddenUserList && [hiddenUserList count] > 0) {
            NSMutableArray * array = [NSMutableArray new];
            for (id info in list) {
                NSString * userName = [info valueForKey:@"m_nsUserName"];
                if ([hiddenUserList objectForKey:userName] == nil) {
                    [array addObject:info];
                }
            }
            return [NSArray arrayWithArray:array];
        }
    }
    return list;
}

#pragma mark - 隐藏搜索栏

/*
 [LocalSearch searchFromContacts:allContact:dicAddressBook:dicCheckList:dicMatchTip:helpDataItem:]
 this method's name is too loooooong.
 * */
typedef id (*fn_LocalSearch_50b1b628d316c80912deec312b8e6864)(id this, SEL cmd, id arg1, id arg2, id arg3, id arg4, id arg5, id arg6);

static id __LocalSearch_50b1b628d316c80912deec312b8e6864(id this, SEL cmd, id arg1, id arg2, id arg3, id arg4, id arg5, id arg6) {
    Class metaClazz = objc_getMetaClass("LocalSearch");
    SEL selector = @selector(ORIGsearchFromContacts:allContact:dicAddressBook:dicCheckList:dicMatchTip:helpDataItem:);
    fn_LocalSearch_50b1b628d316c80912deec312b8e6864 imp_LocalSearch_50b1b628d316c80912deec312b8e6864 = (fn_LocalSearch_50b1b628d316c80912deec312b8e6864)class_getMethodImplementation(metaClazz, selector);
    id list = imp_LocalSearch_50b1b628d316c80912deec312b8e6864(this, cmd, arg1, arg2, arg3, arg4, arg5, arg6);
    if (list && [list count] > 0 && WCPluginGetHiddenEnabled()) {
        NSDictionary * hiddenUserList = WCPluginGetHiddenUserList();
        if (hiddenUserList && [hiddenUserList count] > 0) {
            NSMutableArray * array = [NSMutableArray new];
            for (id info in list) {
                NSString * userName = [info valueForKey:@"m_nsUsrName"];
                if ([hiddenUserList objectForKey:userName] == nil) {
                    [array addObject:info];
                }
            }
            return array;
        }
    }
    return list;
}

#pragma clang diagnostic pop
