//
//  WCPluginRedEnvelopOperation.h
//  IPAPatch
//
//  Created by 吴昕 on 15/08/2017.
//  Copyright © 2017 Weibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCPluginRedEnvelopParam.h"

@interface WCPluginRedEnvelopOperation : NSOperation

- (instancetype)initWithRedEnvelopParam:(WCPluginRedEnvelopParam *)param delay:(NSInteger)delay;

@end
