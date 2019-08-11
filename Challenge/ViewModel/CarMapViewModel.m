//
//  CarMapViewModel.m
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

#import "CarMapViewModel.h"
#if TEST
#import "ChallengeTests-Swift.h"
#else
#import "Challenge-Swift.h"
#endif

@implementation CarMapViewModel
#pragma mark - Variables
CLLocationManager *_locationManager;
CLLocation * _Nullable _lastKnowLocations;
NSArray<CarAnnotation *> *_carAnnotations;
void (^_firstLocationUpdateClosure)(CLLocation *);
bool _isLocationUpdated = true;
bool _isPainGestureActivated = false;

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [self verifyLocationPermission: [CLLocationManager authorizationStatus]];
    }
    return self;
}

#pragma mark - Setter n Getter
- (void)setFirstLocationUpdateClosure:(void (^)(CLLocation *))closure {
    _firstLocationUpdateClosure = closure;
}

- (void)setIsPainGestureActivated:(BOOL) newValue {
    _isPainGestureActivated = newValue;
}

- (BOOL)getIsPainGestureActivated {
    return _isPainGestureActivated;
}

#pragma mark - Gesture
- (CGFloat)calculateHeight:(CGFloat) currentHeight translationY:(CGFloat)translationY {
    CGFloat maxLevel = UIApplication.sharedApplication.keyWindow.bounds.size.height * 0.8;
    CGFloat lowLevel = 90;
    CGFloat finalHeight = currentHeight + translationY * -1;
    if(finalHeight > maxLevel) {
        return maxLevel;
    } else if(finalHeight < lowLevel) {
        return lowLevel;
    } else {
        return finalHeight;
    }
}

- (CGFloat)getListHeight:(CGFloat) currentHeight translationY:(CGFloat)translationY {
    CGFloat maxLevel = UIApplication.sharedApplication.keyWindow.bounds.size.height * 0.8;
    CGFloat midLevel = UIApplication.sharedApplication.keyWindow.bounds.size.height * 0.45;
    CGFloat lowLevel = 90;
    CGFloat finalHeight = currentHeight + translationY * -1;
    if(finalHeight > maxLevel || fabs(maxLevel - finalHeight) < fabs(midLevel - finalHeight)) {
        return maxLevel;
    } else if(fabs(midLevel - finalHeight) < fabs(lowLevel - finalHeight)) {
        return midLevel;
    } else {
        return lowLevel;
    }
}

#pragma mark - Annotation
- (NSArray<CarAnnotation *> *)createCarAnnotationsWith:(NSArray<Car *> *)cars {
    NSMutableArray *newAnnotations = [[NSMutableArray alloc] init];
    for(Car * car in cars) {
        NSDecimalNumber *latitude = car.coordinate.latitude;
        NSDecimalNumber *longitude = car.coordinate.longitude;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        [newAnnotations addObject:[[CarAnnotation alloc] initWithCoordinates:coordinate car:car]];
    }
    _carAnnotations = newAnnotations;
    return newAnnotations;
}

- (CGFloat)getAnnotationViewRotationAngleWith:(CarAnnotation *)annotation {
    if(annotation.car.heading != NULL) {
        return (CGFloat) ((M_PI * annotation.car.heading.doubleValue)/180);
    }
    return 0;
}

- (CGRect)getAnnovationViewRect {
    return CGRectMake(0, 0, 30, 30);
}

- (NSArray<CarAnnotation *> *)getAllAnnotations {
    return _carAnnotations;
}

#pragma mark - Location
- (void)verifyLocationPermission:(CLAuthorizationStatus) status {
    switch (status) {
            case kCLAuthorizationStatusNotDetermined:
            [self requestLocationPermission];
            break;
            
            case kCLAuthorizationStatusAuthorizedAlways:
            [self configManagerToGetUserLocation];
            break;
            
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self configManagerToGetUserLocation];
            break;
            
            case kCLAuthorizationStatusRestricted:
            //The user can't choose whether or not your app can use location services or not, this could be due to parental controls for example.
            break;
            
            case kCLAuthorizationStatusDenied:
            //The user has chosen to not let your app use location services.
            break;
        default:
            break;
    }
}

- (void)requestLocationPermission {
    [_locationManager requestWhenInUseAuthorization];
}

- (void)configManagerToGetUserLocation {
    [_locationManager setDistanceFilter:300];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
}

- (CLLocation * _Nullable)getLastUserLocation {
    return _lastKnowLocations;
}

- (NSArray<CLLocation *> *)convertBoundsOnCoordinatesOf:(MKMapView *)mapView {
    CGPoint nePoint = CGPointMake(mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake((mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
    
    CLLocationCoordinate2D neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
    CLLocationCoordinate2D swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
    
    CLLocation *neLocation = [[CLLocation alloc] initWithLatitude:neCoord.latitude longitude:neCoord.longitude];
    CLLocation *swLocation = [[CLLocation alloc] initWithLatitude:swCoord.latitude longitude:swCoord.longitude];
    
    NSMutableArray *coordinates = [[NSMutableArray<CLLocation *> alloc] init];
    [coordinates addObject:neLocation];
    [coordinates addObject:swLocation];
    return coordinates;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self verifyLocationPermission: status];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    _lastKnowLocations = locations.firstObject;
    if (_isLocationUpdated && _firstLocationUpdateClosure != NULL) {
        _isLocationUpdated = false;
        _firstLocationUpdateClosure(_lastKnowLocations);
    }
}
@end
