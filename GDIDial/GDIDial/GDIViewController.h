//
//  GDIViewController.h
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDIDialViewController.h"

@interface GDIViewController : UIViewController <GDIDialViewControllerDataSource, GDIDialViewControllerDelegate>

@property(strong,nonatomic) NSArray *dataItems;
- (UIColor *)randomColor;

@end
