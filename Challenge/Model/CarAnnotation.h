//
//  CarAnnotation.h
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Car;

@interface CarAnnotation : NSObject<MKAnnotation>
@property (nonatomic) Car *car;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
- (instancetype)initWithCoordinates:(CLLocationCoordinate2D) location car:(Car *)car;
@end

NS_ASSUME_NONNULL_END
