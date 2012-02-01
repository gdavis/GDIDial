//
//  GDIViewController.m
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDIViewController.h"

#define kDialRadius 160.f

@implementation GDIViewController
@synthesize dataItems = _dataItems;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataItems = [NSArray arrayWithObjects:@"One", @"Two", @"Three",@"Four", nil];
    GDIDialViewController *dialViewController = [[GDIDialViewController alloc] initWithNibName:@"GDIDialView" bundle:nil dataSource:self];
    dialViewController.delegate = self;
    dialViewController.dialRadius = kDialRadius;
    dialViewController.dialPosition = GDIDialPositionBottom;
    [self.view addSubview:dialViewController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - GDIDialViewControllerDelegate Methods


- (void)dialViewController:(GDIDialViewController *)dialVC didRotateToIndex:(NSUInteger)index
{
    NSLog(@"%@ did rotate to index: %i", dialVC, index); 
}

- (void)dialViewController:(GDIDialViewController *)dialVC didSelectIndex:(NSUInteger)selectedIndex
{
    NSLog(@"%@ did select index: %i", dialVC, selectedIndex);
}


#pragma mark - GDIDialViewControllerDataSource Methods

- (NSUInteger)numberOfSlicesForDial
{
    return 100;
}

- (GDIDialSlice *)viewForDialSliceAtIndex:(NSUInteger)index
{
    CGFloat width = ((rand() % 50) - 25.f) + 100.f;
    
//    NSLog(@"slice width: %.2f", width );
    GDIDialSlice *slice = [[GDIDialSlice alloc] initWithRadius:kDialRadius width:width];
    
    slice.sliceLayer.fillColor = [[self randomColor] CGColor];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-width*.5, kDialRadius-50, width, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%i", index];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.opaque = NO;
    [slice addSubview:label];
    
    return slice;
}


- (UIColor *)randomColor {
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:.25];
}



@end
