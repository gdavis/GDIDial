//
//  GDIArcLabel.m
//  GDIArcLabel
//
//  Created by Grant Davis on 2/9/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIArcLabel.h"
#import <CoreText/CoreText.h>


@interface GDIArcLabel()
CTFontRef CTFontCreateFromUIFont(UIFont *font);
@end


@implementation GDIArcLabel
@synthesize radius = _radius;
@synthesize kerning = _kerning;

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _radius = 100.f;
        _kerning = 1.f;
    }
    return self;
}


CTFontRef CTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName,
                                            font.pointSize, 
                                            NULL);
    return ctFont;
}


- (void)drawTextInRect:(CGRect)rect
{
    if (self.text == nil || self.font == nil )
        return;
    
    // setup the context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMidX(rect), 0);
    CGContextScaleCTM(context, 1.f, -1.f);
    
    /*
    // !DEBUG! reference point for origin
    CGContextAddEllipseInRect(context, CGRectMake(-5, -5, 10, 10));
    CGContextSetRGBFillColor(context, 1.f, 0.f, 1.f, 1.f);
    CGContextFillPath(context);
    
    // draw the arc for reference
    CGContextAddArc(context, 0, 0, _radius, 0, M_PI*2, 1);
    CGContextSetRGBStrokeColor(context, 1.f, 0.f, 1.f, 1.f);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, -_radius, 0);
    CGContextAddLineToPoint(context, _radius, 0);
    CGContextStrokePath(context);
    */
    
    
    // get the attributed string for our current state
    NSMutableAttributedString *attrString = [GDIArcLabel attributedStringWithText:self.text font:self.font];
    
    // set text color
    CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef)attrString, CFRangeMake(0, CFAttributedStringGetLength((__bridge CFMutableAttributedStringRef)attrString)), kCTForegroundColorAttributeName, self.textColor.CGColor);
    
    // create a line for the text
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFMutableAttributedStringRef)attrString);
    assert(line != NULL);
    
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runArray);
    CFIndex runIndex = 0;
    
    // create fonts for the glyph and apply to the context
    CTFontRef ctFont = CTFontCreateFromUIFont(self.font);
    CGFontRef cgFont = CTFontCopyGraphicsFont(ctFont, NULL);
    CGContextSetFont(context, cgFont);
    CGContextSetFontSize(context, CTFontGetSize(ctFont));
    CGContextSetFillColorWithColor(context, self.textColor.CGColor);
    
    // calculate the final size of the text with our given properties. 
    CGFloat sizeOfTextInRadians = [GDIArcLabel sizeInRadiansOfText:self.text font:self.font radius:_radius kerning:self.kerning];
    
    // determine where to start the rotation based on the calculated size of the text
    CGFloat currentRotation = M_PI + (M_PI * .5 - sizeOfTextInRadians * .5);
    
    // go through the runs of the line and draw
    for (; runIndex < runCount; runIndex++) {
        
        // pull out the current run
        CTRunRef run = CFArrayGetValueAtIndex(runArray, runIndex);
        
        // count the glphs in the run
        CFIndex glyphCount = CTRunGetGlyphCount(run);
        
        // now loop through all the glyphs and draw each
        CFIndex glyphIndex = 0;
        for (; glyphIndex < glyphCount; glyphIndex++) {

            // pull out the glyph
            CFRange glyphRange = CFRangeMake(glyphIndex, 1);    
            
            // get the glyph and its position
            CGGlyph glyph;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            
            // get the glyph size
            CGFloat ascent, descent;
            CGSize glyphSize;
            CGFloat glyphWidth = CTRunGetTypographicBounds(run, glyphRange, &ascent, &descent, NULL);
            glyphSize.width = glyphWidth;
            glyphSize.height = ascent + descent;
            
            CGFloat glyphSizeInRadians = (glyphSize.width + self.kerning) / _radius;
            CGPoint position = [GDIArcLabel cartesianCoordinateFromPolarWithRadius:_radius radians:currentRotation];
        
            CGFloat rotationAmountAtCenterOfGlyph = ((currentRotation + glyphSizeInRadians * .5) - M_PI) - M_PI * .5;
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(rotationAmountAtCenterOfGlyph);
            CGContextSetTextMatrix(context, textTransform);
            CGContextShowGlyphsAtPoint(context, position.x, position.y, &glyph, 1);
            
            currentRotation += glyphSizeInRadians;
        }
    }
    
    CFRelease(ctFont);
    CFRelease(cgFont);
}


- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)setKerning:(CGFloat)kerning
{
    _kerning = kerning;
    [self setNeedsDisplay];
}

#pragma mark - Class Methods

+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text font:(UIFont *)font
{
    assert(text != nil);
    assert(font != nil);
	
	// Create the attributed string
	CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    if (text != nil) {
        CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), (__bridge CFStringRef)text);
    }
    
    CFRange textRange = CFRangeMake(0, CFAttributedStringGetLength(attrString));
    
    // set the font
    CTFontRef ctFont = CTFontCreateFromUIFont(font);
    CFAttributedStringSetAttribute(attrString, textRange, kCTFontAttributeName, ctFont);
    CFRelease(ctFont);
    
    NSMutableAttributedString *nsString = (__bridge NSMutableAttributedString *) attrString;
    return [nsString copy];
}


+ (CGPoint)cartesianCoordinateFromPolarWithRadius:(CGFloat)radius radians:(CGFloat)radians
{
    CGFloat x,y;
    
    x = radius * cosf(radians);
    y = radius * sinf(radians);
    
    return CGPointMake(x, y);
}


+ (CGFloat)sizeInRadiansOfText:(NSString *)text font:(UIFont *)font radius:(CGFloat)radius kerning:(CGFloat)kern
{
    // get the attributed string for our current state
    NSMutableAttributedString *attrString = [GDIArcLabel attributedStringWithText:text font:font];
    
    // create a line for the text
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFMutableAttributedStringRef)attrString);
    assert(line != NULL);
    
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runArray);
    CFIndex runIndex = 0;
    
    // create fonts for the glyph and apply to the context
    CTFontRef ctFont = CTFontCreateFromUIFont(font);
    CGFontRef cgFont = CTFontCopyGraphicsFont(ctFont, NULL);
    
    CGFloat currentRotation = 0;
    
    // go through the runs of the line and draw
    for (; runIndex < runCount; runIndex++) {
        
        // pull out the current run
        CTRunRef run = CFArrayGetValueAtIndex(runArray, runIndex);
        
        // count the glphs in the run
        CFIndex glyphCount = CTRunGetGlyphCount(run);
        
        // now loop through all the glyphs and draw each
        CFIndex glyphIndex = 0;
        for (; glyphIndex < glyphCount; glyphIndex++) {
            
            // pull out the glyph
            CFRange glyphRange = CFRangeMake(glyphIndex, 1);    
            
            // get the glyph and its position
            CGGlyph glyph;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            
            // get the glyph size
            CGFloat ascent, descent;
            CGSize glyphSize;
            CGFloat glyphWidth = CTRunGetTypographicBounds(run, glyphRange, &ascent, &descent, NULL);
            glyphSize.width = glyphWidth;
            glyphSize.height = ascent + descent;
            
            CGFloat glyphSizeInRadians = (glyphSize.width + kern) / radius;
            
            currentRotation += fabsf(glyphSizeInRadians);
        }
    }
    
    CFRelease(ctFont);
    CFRelease(cgFont);
    
    return currentRotation;
}


@end
