//
//  GDIDialViewController.h
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDIDialGestureView.h"
#import "GDIDialSlice.h"

typedef enum {
    GDIDialPositionTop = 0,
    GDIDialPositionLeft,
    GDIDialPositionRight,
    GDIDialPositionBottom,
} GDIDialPosition;

@protocol GDIDialViewControllerDataSource, GDIDialViewControllerDelegate;

@interface GDIDialViewController : UIViewController <GDIDialGestureViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *rotatingDialView;
@property(strong, nonatomic, readonly) GDIDialGestureView *gestureView;
@property(nonatomic) GDIDialPosition dialPosition;
@property(nonatomic) CGFloat dialRadius;
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
- (void)dialViewController:(GDIDialViewController *)dialVC didSelectIndex:(NSUInteger)selectedIndex;
@end
