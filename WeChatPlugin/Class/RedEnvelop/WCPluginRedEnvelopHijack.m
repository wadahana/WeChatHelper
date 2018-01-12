//
//  WCPluginRedEnvelopHijack.m
//  WeChatPlugin
//
//  Created by wadahana on 12/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCPluginRedEnvelopHelper.h"
#import "WCPluginRedEnvelopHijack.h"
#import "WCPluginMethodSwizzling.h"
#import "WCPluginDataHelper.h"
#import "WCPluginUtils.h"
#import "WeChatHeader.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

static void __CMessageMgr_AsyncOnAddMsg_MsgWrap(id this, SEL cmd, id msg, id wrap);

static void __WCRedEnvelopesLogicMgr_OnWCToHongbaoCommonResponse_Request(id this, SEL cmd, id resp, id req);

void WCPluginRedEnvelopHijackStart() {
    
    WCPluginReplaceInstanceMethod(@"CMessageMgr",
                                  @"AsyncOnAddMsg:MsgWrap:",
                                  (IMP)__CMessageMgr_AsyncOnAddMsg_MsgWrap,
                                  @"v32@0:8@16@24");
    
    WCPluginReplaceInstanceMethod(@"WCRedEnvelopesLogicMgr",
                                  @"OnWCToHongbaoCommonResponse:Request:",
                                  (IMP)__WCRedEnvelopesLogicMgr_OnWCToHongbaoCommonResponse_Request,
                                  @"v32@0:8@16@24");
}

static void __CMessageMgr_AsyncOnAddMsg_MsgWrap(id this, SEL cmd, id msg, id wrap) {
    NSLog(@"hook [CMessageMgr AsyncOnAddMsg:MsgWrap:]");
    [this performSelector:@selector(ORIGAsyncOnAddMsg:MsgWrap:) withObject:msg withObject:wrap];
    int messageType = WCPluginIntGetter(wrap, @selector(m_uiMessageType));
    if (messageType == 49) {
        NSString * content = [wrap performSelector:@selector(m_nsContent)];
        if ([content rangeOfString:@"wxpay://"].location != NSNotFound && WCPluginGetRedEnvelopEnabled()) {
            [[WCPluginRedEnvelopHelper shareInstance] onRedEnvelopAsyncMessage:msg wrap:wrap];
        }
    }
    return;
}

static void __WCRedEnvelopesLogicMgr_OnWCToHongbaoCommonResponse_Request(id this, SEL cmd, id resp, id req) {
    
    [this performSelector:@selector(ORIGOnWCToHongbaoCommonResponse:Request:)
               withObject:resp
               withObject:req];
    
    int cgiCmdId = WCPluginIntGetter(resp, @selector(cgiCmdid));
    if (cgiCmdId != 3) {
        return;
    }
    [[WCPluginRedEnvelopHelper shareInstance] onRedEnvelopCommonResponse:resp request:req];
    return;
}
