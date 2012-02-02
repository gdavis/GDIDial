//
//  GDICurvedLabel.h
//  GDIDial
//
//  Created by Grant Davis on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDICurvedLabel : UILabel

- (id)initWithRadius:(CGFloat)radius origin:(CGPoint)originPoint sizeInRadians:(CGFloat)radians;

@property(nonatomic) CGFloat radius;
@property(nonatomic,readonly) CGFloat radians;
@property(nonatomic) CGFloat shadowBlur;
@property(nonatomic) CGPoint origin;

+ (CGFloat)sizeInRadiansOfText:(NSString *)text font:(UIFont *)font radius:(CGFloat)radius;

@end
