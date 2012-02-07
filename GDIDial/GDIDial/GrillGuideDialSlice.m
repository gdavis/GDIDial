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
        
        CAShapeLayer *arrow = [CAShapeLayer layer];
        arrow.fillColor = [[UIColor blackColor] CGColor];
        CGMutablePathRef path = CGPathCreateMutable();
        
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
