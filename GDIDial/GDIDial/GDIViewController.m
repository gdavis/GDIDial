//
//  GDIViewController.m
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDIViewController.h"
#import "GDICurvedLabel.h"

#define kDialRadius 160.f

@implementation GDIViewController
@synthesize currentSliceLabel = _currentSliceLabel;
@synthesize selectedSliceLabel = _selectedSliceLabel;
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
    dialViewController.dialRegistrationViewRadius = 110.f;
    [self.view insertSubview:dialViewController.view atIndex:0];
}

- (void)viewDidUnload
{
    [self setCurrentSliceLabel:nil];
    [self setSelectedSliceLabel:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - GDIDialViewControllerDelegate Methods


- (void)dialViewController:(GDIDialViewController *)dialVC didRotateToIndex:(NSUInteger)index
{
//    NSLog(@"%@ did rotate to index: %i", dialVC, index); 
    self.currentSliceLabel.text = [NSString stringWithFormat:@"Current slice index: %i", index];
}

- (void)dialViewController:(GDIDialViewController *)dialVC didSelectIndex:(NSUInteger)selectedIndex
{
//    NSLog(@"%@ did select index: %i", dialVC, selectedIndex);
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"Selected slice index: %i", selectedIndex];
}


#pragma mark - GDIDialViewControllerDataSource Methods

- (NSUInteger)numberOfSlicesForDial
{
    return 100;
}

- (GDIDialSlice *)viewForDialSliceAtIndex:(NSUInteger)index
{
    CGFloat width = ((rand() % 50) - 25.f) + 200.f;
    
    GDIDialSlice *slice = [[GDIDialSlice alloc] initWithRadius:kDialRadius width:width];
    
//    slice.backgroundLayer.lineWidth = 1.f;
//    slice.backgroundLayer.strokeColor = [[UIColor redColor] CGColor];
    slice.backgroundLayer.fillColor = [[self randomColor] CGColor];

    slice.label.radius = kDialRadius - 12;
    slice.label.text = [NSString stringWithFormat:@"Dial Slice %i", index];
    
    return slice;
}


- (UIColor *)randomColor {
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:.5];
}



@end
