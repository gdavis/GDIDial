//
//  GDIDialGestureView.m
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDIDialGestureView.h"
#import <QuartzCore/QuartzCore.h>
#import "GDIMath.h"


@interface GDIDialGestureView()
//- (void)buildDialArea;
//CGPoint cartesianCoordinateFromPolar(float radius, float radians);
@end


@implementation GDIDialGestureView

@synthesize delegate = _delegate;
@synthesize dialRadius = _dialRadius;


- (id)initWithFrame:(CGRect)frame dialRadius:(CGFloat)radius
{
    self = [super initWithFrame:frame];
    if (self) {
        _dialRadius = radius;
    }
    return self;
}

#pragma mark - Private Methods

/*
- (void)buildDialArea
{
    CAShapeLayer *dialOutline = [CAShapeLayer layer];
    [self.layer addSublayer:dialOutline];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, nil, CGRectMake(0, 0, _dialRadius* 2, _dialRadius * 2));
    dialOutline.path = path;
    
    dialOutline.strokeColor = [[UIColor grayColor] CGColor];
    dialOutline.lineWidth = 5.f;
    
    dialOutline.fillColor = [[UIColor colorWithRed:0.f green:1.f blue:0.f alpha:.2f] CGColor];
    
    
    int dl = 36;
    int angleIncrement = 360 / dl;
    int currentAngle = 0;
    
    for (int i=0; i<dl; i++) {
        
        CGFloat rads = degreesToRadians(currentAngle);
        CGPoint point = cartesianCoordinateFromPolar(_dialRadius, rads);
        
        NSLog(@"point: %@", NSStringFromCGPoint(point));
        
        CAShapeLayer *dot = [CAShapeLayer layer];
        dot.frame = CGRectMake(point.x + _dialRadius, point.y + _dialRadius, 5, 5);
        CGMutablePathRef dotPath = CGPathCreateMutable();
        CGPathAddEllipseInRect(dotPath, NULL, CGRectMake(-dot.frame.size.width * .5 , -dot.frame.size.height * .5, dot.frame.size.width, dot.frame.size.height));
        dot.fillColor = [[UIColor blueColor] CGColor];
        dot.path = dotPath;
        [self.layer addSublayer:dot];
        
        currentAngle += angleIncrement;
    }
    
    
    // create big dot for circle origin
    CGSize originDotSize = CGSizeMake(10, 10);
    CGPoint origin = cartesianCoordinateFromPolar(_dialRadius, 0);
    CAShapeLayer *originDot = [CAShapeLayer layer];
    originDot.frame = CGRectMake(origin.x + _dialRadius, origin.y + _dialRadius, originDotSize.width, originDotSize.height);
    CGMutablePathRef dotPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(dotPath, NULL, CGRectMake(-originDotSize.width * .5 , -originDotSize.height * .5, originDotSize.width, originDotSize.height));
    originDot.fillColor = [[UIColor yellowColor] CGColor];
    originDot.path = dotPath;
    [self.layer addSublayer:originDot];
}
*/

//CGPoint cartesianCoordinateFromPolar(float radius, float radians)
//{
//    float x,y;
//    
//    x = radius * cosf(radians);
//    y = radius * sinf(radians);
//    
//    return CGPointMake(x, y);
//}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(gestureView:touchBeganAtPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchBeganAtPoint:[touch locationInView:self]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    if ([_delegate respondsToSelector:@selector(gestureView:touchMovedToPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchMovedToPoint:[touch locationInView:self]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(gestureView:touchEndedAtPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchEndedAtPoint:[touch locationInView:self]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(gestureView:touchEndedAtPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchEndedAtPoint:[touch locationInView:self]];
    }
}


@end
