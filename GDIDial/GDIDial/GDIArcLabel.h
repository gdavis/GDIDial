//
//  GDIArcLabel.h
//  GDIArcLabel
//
//  Created by Grant Davis on 2/9/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDIArcLabel : UILabel

@property (nonatomic) CGFloat radius;

// additional spacing between each letter
@property (nonatomic) CGFloat kerning;


// utility method to calculate how many radians the given text, font, and kerning will need to fit on the given radius
+ (CGFloat)sizeInRadiansOfText:(NSString *)text font:(UIFont *)font radius:(CGFloat)radius kerning:(CGFloat)kern;

// utility method to calculate a cartesian coordinate from a polar coordinate
+ (CGPoint)cartesianCoordinateFromPolarWithRadius:(CGFloat)radius radians:(CGFloat)radians;

// method to generate an attributed string for use with CoreText from an NSString and UIFont
+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text font:(UIFont *)font;

@end
