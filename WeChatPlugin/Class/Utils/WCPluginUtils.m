//
//  WCPluginUtils.m
//  WeChatPlugin
//
//  Created by wadahana on 12/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WeChatHeader.h"

// 强制调用 NewMainFrameViewController's reloadAll， 刷新 chat session tableview

void WCPluginReloadNewMainFrameController() {
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow || ![keyWindow isKindOfClass:NSClassFromString(@"iConsoleWindow")]) {
        return;
    }
    UITabBarController * rootController = (UITabBarController *)keyWindow.rootViewController;
    if (!rootController || ![rootController isKindOfClass:NSClassFromString(@"MMTabBarController")]) {
        return;
    }
    UINavigationController * naviController = rootController.viewControllers[0];
    if (!naviController || ![naviController isKindOfClass:NSClassFromString(@"MMUINavigationController")]) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIViewController * mainController = naviController.viewControllers[0];
    if (mainController && [mainController isKindOfClass:NSClassFromString(@"NewMainFrameViewController")]) {
        [mainController performSelector: @selector(reloadAll)];
    }
#pragma clang diagnostic pop
}

