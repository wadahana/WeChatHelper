//
//  WCPluginMapViewController.m
//  WeChatPlugin
//
//  Created by wadahana on 16/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import "WCPluginMapViewController.h"
#import "WCPluginDataHelper.h"

static NSString * kAnnotationIdentifier = @"kAnnotationIdentifier";

@interface WCPluginMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView * mapView;
@property (nonatomic, strong) UILongPressGestureRecognizer * longPressGesture;
@property (nonatomic, strong) MKPointAnnotation * fakeLocAnnotation;
@property (nonatomic, strong) MKPinAnnotationView * fakeLocAnnotationView;
@property (nonatomic, strong) MKPointAnnotation * selectedAnnotation;
@property (nonatomic, strong) MKPinAnnotationView * selectedAnnotationView;

@end

@implementation WCPluginMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedAnnotation = nil;
    self.selectedAnnotationView = nil;
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:self.mapView];
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressGesture:)];
    self.longPressGesture.minimumPressDuration = 1;//按0.5秒响应longPress方法
    self.longPressGesture.allowableMovement = 10.0;
    [self.mapView addGestureRecognizer:self.longPressGesture];
    
    if (![CLLocationManager locationServicesEnabled] ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"实时监控没有打开，无法查看数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    CLLocationCoordinate2D loc = WCPluginGetFakeLocCurrentLoc();
    if (CLLocationCoordinate2DIsValid(loc)) {
        self.fakeLocAnnotation = [[MKPointAnnotation alloc] init];
        self.fakeLocAnnotation.coordinate = loc;
        self.fakeLocAnnotation.title = @"删除";
        
        [self.mapView addAnnotation:self.fakeLocAnnotation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLongPressGesture:(UIGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    if (self.selectedAnnotation) {
        [self.mapView removeAnnotation:self.selectedAnnotation];
        self.selectedAnnotation = nil;
    }
    self.selectedAnnotation = [[MKPointAnnotation alloc] init];
    self.selectedAnnotation.coordinate = touchMapCoordinate;
    self.selectedAnnotation.title = @"设置";
    
    [self.mapView addAnnotation:self.selectedAnnotation];
}

- (void)onAddButton:(UIButton *)button {
    if (self.fakeLocAnnotation) {
        [self.mapView removeAnnotation:self.fakeLocAnnotation];
        self.fakeLocAnnotation = nil;
    }
    if (self.selectedAnnotation) {
        MKPointAnnotation * annotation = self.selectedAnnotation;
        [self.mapView removeAnnotation:self.selectedAnnotation];
        self.selectedAnnotation = nil;
        CLLocationCoordinate2D loc = annotation.coordinate;
        if (CLLocationCoordinate2DIsValid(loc)) {
            self.fakeLocAnnotation = annotation;
            self.fakeLocAnnotation.title = @"删除";
            [self.mapView addAnnotation:self.fakeLocAnnotation];
            WCPluginSetFakeLocCurrentLoc(loc);
        }
    }
}

- (void)onDeleteButton:(UIButton *)button {
    if (self.fakeLocAnnotation) {
        [self.mapView removeAnnotation:self.fakeLocAnnotation];
        self.fakeLocAnnotation = nil;
    }
    CLLocationCoordinate2D loc = kCLLocationCoordinate2DInvalid;
    WCPluginSetFakeLocCurrentLoc(loc);
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKAnnotationView * customView = nil;
    if (annotation == self.selectedAnnotation) {
        if (!self.selectedAnnotationView) {
            self.selectedAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
        }
        self.selectedAnnotationView.pinColor = MKPinAnnotationColorRed; //设置大头针的颜色
        self.selectedAnnotationView.animatesDrop = YES;
        self.selectedAnnotationView.canShowCallout = YES;
        self.selectedAnnotationView.draggable = YES;//可以拖动
        
        UIButton* addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [addButton addTarget:self action:@selector(onAddButton:) forControlEvents:UIControlEventTouchUpInside];
        self.selectedAnnotationView.rightCalloutAccessoryView = addButton;
        customView = self.selectedAnnotationView;
    } else if (annotation == self.fakeLocAnnotation) {
        if (!self.fakeLocAnnotationView) {
            self.fakeLocAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
        }
        self.fakeLocAnnotationView.pinColor = MKPinAnnotationColorPurple; //设置大头针的颜色
        self.fakeLocAnnotationView.animatesDrop = YES;
        self.fakeLocAnnotationView.canShowCallout = YES;
        self.fakeLocAnnotationView.draggable = YES;//可以拖动
        
        //添加tips上的按钮
        UIButton* delButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [delButton addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.fakeLocAnnotationView.rightCalloutAccessoryView = delButton;
        customView = self.fakeLocAnnotationView;
    }
    return customView;
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
