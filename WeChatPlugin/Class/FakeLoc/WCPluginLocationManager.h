//
//  WCPluginLocationManager.h
//  WeChatPlugin
//
//  Created by 吴昕 on 24/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface WCPluginLocationManager : NSObject<CLLocationManagerDelegate>

@property(strong, nonatomic, nullable) id<CLLocationManagerDelegate> delegate;

NS_ASSUME_NONNULL_BEGIN

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations;


- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading;
/*
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager;

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region;

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region;

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error;

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region;

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region ;
*/
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
/*
- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(nullable CLRegion *)region
              withError:(NSError *)error ;
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region ;
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager ;
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager ;
- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(nullable NSError *)error;

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit;

*/
NS_ASSUME_NONNULL_END
@end
