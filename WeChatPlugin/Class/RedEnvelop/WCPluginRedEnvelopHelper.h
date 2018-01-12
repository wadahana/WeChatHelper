//
//  WCPluginRedEnvelopHelper.h
//  IPAPatch
//
//  Created by 吴昕 on 15/08/2017.
//  Copyright © 2017 Weibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCPluginRedEnvelopParam.h"

@interface WCPluginRedEnvelopHelper : NSObject

+ (instancetype) shareInstance;



- (void) onRedEnvelopAsyncMessage: (id)msg wrap:(id)wrap;

- (void) onRedEnvelopCommonResponse:(id)response request:(id)request;

@end
