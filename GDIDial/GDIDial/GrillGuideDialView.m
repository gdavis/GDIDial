//
//  GrillGuideDialView.m
//  GDIDial
//
//  Created by Grant Davis on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrillGuideDialView.h"
#import <QuartzCore/QuartzCore.h>
#import "GDIMath.h"

#define kRingSize 42.f
#define kTickSize 3.f

@implementation GrillGuideDialView


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set stroke for tick marks
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(context, 1.f);    
    
    // draw outer ticks
    CGFloat tickAngle = degreesToRadians(3);
    int numTicks = (M_PI*2)/tickAngle;
    CGFloat currentAngle = 0;
    CGFloat radius = self.frame.size.width*.5;
    
    CGContextBeginPath(context);
    for (int i=0; i<=numTicks; i++) {
        
        CGPoint startPoint = cartesianCoordinateFromPolar(radius - kTickSize, currentAngle);
        CGPoint endPoint = cartesianCoordinateFromPolar(radius, currentAngle);
        CGContextMoveToPoint(context, startPoint.x + self.center.x, startPoint.y + self.center.y);
        CGContextAddLineToPoint(context, endPoint.x + self.center.x, endPoint.y + self.center.y);
        currentAngle += tickAngle;
    }
    CGContextStrokePath(context);
    
    
    // draw outer ring
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5.f, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake(kTickSize, kTickSize, self.bounds.size.width - kTickSize*2, self.bounds.size.height - kTickSize*2));

    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5.f, [[UIColor clearColor] CGColor]);
    
    // draw inner ring
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:.39f green:.39f blue:.39f alpha:1.f] CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake(kTickSize + kRingSize, kTickSize + kRingSize, self.bounds.size.width - (kTickSize+kRingSize)*2, self.bounds.size.height - (kTickSize+kRingSize)*2));
    

    // draw inner ticks    
    CGContextBeginPath(context);
    currentAngle = 0;
    for (int i=0; i<=numTicks; i++) {

        CGPoint startPoint = cartesianCoordinateFromPolar(radius - kRingSize - kTickSize*2, currentAngle);
        CGPoint endPoint = cartesianCoordinateFromPolar(radius - kRingSize - kTickSize, currentAngle);
        CGContextMoveToPoint(context, startPoint.x + self.center.x, startPoint.y + self.center.y);
        CGContextAddLineToPoint(context, endPoint.x + self.center.x, endPoint.y + self.center.y);
        currentAngle += tickAngle;
    }
    CGContextStrokePath(context);
}


@end
