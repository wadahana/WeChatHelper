//
//  WCPluginRedEnvelopTaskManager.h
//  IPAPatch
//
//  Created by 吴昕 on 16/08/2017.
//  Copyright © 2017 Weibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCPluginRedEnvelopOperation.h"

@interface WCPluginRedEnvelopTaskManager : NSObject

+ (instancetype)shareInstance;

- (void)addNormalTask:(WCPluginRedEnvelopOperation *)task;

- (void)addSerialTask:(WCPluginRedEnvelopOperation *)task;

- (BOOL)serialQueueIsEmpty;

@end
