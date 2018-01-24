//
//  CLLocationManager+WCPlugin.m
//  WeChatPlugin
//
//  Created by 吴昕 on 24/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import "CLLocationManager+WCPlugin.h"
#import "WCPluginMethodSwizzling.h"
#import "WCPluginDataHelper.h"
#import "WCPluginLocationManager.h"

static const char * kKeywordNewDelegate  = "new_delegate";
static const char * kKeywordOriginDelegate = "origin_delegate";

@implementation CLLocationManager (WCPlugin)

id newDelegateGetter(__unsafe_unretained id assignSlf) {
    return objc_getAssociatedObject(assignSlf, kKeywordNewDelegate);
}

void newDelegateSetter(__unsafe_unretained id assignSlf, id newDelegate) {
    objc_setAssociatedObject(assignSlf, kKeywordNewDelegate, newDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//
//NSString *originDelegateGetter(__unsafe_unretained id assignSlf, SEL selector) {
//    return objc_getAssociatedObject(assignSlf, kKeywordOriginDelegate);
//}
//
//void originDelegateSetter(__unsafe_unretained id assignSlf, SEL selector, id originDelegate) {
//    objc_setAssociatedObject(assignSlf, kKeywordOriginDelegate, originDelegate, OBJC_ASSOCIATION_ASSIGN);
//}

- (CLLocation *) hooked_location {
    NSLog(@"hooked_getLocation -> ");
    CLLocation * loc = [self hooked_location];
    if (WCPluginGetFakeLocEnabled()) {
        CLLocationCoordinate2D loc2D = WCPluginGetFakeLocCurrentLoc();
        if (CLLocationCoordinate2DIsValid(loc2D)) {
            CLLocation * newLoc = [[CLLocation alloc] initWithCoordinate:loc2D
                                                                altitude:loc.altitude
                                                      horizontalAccuracy:loc.horizontalAccuracy
                                                        verticalAccuracy:loc.verticalAccuracy
                                                                  course:loc.course
                                                                   speed:loc.speed
                                                               timestamp:loc.timestamp];
            if (newLoc) {
                loc = newLoc;
            }
        }
    }
    return loc;
}

- (void) hooked_setDelegate:(id<CLLocationManagerDelegate>)delegate {
    
    WCPluginLocationManager * newDelegate = (WCPluginLocationManager *)newDelegateGetter(self);
    NSLog(@"hooked_setDelegate -> self(%p) delegate(%p, %@) newDelegate(%p)", self, delegate,  [delegate class], newDelegate);
    
    if (delegate) {
        if (!newDelegate) {
            newDelegate = [WCPluginLocationManager new];
        }
        newDelegate.delegate = delegate;
        newDelegateSetter(self, newDelegate);
        [self hooked_setDelegate:newDelegate];
        NSLog(@"hooked_setDelegate -> self(%p) delegate(%p) setNewDelegate(%p)", self, delegate, newDelegate);
    } else if (delegate == nil) {
        newDelegateSetter(self, nil);
        [self hooked_setDelegate:nil];
        NSLog(@"hooked_setDelegate -> self(%p) delegate(%p) setNewDelegate(%p)", self, delegate, newDelegate);
    }
}

+ (void)hook {

    WCPluginExchangeInstanceMethod([CLLocationManager class],
                       @selector(location),
                       @selector(hooked_location));
    
    WCPluginExchangeInstanceMethod([CLLocationManager class],
                   @selector(setDelegate:),
                   @selector(hooked_setDelegate:));
    
    
}
@end
