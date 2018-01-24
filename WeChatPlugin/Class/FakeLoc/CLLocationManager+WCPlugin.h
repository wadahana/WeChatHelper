//
//  CLLocationManager+WCPlugin.h
//  WeChatPlugin
//
//  Created by 吴昕 on 24/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>


@interface CLLocationManager (WCPlugin)

- (CLLocation *) hooked_location;

- (void) hooked_setDelegate:(id<CLLocationManagerDelegate>)delegate;

+ (void) hook;

@end

