//
//  GDIDialViewController.h
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDITouchProxyView.h"
#import "GDIDialSlice.h"

typedef enum {
    GDIDialPositionTop = 0,
    GDIDialPositionLeft,
    GDIDialPositionRight,
    GDIDialPositionBottom,
} GDIDialPosition;

@protocol GDIDialViewControllerDataSource, GDIDialViewControllerDelegate;

@interface GDIDialViewController : UIViewController <GDITouchProxyViewDelegate>

@property(strong, nonatomic) IBOutlet UIView *rotatingDialView;
@property(strong, nonatomic) IBOutlet UIView *dialRegistrationView;

@property(strong, nonatomic, readonly) GDITouchProxyView *gestureView;
@property(nonatomic) GDIDialPosition dialPosition;
@property(nonatomic) CGFloat dialRadius;
@property(nonatomic) CGFloat dialRegistrationViewRadius;
@property(strong, nonatomic) NSObject<GDIDialViewControllerDataSource> *dataSource;
@property(strong, nonatomic) NSObject<GDIDialViewControllerDelegate> *delegate;
@property(nonatomic) NSUInteger currentIndex;
@property(nonatomic) CGFloat friction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataSource:(NSObject<GDIDialViewControllerDataSource>*)dataSource;

- (NSArray *)visibleSlices;

@end


@protocol GDIDialViewControllerDataSource
@required
- (NSUInteger)numberOfSlicesForDial;
- (GDIDialSlice *)viewForDialSliceAtIndex:(NSUInteger)index;

@end

@protocol GDIDialViewControllerDelegate
@optional
- (void)dialViewController:(GDIDialViewController *)dialVC didRotateToIndex:(NSUInteger)index;
@required
- (void)dialViewController:(GDIDialViewController *)dialVC didSelectIndex:(NSUInteger)selectedIndex;
@end
