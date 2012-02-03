//
//  GDIDialGestureView.h
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDIDialGestureViewDelegate;

@interface GDIDialGestureView : UIView

@property(strong,nonatomic) NSObject<GDIDialGestureViewDelegate> *delegate;

@end


@protocol GDIDialGestureViewDelegate

- (void)gestureView:(GDIDialGestureView *)gv touchBeganAtPoint:(CGPoint)point;
- (void)gestureView:(GDIDialGestureView *)gv touchMovedToPoint:(CGPoint)point;
- (void)gestureView:(GDIDialGestureView *)gv touchEndedAtPoint:(CGPoint)point;

@end