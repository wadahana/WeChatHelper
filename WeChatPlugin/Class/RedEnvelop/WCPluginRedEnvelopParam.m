//
//  WCPluginRedEnvelopParam.m
//  IPAPatch
//
//  Created by 吴昕 on 15/08/2017.
//  Copyright © 2017 Weibo. All rights reserved.
//

#import "WCPluginRedEnvelopParam.h"

@implementation WCPluginRedEnvelopParam

- (NSDictionary *)toParams {
    return @{
             @"msgType": self.msgType,
             @"sendId": self.sendId,
             @"channelId": self.channelId,
             @"nickName": self.nickName,
             @"headImg": self.headImg,
             @"nativeUrl": self.nativeUrl,
             @"sessionUserName": self.sessionUserName,
             @"timingIdentifier": self.timingIdentifier
             };
}

@end
