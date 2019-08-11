//
//  CarAnnotationView.h
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CarAnnotation;

@interface CarAnnotationView : MKAnnotationView
@property (weak, nonatomic) UIImageView *imageViewIcon;
- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)image heading:(CGFloat) heading;
@end

NS_ASSUME_NONNULL_END
