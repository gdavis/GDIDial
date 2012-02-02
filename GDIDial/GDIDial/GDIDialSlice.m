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
@synthesize backgroundLayer = _backgroundLayer;
@synthesize contentView = _contentView;
@synthesize label = _label;

- (id)initWithRadius:(CGFloat)r width:(CGFloat)width
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _radius = r;
        _width = width;
        
        self.opaque = NO;
        
        // create a layer slice which represents the physical shape of the slice
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.fillColor = [[UIColor clearColor] CGColor];
        
        CGFloat radiansOffset = degreesToRadians(90);
        CGPoint botRightCorner = cartesianCoordinateFromPolar(_radius, (-width*.5 / _radius) + radiansOffset );        
        
        CGMutablePathRef slicePath = CGPathCreateMutable();
        CGPathMoveToPoint(slicePath, NULL, 0, 0);
        CGPathAddLineToPoint(slicePath, NULL, botRightCorner.x, botRightCorner.y);
        CGPathAddArc(slicePath, NULL, 0, 0, _radius, -[self sizeInRadians] * .5 + radiansOffset, [self sizeInRadians] * .5 + radiansOffset, NO);
        CGPathAddLineToPoint(slicePath, NULL, 0, 0);
        CGPathCloseSubpath(slicePath);
        _backgroundLayer.path = slicePath;
        CGPathRelease(slicePath);
        [self.layer addSublayer:_backgroundLayer];
        
        // create content layer which is rotated  in order to center content within the slice.
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.clipsToBounds = NO;
        _contentView.transform = CGAffineTransformMakeRotation([self sizeInRadians] * .5);
        [self addSubview:_contentView];
        self.contentView.backgroundColor = [UIColor redColor];
        
        // create label
        _label = [[GDICurvedLabel alloc] initWithRadius:_radius origin:CGPointZero sizeInRadians:[self sizeInRadians]];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.shadowColor = [UIColor blackColor];
        _label.shadowOffset = CGSizeMake(1, 1);
        _label.font = [UIFont boldSystemFontOfSize:18.f];
        _label.opaque = NO;
        [self.contentView addSubview:_label];
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