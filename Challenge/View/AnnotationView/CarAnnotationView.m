//
//  CarAnnotationView.m
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

#import "CarAnnotationView.h"

@implementation CarAnnotationView

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)image heading:(CGFloat)heading {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:image];
        [imageView setTransform: CGAffineTransformRotate(CGAffineTransformIdentity, heading)];
        [self addSubview:imageView];
         self.imageViewIcon = imageView;
    }
    return self;
}

@end
