//
//  GrillGuideDialSlice.m
//  GDIDial
//
//  Created by Grant Davis on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrillGuideDialSlice.h"
#import "GDIMath.h"

#define kArrowSize CGSizeMake(29.f, 9.f)
#define kRadiusOffset 42.f

@implementation GrillGuideDialSlice

- (id)initWithRadius:(CGFloat)r width:(CGFloat)width
{
    self = [super initWithRadius:r width:width];
    if (self) {
        
        CAShapeLayer *centerLine = [CAShapeLayer layer];
        centerLine.strokeColor = [[UIColor colorWithWhite:1.f alpha:.75f] CGColor];
        centerLine.lineWidth = 1.f;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPoint endPoint = cartesianCoordinateFromPolar(self.radius-kRadiusOffset, M_PI*.5);
        CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
        
        centerLine.path = path;
        CGPathRelease(path);
        
        [self.layer insertSublayer:centerLine atIndex:0];
        
        CAShapeLayer *arrow = [CAShapeLayer layer];
        arrow.fillColor = [[UIColor blackColor] CGColor];
        path = CGPathCreateMutable();
        
        CGPoint arrowOrigin = CGPointMake(0, self.radius-kArrowSize.height-kRadiusOffset);
        CGPathMoveToPoint(path, NULL, arrowOrigin.x, arrowOrigin.y);
        CGPathAddLineToPoint(path, NULL, arrowOrigin.x + kArrowSize.width * .5, arrowOrigin.y + kArrowSize.height);
        CGPathAddLineToPoint(path, NULL, arrowOrigin.x - kArrowSize.width * .5, arrowOrigin.y + kArrowSize.height);
        CGPathCloseSubpath(path);
        
        arrow.path = path;
        CGPathRelease(path);
        
        [self.layer insertSublayer:arrow atIndex:1];
        
    }
    return self;
}

@end
