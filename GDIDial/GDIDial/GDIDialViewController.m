//
//  GDIDialViewController.m
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDIDialViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GDIMath.h"


@interface GDIDialViewController()

@property(strong,nonatomic) UIView *rotatingDialContainerView;
@property(nonatomic) CGFloat velocity;
@property(nonatomic) CGPoint lastPoint;
@property(strong,nonatomic) NSTimer *decelerationTimer;

- (void)buildDial;
- (void)beginDeceleration;
- (void)endDeceleration;

- (CGPoint)normalizedPoint:(CGPoint)point inView:(UIView *)view;
- (void)trackTouchPoint:(CGPoint)point inView:(UIView*)view;

@end


@implementation GDIDialViewController

@synthesize dialPosition = _dialPosition;
@synthesize dialRadius = _dialRadius;
@synthesize items = _items;
@synthesize rotatingDialView = _rotatingDialView;

@synthesize rotatingDialContainerView = _rotatingDialContainerView;
@synthesize gestureView = _gestureView;
@synthesize velocity = _velocity;
@synthesize lastPoint = _lastPoint;
@synthesize decelerationTimer = _decelerationTimer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil items:(NSArray *)items
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _items = items;
        _dialPosition = GDIDialPositionBottom;
        _dialRadius = [NSNumber numberWithInt:160];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add rotating dial view
    _rotatingDialContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    [self.view addSubview:_rotatingDialContainerView];
    
    // position dial view in negative space for easy rotation
    self.rotatingDialView.frame = CGRectMake(-self.rotatingDialView.frame.size.width*.5, -self.rotatingDialView.frame.size.height*.5, self.rotatingDialView.frame.size.width, self.rotatingDialView.frame.size.height);
    [_rotatingDialContainerView addSubview:self.rotatingDialView];
    
    // create a custom gesture view which tells us when there are touches on the dial
    CGRect gestureViewFrame = CGRectMake(self.view.bounds.size.width * .5 - self.rotatingDialView.frame.size.width * .5, self.view.bounds.size.height * .5 - self.rotatingDialView.frame.size.height * .5, self.rotatingDialView.frame.size.width, self.rotatingDialView.frame.size.height);
    
    _gestureView = [[GDIDialGestureView alloc] initWithFrame:gestureViewFrame dialRadius:_dialRadius];
    _gestureView.delegate = self;
    [self.view addSubview:_gestureView];
}


- (void)viewDidUnload
{
    [self setRotatingDialContainerView:nil];
    [self setRotatingDialView:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Private Methods


// this method takes touch interaction points and rotates the dial container to match the movement
- (void)trackTouchPoint:(CGPoint)point inView:(UIView*)view
{    
    CGPoint normalizedPoint = [self normalizedPoint:point inView:view];
    
    CGFloat angleBetweenInitalTouchAndCenter = atan2f(_lastPoint.y, _lastPoint.x);
    CGFloat angleBetweenCurrerntTouchAndCenter = atan2f(normalizedPoint.y, normalizedPoint.x);
    CGFloat rotationAngle = angleBetweenCurrerntTouchAndCenter - angleBetweenInitalTouchAndCenter;
    
    _rotatingDialContainerView.transform = CGAffineTransformRotate(_rotatingDialContainerView.transform, rotationAngle);
    
    _velocity = rotationAngle;
    _lastPoint = normalizedPoint;
}


// the point we are provided is based from the top-left corner of the view instead of from the center.
// this offsets the positions to make the point based off the center of the view
- (CGPoint)normalizedPoint:(CGPoint)point inView:(UIView *)view
{
    return CGPointMake(point.x - view.bounds.size.width * .5, point.y - view.bounds.size.height * .5);
}



- (void)beginDeceleration
{
    NSLog(@"begin deceleration with velocity: %.2f", _velocity);
    [_decelerationTimer invalidate];
    
    self.decelerationTimer = [NSTimer scheduledTimerWithTimeInterval:.03f target:self selector:@selector(handleDecelerateTick) userInfo:nil repeats:YES];
}


- (void)endDeceleration
{
    NSLog(@"stop deceleration");
    
    [_decelerationTimer invalidate];
    self.decelerationTimer = nil;
    
    _velocity = 0;
}


- (void)handleDecelerateTick 
{
    _velocity *= kFriction;
    
    if ( fabsf(_velocity) < .001f) {
        [self endDeceleration];
    }
    else {
        _rotatingDialContainerView.transform = CGAffineTransformRotate(_rotatingDialContainerView.transform, _velocity);
    }
}


#pragma mark - Gesture View Delegate


- (void)gestureView:(GDIDialGestureView *)gv touchBeganAtPoint:(CGPoint)point
{
    NSLog(@"gestureView:touchBeganAtPoint: %@", NSStringFromCGPoint(point));
    
    // reset the last point to where we start from.
    _lastPoint = [self normalizedPoint:point inView:gv];
    
    [self endDeceleration];
    [self trackTouchPoint:point inView:gv];
}


- (void)gestureView:(GDIDialGestureView *)gv touchMovedToPoint:(CGPoint)point
{
//    NSLog(@"gestureView:touchMovedToPoint: %@", NSStringFromCGPoint(point));    
    
    [self trackTouchPoint:point inView:gv];
}


- (void)gestureView:(GDIDialGestureView *)gv touchEndedAtPoint:(CGPoint)point
{
//    NSLog(@"gestureView:touchEndedAtPoint: %@", NSStringFromCGPoint(point));
    
    [self beginDeceleration];
}


@end
