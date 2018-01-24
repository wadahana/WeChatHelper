//
//  WCPluginFakeLocHijack.m
//  WeChatPlugin
//
//  Created by wadahana on 24/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLLocationManager+WCPlugin.h"

void WCPluginFakeLocHijackStart() {
    [CLLocationManager hook];
    return;
}
