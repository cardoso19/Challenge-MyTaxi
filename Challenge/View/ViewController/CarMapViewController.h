//
//  CarMapViewController.h
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CarMapViewModel.h"
#import "CarAnnotationView.h"

NS_ASSUME_NONNULL_BEGIN

@class CarListViewModel;

@interface CarMapViewController : UIViewController<MKMapViewDelegate>
- (void)createCarAnnotations;
@end

NS_ASSUME_NONNULL_END
