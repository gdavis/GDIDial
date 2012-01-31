//
//  GDIDialSlice.h
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GDIDialSlice : UIView

- (id)initWithRadius:(CGFloat)r width:(CGFloat)width;

@property(nonatomic,readonly) CGFloat radius;
@property(nonatomic,readonly) CGFloat width;
@property(nonatomic) CGFloat rotation;
@property(strong,nonatomic,readonly) CAShapeLayer *sliceLayer;

- (CGFloat)sizeInRadians;
CGPoint cartesianCoordinateFromPolar(float radius, float radians);

@end