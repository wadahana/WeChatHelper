//
//  WeChatPlugin.m
//  WeChatPlugin
//
//  Created by wadahana on 22/12/2017.
//  Copyright © 2017 wadahana. All rights reserved.
//

#import "WeChatPlugin.h"
#import "Cycript/Cycript.h"

@implementation WeChatPlugin

+ (void)load {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CYListenServer(8899);
    });
}

@end
