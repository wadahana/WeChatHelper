//
//  WCPluginDBHelper.h
//  WeChatPlugin
//
//  Created by 吴昕 on 23/12/2017.
//  Copyright © 2017 wadahana. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WCPluginDBHelper : NSObject

@property (nonatomic, assign) BOOL revokeEnabled;
@property (nonatomic, assign) BOOL redEnvelopEnabled;
@property (nonatomic, assign) BOOL redEnvelopSerial;
@property (nonatomic, assign) BOOL redEnvelopOpenSelf;
@property (nonatomic, assign)  NSInteger redEnvelopDelay;

+ (instancetype) shareInstance;


@end
