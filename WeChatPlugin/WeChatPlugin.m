//
//  WeChatPlugin.m
//  WeChatPlugin
//
//  Created by wadahana on 22/12/2017.
//  Copyright © 2017 wadahana. All rights reserved.
//

#import "WeChatPlugin.h"
#import "WCPluginUIHijack.h"
#import "WCPluginContactHiddenHijack.h"
#import "WCPluginRedEnvelopHijack.h"
#import "WCPluginDataHelper.h"
#import "Cycript/Cycript.h"


@implementation WeChatPlugin

+ (void)hijack {
    WCPluginDataHelperInit();
    WCPluginUIHijackStart();
    WCPluginContactHiddenHijackStart();
    WCPluginRedEnvelopHijackStart();
}
+ (void)load {
    [self hijack];
    dispatch_async(dispatch_get_main_queue(), ^{
        CYListenServer(8899);
    });
}

@end
