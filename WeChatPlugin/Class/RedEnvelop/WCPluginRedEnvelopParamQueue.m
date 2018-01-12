//
//  WCPluginRedEnvelopParamQueue.m
//  IPAPatch
//
//  Created by 吴昕 on 16/08/2017.
//  Copyright © 2017 Weibo. All rights reserved.
//

#import "WCPluginRedEnvelopParamQueue.h"


@interface WCPluginRedEnvelopParamQueue()

@property (strong, nonatomic) NSMutableArray * queue;

@end

@implementation WCPluginRedEnvelopParamQueue

#pragma mark - WCPluginRedEnvelopParam Queue

- (instancetype)init {
    if (self = [super init]) {
        self.queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) enqueue : (WCPluginRedEnvelopParam *)param {
    [self.queue addObject:param];
}

- (WCPluginRedEnvelopParam *)dequeue {
    if (self.queue.count == 0 && !self.queue.firstObject) {
        return nil;
    }
    WCPluginRedEnvelopParam *first = self.queue.firstObject;
    [self.queue removeObjectAtIndex:0];
    return first;
}

- (WCPluginRedEnvelopParam *)peek {
    if (self.queue.count == 0) {
        return nil;
    }
    return self.queue.firstObject;
}

- (BOOL)isEmpty {
    return self.queue.count == 0;
}


@end
