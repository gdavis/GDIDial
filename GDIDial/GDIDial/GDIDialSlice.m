//
//  GDIDialSlice.m
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDIDialSlice.h"
#import "GDIMath.h"

@implementation GDIDialSlice
@synthesize radius = _radius;
@synthesize width = _width;
@synthesize rotation = _rotation;
@synthesize sliceLayer = _sliceLayer;

- (id)initWithRadius:(CGFloat)r width:(CGFloat)width
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _radius = r;
        _width = width;
        
        // create a layer slice which represents the physical shape of the slice
        _sliceLayer = [CAShapeLayer layer];
        
        CGFloat radiansOffset = degreesToRadians(90);
        CGPoint botRightCorner = cartesianCoordinateFromPolar(_radius, (-width*.5 / _radius) + radiansOffset );
        CGPoint botLeftCorner = cartesianCoordinateFromPolar(_radius, (width*.5 / _radius) + radiansOffset );
//        CGPoint botArcCenter = cartesianCoordinateFromPolar(_radius, radiansOffset);
        
        CGMutablePathRef slicePath = CGPathCreateMutable();
        CGPathMoveToPoint(slicePath, NULL, 0, 0);
        CGPathAddLineToPoint(slicePath, NULL, botRightCorner.x, botRightCorner.y);
//        CGPathAddArc(slicePath, NULL, botArcCenter.x, botArcCenter.y, _radius, (-width*.5 / _radius), (width*.5 / _radius), YES);
//        CGPathAddArcToPoint(slicePath, NULL, botArcCenter.x, botArcCenter.y, botLeftCorner.x, botLeftCorner.y, _radius);
        CGPathAddLineToPoint(slicePath, NULL, botLeftCorner.x, botLeftCorner.y);
        CGPathAddLineToPoint(slicePath, NULL, 0, 0);
        CGPathCloseSubpath(slicePath);
        _sliceLayer.path = slicePath;
        _sliceLayer.lineWidth = 1.f;
        _sliceLayer.strokeColor = [[UIColor redColor] CGColor];
        CGPathRelease(slicePath);
        
        [self.layer addSublayer:_sliceLayer];
        
        self.opaque = NO;
    }
    return self;
}


- (CGFloat)sizeInRadians
{
    return _width / _radius;
}

- (void)setRotation:(CGFloat)rotation
{
    _rotation = rotation;
    self.transform = CGAffineTransformMakeRotation(_rotation);
}


@end