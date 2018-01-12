//
//  WCPluginRedEnvelopOperation.m
//  IPAPatch
//
//  Created by wadahana on 15/08/2017.
//  Copyright © 2017 wadahana. All rights reserved.
//

#import "WCPluginRedEnvelopOperation.h"
#import "WCPluginUtils.h"

#import "WeChatHeader.h"

@interface WCPluginRedEnvelopOperation()

@property (assign, nonatomic, getter=isExecuting) BOOL executing;
@property (assign, nonatomic, getter=isFinished) BOOL finished;

@property (strong, nonatomic) WCPluginRedEnvelopParam *redEnvelopParam;
@property (assign, nonatomic) NSInteger delaySeconds;

@end

@implementation WCPluginRedEnvelopOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRedEnvelopParam:(WCPluginRedEnvelopParam *)param delay:(NSInteger)delay {
    if (self = [super init]) {
        self.redEnvelopParam = param;
        self.delaySeconds = delay;
    }
    return self;
}

- (void)start {
    if (self.isCancelled) {
        self.finished = YES;
        self.executing = NO;
        return;
    }
    [self main];
    self.executing = YES;
    self.finished = NO;
}
- (void)main {

    sleep((unsigned int)self.delaySeconds);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    MMServiceCenter * serviceCenter = [NSClassFromString(@"MMServiceCenter") defaultCenter];
    id logicMgr = [serviceCenter getService:NSClassFromString(@"WCRedEnvelopesLogicMgr")];
    [logicMgr performSelector:@selector(OpenRedEnvelopesRequest:) withObject:[self.redEnvelopParam toParams]];
#pragma clang diagnostic pop
    self.finished = YES;
    self.executing = NO;
}

- (void)cancel {
    self.finished = YES;
    self.executing = NO;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isAsynchronous {
    return YES;
}

@end
