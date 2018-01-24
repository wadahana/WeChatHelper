//
//  WCPluginLocationManager.m
//  WeChatPlugin
//
//  Created by 吴昕 on 24/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import "WCPluginLocationManager.h"
#import "WCPluginDataHelper.h"
@implementation WCPluginLocationManager
/*
 共享位置/发送位置: QMapView/MMLocationMgr
 MapView: MKCoreLocationProvider
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  if (self.delegate && [self.delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
        CLLocation * loc = newLocation;
        if (WCPluginGetFakeLocEnabled()) {
            CLLocationCoordinate2D loc2D = WCPluginGetFakeLocCurrentLoc();
            if (CLLocationCoordinate2DIsValid(loc2D)) {
                loc = [[CLLocation alloc] initWithCoordinate:loc2D
                                                    altitude:newLocation.altitude
                                          horizontalAccuracy:newLocation.horizontalAccuracy
                                            verticalAccuracy:newLocation.verticalAccuracy
                                                      course:newLocation.course
                                                       speed:newLocation.speed
                                                   timestamp:newLocation.timestamp];
                newLocation = loc;
            }
        }
        [self.delegate locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([self.delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
        if (WCPluginGetFakeLocEnabled()) {
            CLLocationCoordinate2D loc2D = WCPluginGetFakeLocCurrentLoc();
            if (CLLocationCoordinate2DIsValid(loc2D)) {
                if (locations.count > 0) {
                    CLLocation * newLocation = locations[0];
                    CLLocation * fakeLocation = [[CLLocation alloc] initWithCoordinate:loc2D
                                                                              altitude:newLocation.altitude
                                                                    horizontalAccuracy:newLocation.horizontalAccuracy
                                                                      verticalAccuracy:newLocation.verticalAccuracy
                                                                                course:newLocation.course
                                                                                 speed:newLocation.speed
                                                                             timestamp:newLocation.timestamp];
                    locations = @[fakeLocation];
                } else {
                    CLLocation * fakeLocation = [[CLLocation alloc] initWithLatitude:loc2D.latitude longitude:loc2D.longitude];
                    locations = @[fakeLocation];
                }
            }
        }
        [self.delegate locationManager:manager didUpdateLocations:locations];
    } else if ([self.delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
        CLLocation * newLocation = nil;
        if (locations.count > 0) {
            newLocation = locations[0];
        }
        CLLocation * loc = newLocation;
        if (WCPluginGetFakeLocEnabled()) {
            CLLocationCoordinate2D loc2D = WCPluginGetFakeLocCurrentLoc();
            if (CLLocationCoordinate2DIsValid(loc2D)) {
                loc = [[CLLocation alloc] initWithCoordinate:loc2D
                                                    altitude:newLocation.altitude
                                          horizontalAccuracy:newLocation.horizontalAccuracy
                                            verticalAccuracy:newLocation.verticalAccuracy
                                                      course:newLocation.course
                                                       speed:newLocation.speed
                                                   timestamp:newLocation.timestamp];
                newLocation = loc;
            }
        }
        [self.delegate locationManager:manager didUpdateToLocation:newLocation fromLocation:nil];
    }
    return;
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading; {
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationManager:didUpdateHeading:)]) {
        [self.delegate locationManager:manager didUpdateHeading:newHeading];
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
        [self.delegate locationManager:manager didFailWithError:error];
    }
    return;
}


@end
