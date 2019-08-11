//
//  CarAnnotation.m
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

#import "CarAnnotation.h"
#if TEST
#import "ChallengeTests-Swift.h"
#else
#import "Challenge-Swift.h"
#endif

@implementation CarAnnotation
- (instancetype)initWithCoordinates:(CLLocationCoordinate2D) location car:(Car *)car {
    self = [super init];
    if (self) {
        self.coordinate = location;
        self.car = car;
    }
    return self;
}
@end
