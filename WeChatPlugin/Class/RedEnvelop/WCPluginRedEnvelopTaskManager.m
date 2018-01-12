//
//  WCPluginRedEnvelopTaskManager.m
//  IPAPatch
//
//  Created by wadahana on 16/08/2017.
//  Copyright © 2017 . All rights reserved.
//

#import "WCPluginRedEnvelopTaskManager.h"
#import "WCPluginRedEnvelopOperation.h"

@interface WCPluginRedEnvelopTaskManager()

@property (strong, nonatomic) NSOperationQueue *normalTaskQueue;
@property (strong, nonatomic) NSOperationQueue *serialTaskQueue;

@end

static WCPluginRedEnvelopTaskManager * sInstance = nil;

@implementation WCPluginRedEnvelopTaskManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCPluginRedEnvelopTaskManager alloc] init];
    });
    return sInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.serialTaskQueue = [[NSOperationQueue alloc] init];
        self.serialTaskQueue.maxConcurrentOperationCount = 1;
        
        self.normalTaskQueue = [[NSOperationQueue alloc] init];
        self.normalTaskQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (void)addNormalTask:(WCPluginRedEnvelopOperation *)task {
    [self.normalTaskQueue addOperation:task];
}

- (void)addSerialTask:(WCPluginRedEnvelopOperation *)task {
    [self.serialTaskQueue addOperation:task];
}

- (BOOL)serialQueueIsEmpty {
    return [self.serialTaskQueue operations].count == 0;
}

@end
