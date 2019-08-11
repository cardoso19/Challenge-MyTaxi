//
//  CarMapViewModel.h
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CarAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@class Car;

@interface CarMapViewModel : NSObject<CLLocationManagerDelegate>
- (void)setFirstLocationUpdateClosure:(void (^)(CLLocation *))closure;
- (CGFloat)calculateHeight:(CGFloat) currentHeight translationY:(CGFloat)translationY;
- (CGFloat)getListHeight:(CGFloat) currentHeight translationY:(CGFloat)translationY;
- (void)setIsPainGestureActivated:(BOOL) newValue;
- (BOOL)getIsPainGestureActivated;
- (NSArray<CarAnnotation *> *)createCarAnnotationsWith:(NSArray<Car *> *)cars;
- (NSArray<CLLocation *> *)convertBoundsOnCoordinatesOf:(MKMapView *)mapView;
- (CLLocation * _Nullable)getLastUserLocation;
- (CGFloat)getAnnotationViewRotationAngleWith:(CarAnnotation *)annotation;
- (CGRect)getAnnovationViewRect;
- (NSArray<CarAnnotation *> *)getAllAnnotations;
@end

NS_ASSUME_NONNULL_END
