//
//  CarMapViewModelTests.m
//  ChallengeTests
//
//  Created by Matheus Cardoso kuhn on 07/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MapKit/MapKit.h>
#import "CarMapViewModel.h"
#import "ChallengeTests-Swift.h"

@interface CarMapViewModelTests : XCTestCase

@end

@implementation CarMapViewModelTests

CarMapViewModel *viewModel;

- (void)setUp {
    viewModel = [[CarMapViewModel alloc] init];
}

- (void)tearDown {
//    viewModel = NULL;
}

- (void)testIsPainGestureOn {
    [viewModel setIsPainGestureActivated:true];
    XCTAssertTrue([viewModel getIsPainGestureActivated]);
}

- (void)testIsPainGestureOff {
    [viewModel setIsPainGestureActivated:false];
    XCTAssertFalse([viewModel getIsPainGestureActivated]);
}

- (void)testCalculateTranslationLowLevel {
    CGFloat lowLevel = 90;
    XCTAssertEqual([viewModel calculateHeight:80 translationY:0], lowLevel);
}

- (void)testCalculateTranslationNormalLevel {
    CGFloat normalLevel = 100;
    XCTAssertEqual([viewModel calculateHeight:100 translationY:0], normalLevel);
}

- (void)testCalculateTranslationMaxLevel {
    CGFloat maxLevel = UIApplication.sharedApplication.keyWindow.bounds.size.height * 0.8;
    XCTAssertEqual([viewModel calculateHeight:maxLevel + 10 translationY:0], maxLevel);
}

- (void)testGetListHeightLowLevel {
    CGFloat lowLevel = 90;
    XCTAssertEqual([viewModel getListHeight:100 translationY:0], lowLevel);
}

- (void)testGetListHeightMidLevel {
    CGFloat midLevel = UIApplication.sharedApplication.keyWindow.bounds.size.height * 0.45;
    XCTAssertEqual([viewModel getListHeight:midLevel translationY:10], midLevel);
}

- (void)testGetListHeightMaxLevel {
    CGFloat maxLevel = UIApplication.sharedApplication.keyWindow.bounds.size.height * 0.8;
    XCTAssertEqual([viewModel getListHeight:maxLevel translationY:20], maxLevel);
}

- (void)testCreateCarAnnotation {
    Car *car1 = [[Car alloc] init];
    Car *car2 = [[Car alloc] init];
    NSDecimalNumber *dec1 = [[NSDecimalNumber alloc] initWithDouble:1.0];
    NSDecimalNumber *dec2 = [[NSDecimalNumber alloc] initWithDouble:1.0];
    NSDecimalNumber *dec3 = [[NSDecimalNumber alloc] initWithDouble:1.0];
    NSDecimalNumber *dec4 = [[NSDecimalNumber alloc] initWithDouble:1.0];
    Coordinate *coordinate1 = [[Coordinate alloc] initWithLatitude:dec1 longitude:dec2];
    Coordinate *coordinate2 = [[Coordinate alloc] initWithLatitude:dec3 longitude:dec4];
    car1.coordinate = coordinate1;
    car2.coordinate = coordinate2;
    NSArray<CarAnnotation *> *annotations = [viewModel createCarAnnotationsWith:@[car1, car2]];
    XCTAssertEqual(annotations.count, 2);
}

- (void)testGetAnnotationViewRotationAngle {
    CarAnnotation *annotation = [[CarAnnotation alloc] init];
    Car *car = [[Car alloc] init];
    car.heading = [[NSDecimalNumber alloc] initWithDouble:60.0];
    annotation.car = car;
    CGFloat radians = [viewModel getAnnotationViewRotationAngleWith:annotation];
    XCTAssertGreaterThan(radians, 1.0);
    XCTAssertLessThan(radians, 1.1);
}

- (void)testGetAnnotationViewRect {
    CGRect rect = [viewModel getAnnovationViewRect];
    XCTAssertEqual(rect.size.width, 30);
    XCTAssertEqual(rect.size.height, 30);
}

- (void)testGelAllAnnotations {
    Car *car1 = [[Car alloc] init];
    Car *car2 = [[Car alloc] init];
    NSDecimalNumber *decimalValue = [[NSDecimalNumber alloc] initWithDouble:1.0];
    Coordinate *coordinate = [[Coordinate alloc] initWithLatitude:decimalValue longitude:decimalValue];
    car1.coordinate = coordinate;
    car2.coordinate = coordinate;
    NSArray<CarAnnotation *> *annotations = [viewModel createCarAnnotationsWith:@[car1, car2]];
    XCTAssertEqual([viewModel getAllAnnotations].count, annotations.count);
}

- (void)testGetLastUserLocation {
    XCTAssertNil([viewModel getLastUserLocation]);
}

- (void)testConvertBoundsOnCoordinates {
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSArray<CLLocation *> *locations = [viewModel convertBoundsOnCoordinatesOf:mapView];
    XCTAssertEqual(locations.count, 2);
}

@end
