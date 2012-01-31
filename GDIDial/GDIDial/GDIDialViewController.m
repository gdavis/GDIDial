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
@property(strong,nonatomic) UIView *rotatingSlicesContainerView;
@property(nonatomic) CGFloat currentRotation;
@property(nonatomic) CGFloat velocity;
@property(nonatomic) CGPoint lastPoint;
@property(strong,nonatomic) NSTimer *decelerationTimer;
@property(strong,nonatomic) NSMutableArray *visibleSlices;

- (void)buildVisibleSlices;

- (void)beginDeceleration;
- (void)endDeceleration;

- (void)rotateToNearestSlice;
- (void)rotateDialByRadians:(CGFloat)radians;

- (CGPoint)normalizedPoint:(CGPoint)point inView:(UIView *)view;
- (void)trackTouchPoint:(CGPoint)point inView:(UIView*)view;

@end


@implementation GDIDialViewController

@synthesize dialPosition = _dialPosition;
@synthesize dialRadius = _dialRadius;
@synthesize rotatingDialView = _rotatingDialView;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

@synthesize rotatingSlicesContainerView = _rotatingSlicesContainerView;
@synthesize rotatingDialContainerView = _rotatingDialContainerView;
@synthesize gestureView = _gestureView;
@synthesize currentRotation = _currentRotation;
@synthesize velocity = _velocity;
@synthesize lastPoint = _lastPoint;
@synthesize decelerationTimer = _decelerationTimer;
@synthesize visibleSlices = _visibleSlices;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataSource:(NSObject<GDIDialViewControllerDataSource>*)dataSource
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _dataSource = dataSource;
        _dialPosition = GDIDialPositionBottom;
        _dialRadius = 160.f;
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
    
    
    
    // add container for the slices
    _rotatingSlicesContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    [self.view addSubview:_rotatingSlicesContainerView];
    
    
    // create a custom gesture view which tells us when there are touches on the dial
    CGRect gestureViewFrame = CGRectMake(self.view.bounds.size.width * .5 - self.rotatingDialView.frame.size.width * .5, self.view.bounds.size.height * .5 - self.rotatingDialView.frame.size.height * .5, self.rotatingDialView.frame.size.width, self.rotatingDialView.frame.size.height);
    
    _gestureView = [[GDIDialGestureView alloc] initWithFrame:gestureViewFrame dialRadius:_dialRadius];
    _gestureView.delegate = self;
    [self.view addSubview:_gestureView];
    
    [self buildVisibleSlices];
    
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


#pragma mark - Class Methods

- (void)rotateDialToIndex:(NSUInteger)index
{
    
}


- (NSArray *)visibleSlices
{
    return [NSArray arrayWithArray:_visibleSlices];
}


#pragma mark - Private Methods


- (void)buildVisibleSlices
{
    _visibleSlices = [NSMutableArray array];
    
    NSUInteger dl = [_dataSource numberOfSlicesForDial];
    
    
    // we limit our dial to only show half of the dial at a time.
    // this allows us to have an infinite number of slices within the dial
    CGFloat maxRadians = degreesToRadians(180);
    
    
    CGFloat offsetRadians = 0;
    if (_dialPosition == GDIDialPositionBottom) {
        offsetRadians = degreesToRadians(90);
    }
    else if (_dialPosition == GDIDialPositionLeft) {
        offsetRadians = degreesToRadians(180);
    }
    else if (_dialPosition == GDIDialPositionTop) {
        offsetRadians = degreesToRadians(270);
    }
    
    CGFloat totalRadians = 0.f;
    
    for (int i=0; i<dl; i++) {
        
        GDIDialSlice *slice = [_dataSource viewForDialSliceAtIndex:i];
        
        slice.transform = CGAffineTransformMakeRotation( totalRadians + offsetRadians );
        
        [_rotatingSlicesContainerView addSubview:slice];
        [_visibleSlices addObject:slice];
        
        totalRadians -= [slice sizeInRadians];
        
        if (totalRadians <= -maxRadians) {
            break;
        }
    }
}

- (void)rotateToNearestSlice
{
    
}

- (void)rotateDialByRadians:(CGFloat)radians
{
    _currentRotation += radians;
    _rotatingSlicesContainerView.transform = CGAffineTransformRotate(_rotatingDialContainerView.transform, radians);    
    _rotatingDialContainerView.transform = CGAffineTransformRotate(_rotatingDialContainerView.transform, radians);    
}



// this method takes touch interaction points and rotates the dial container to match the movement
- (void)trackTouchPoint:(CGPoint)point inView:(UIView*)view
{    
    CGPoint normalizedPoint = [self normalizedPoint:point inView:view];
    
    CGFloat angleBetweenInitalTouchAndCenter = atan2f(_lastPoint.y, _lastPoint.x);
    CGFloat angleBetweenCurrerntTouchAndCenter = atan2f(normalizedPoint.y, normalizedPoint.x);
    CGFloat rotationAngle = angleBetweenCurrerntTouchAndCenter - angleBetweenInitalTouchAndCenter;
    
    [self rotateDialByRadians:rotationAngle];
    
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
//    NSLog(@"begin deceleration with velocity: %.2f", _velocity);
    [_decelerationTimer invalidate];
    _decelerationTimer = [NSTimer scheduledTimerWithTimeInterval:kDecelerationInterval target:self selector:@selector(handleDecelerateTick) userInfo:nil repeats:YES];
}


- (void)endDeceleration
{
//    NSLog(@"stop deceleration");
    
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
        [self rotateDialByRadians:_velocity];
    }
}


#pragma mark - Gesture View Delegate


- (void)gestureView:(GDIDialGestureView *)gv touchBeganAtPoint:(CGPoint)point
{
//    NSLog(@"gestureView:touchBeganAtPoint: %@", NSStringFromCGPoint(point));
    
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