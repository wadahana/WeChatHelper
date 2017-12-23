//
//  WCPluginUIHijack.h
//  WeChatPlugin
//
//  Created by wadahana on 22/12/2017.
//  Copyright © 2017 wadahana. All rights reserved.
//

#import "WCPluginUIHijack.h"
#import "WCPluginMethodSwizzling.h"
#import "WCPluginSettingViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

static __strong UITableViewCell * __sWCPluginSettingCell = nil;

static void __moreViewController_onShowPluginSetting(id this, SEL cmd);

static void __moreViewController_addFunctionSection(id this, SEL cmd);

void WCPluginUIHijackStart() {
    
    WCPluginReplaceInstanceMethod(@"MoreViewController",
                                  @"onShowPluginSetting",
                                  (IMP)__moreViewController_onShowPluginSetting,
                                  @"v16@0:8");
    
    WCPluginReplaceInstanceMethod(@"MoreViewController",
                                  @"addFunctionSection",
                                  (IMP)__moreViewController_addFunctionSection,
                                  @"v16@0:8");
}


static void __moreViewController_onShowPluginSetting(id this, SEL cmd) {
    NSLog(@"onShowPluginSetting -> ");
    
    if ([this isKindOfClass:[UIViewController class]]) {
        UIViewController * moreViewController = (UIViewController *)this;
        WCPluginSettingViewController * controller = [[WCPluginSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [moreViewController.navigationController pushViewController: controller animated:YES];
    }
}

static void __moreViewController_addFunctionSection(id this, SEL cmd) {
    
    [this performSelector:@selector(ORIGaddFunctionSection) withObject:nil];
    id info = [this valueForKey:@"m_tableViewInfo"];
    NSMutableArray * sectionArray = [info valueForKey:@"_arrSections"];
    
    
    Class clazz = NSClassFromString(@"MMTableViewCellInfo");
    SEL selector = NSSelectorFromString(@"normalCellForSel:target:title:rightValue:imageName:accessoryType:isFitIpadClassic:");
    NSMethodSignature * signature = [clazz methodSignatureForSelector:selector];
    
    SEL onSettingSelector = NSSelectorFromString(@"onShowPluginSetting");
    NSString * title = kWeChatPluginSettingTitle;
    id rightValue = nil;
    NSString * imageName = @"MoreMyFavorites.png";
    NSInteger accessoryType = 1;
    BOOL isFitIpad = YES;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = clazz;
    invocation.selector = selector;
    [invocation setArgument:&onSettingSelector atIndex:2];
    [invocation setArgument:&this atIndex:3];
    [invocation setArgument:&title atIndex:4];
    [invocation setArgument:&rightValue atIndex:5];
    [invocation setArgument:&imageName atIndex:6];
    [invocation setArgument:&accessoryType atIndex:7];
    [invocation setArgument:&isFitIpad atIndex:8];
    [invocation invoke];
    [invocation getReturnValue:&__sWCPluginSettingCell];
    
    if (__sWCPluginSettingCell) {
        [sectionArray[1] performSelector:@selector(addCell:) withObject:__sWCPluginSettingCell];
    }
    return;
}

#pragma clang diagnostic pop
