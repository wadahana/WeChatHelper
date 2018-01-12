//
//  WCPluginRedEnvelopParamQueue.h
//  IPAPatch
//
//  Created by wadahana on 16/08/2017.
//  Copyright © 2017 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCPluginRedEnvelopParam.h"

@interface WCPluginRedEnvelopParamQueue : NSObject

- (instancetype) init;

- (void) enqueue : (WCPluginRedEnvelopParam *)param;

- (WCPluginRedEnvelopParam *)dequeue;

- (WCPluginRedEnvelopParam *)peek;

- (BOOL)isEmpty;

@end
