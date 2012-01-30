//
//  GDIDialViewController.h
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDIDialGestureView.h"

typedef enum {
    GDIDialPositionTop = 0,
    GDIDialPositionLeft,
    GDIDialPositionRight,
    GDIDialPositionBottom,
} GDIDialPosition;

#define kFriction .9f

@interface GDIDialViewController : UIViewController <GDIDialGestureViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *rotatingDialView;
@property(strong,nonatomic,readonly) GDIDialGestureView *gestureView;
@property(nonatomic) GDIDialPosition dialPosition;
@property(strong, nonatomic) NSNumber *dialRadius;
@property(strong, nonatomic,readonly) NSArray *items;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil items:(NSArray *)items;

@end
