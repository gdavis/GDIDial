//
//  GDICurvedLabel.m
//  GDIDial
//
//  Created by Grant Davis on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDICurvedLabel.h"
#import "GDIMath.h"


@interface GDICurvedLabel()

- (CGFloat)textSizeInRadians;

@end


@implementation GDICurvedLabel
@synthesize radius = _radius;
@synthesize radians = _radians;
@synthesize shadowBlur = _shadowBlur;
@synthesize origin = _origin;

- (id)initWithRadius:(CGFloat)radius origin:(CGPoint)originPoint sizeInRadians:(CGFloat)radians
{
    self = [super initWithFrame:CGRectMake(originPoint.x, originPoint.y, radius, radius)];
    if (self) {
        _origin = originPoint;
        _radius = radius;
        _radians = radians;
        self.backgroundColor = [UIColor colorWithRed:1.f green:0.f blue:1.f alpha:.5f];
    }
    return self;
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    self.frame = CGRectMake(_origin.x, _origin.y, radius, radius);
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // shift the coordinate system so we are drawing from the top-left.
    CGContextScaleCTM( context, 1.0, -1.0 );
    
    CGContextSelectFont(context, [self.font.fontName UTF8String], self.font.pointSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetShadowWithColor(context, self.shadowOffset, _shadowBlur, self.shadowColor.CGColor);
    
    int numComponents = CGColorGetNumberOfComponents(self.textColor.CGColor);
    const CGFloat *components = CGColorGetComponents(self.textColor.CGColor);
    if (numComponents == 2) {
        // grayscale color
        CGContextSetRGBFillColor(context, components[0], components[0], components[0], components[1]);
    }
    
    if(numComponents == 4) {
        // rgba color
        CGContextSetRGBFillColor(context, components[0], components[1], components[2], components[3]);
    }
    
    // break the characters into an array so we can draw each character
    NSMutableArray *textCharacters = [NSMutableArray arrayWithCapacity:[self.text length]];
    for (int i=0; i<[self.text length]; i++) {
        [textCharacters addObject: [self.text substringWithRange:NSMakeRange(i, 1)]];
    }
    
    // this line figures out the starting angle for the text
    CGFloat dr = -M_PI*.5 + (_radians * .5 - [self textSizeInRadians] * .5);
    
    for (NSString *string in textCharacters) {
        
        const char *cString = [string UTF8String];
        
        CGSize characterSize = [string sizeWithFont:self.font];
        
        CGFloat rotation = ( characterSize.width + self.font.pointSize * .05) / (_radius + self.font.descender);
        CGPoint characterOrigin = cartesianCoordinateFromPolar((_radius + self.font.descender), dr);     
        
        CGContextSetTextMatrix(context, CGAffineTransformMakeRotation(dr + M_PI*.5));
        CGContextShowTextAtPoint(context, characterOrigin.x, characterOrigin.y, cString, 1);
        
        dr += rotation;
    }
}


- (CGFloat)textSizeInRadians
{
    // break the characters into an array so we can draw each character
    NSMutableArray *textCharacters = [NSMutableArray arrayWithCapacity:[self.text length]];
    for (int i=0; i<[self.text length]; i++) {
        [textCharacters addObject: [self.text substringWithRange:NSMakeRange(i, 1)]];
    }
    
    CGFloat dr = 0.f;
    
    for (int i=0; i<[textCharacters count]; i++) {
        
        NSString *string = [textCharacters objectAtIndex:i];
        CGSize characterSize = [string sizeWithFont:self.font];
        CGFloat rotation = ( characterSize.width + self.font.pointSize * .05) / (_radius + self.font.descender);
        
        dr += rotation;
    }
    
    return dr;
}


@end
