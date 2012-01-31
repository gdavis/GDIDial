//
//  GDIDialSlice.m
//  GDIDial
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDIDialSlice.h"

@implementation GDIDialSlice
@synthesize radius = _radius;
@synthesize width = _width;

- (id)initWithRadius:(CGFloat)r width:(CGFloat)width
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _radius = r;
        _width = width;
    }
    return self;
}


- (CGFloat)sizeInRadians
{
    return _width / _radius;
}


@end