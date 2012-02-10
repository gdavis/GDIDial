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
@property (nonatomic) CGFloat sizeOfTextInRadians;
@property (strong, nonatomic) NSMutableAttributedString *attributedString;
CTFontRef CTFontCreateFromUIFont(UIFont *font);
@end


@implementation GDIArcLabel
@synthesize radius = _radius;
@synthesize kerning = _kerning;

@synthesize sizeOfTextInRadians = _sizeOfTextInRadians;
@synthesize attributedString = _attributedString;

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
    // !END DEBUG!
     */
    
    // set text color
    CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef)_attributedString, CFRangeMake(0, CFAttributedStringGetLength((__bridge CFMutableAttributedStringRef)_attributedString)), kCTForegroundColorAttributeName, self.textColor.CGColor);
    
    // create a line for the text
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFMutableAttributedStringRef)_attributedString);
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
    
    // determine where to start the rotation based on the calculated size of the text
    CGFloat currentRotation = M_PI + ((M_PI - _sizeOfTextInRadians) * .5);
    
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
            
            CGFloat halfKerning = self.kerning * .5;
            
            // get the glyph width
            CGFloat glyphWidth = CTRunGetTypographicBounds(run, glyphRange, NULL, NULL, NULL);
            
            // calculate the radians with our glyph width at the baseline
            CGFloat glyphSizeInRadians = (glyphWidth + halfKerning) / _radius;
            
            // we add kerning at the beginning and end of each character instead of just between for better centering on the arc
            CGFloat halfKerningInRadians = halfKerning / _radius;
            
            // find the x,y position to draw the text
            CGPoint position = [GDIArcLabel cartesianCoordinateFromPolarWithRadius:_radius radians:currentRotation + halfKerningInRadians];
        
            // find the rotation we need to place the baseline of the text on the inside of the arc
            CGFloat rotationAmountAtCenterOfGlyph = ((halfKerningInRadians + currentRotation + glyphSizeInRadians * .5) - M_PI) - M_PI * .5;
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(rotationAmountAtCenterOfGlyph);
            CGContextSetTextMatrix(context, textTransform);
            
            // finally, draw the glyph
            CGContextShowGlyphsAtPoint(context, position.x, position.y, &glyph, 1);
            
            /* 
            // !DEBUG!
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, position.x, position.y);
            CGContextStrokePath(context);
            
            CGPoint centerPosition = [GDIArcLabel cartesianCoordinateFromPolarWithRadius:_radius radians:currentRotation + glyphSizeInRadians * .5];
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, centerPosition.x, centerPosition.y);
            CGContextStrokePath(context);
            
            CGPoint endPosition = [GDIArcLabel cartesianCoordinateFromPolarWithRadius:_radius radians:currentRotation + glyphSizeInRadians];
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, endPosition.x, endPosition.y);
            CGContextStrokePath(context);
            // !END DEBUG!
            */
            
            currentRotation += glyphSizeInRadians + halfKerningInRadians;
        }
    }
    
    CFRelease(ctFont);
    CFRelease(cgFont);
}


#pragma mark - Overrides

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (self.text && self.font) {
        _attributedString = [GDIArcLabel attributedStringWithText:self.text font:self.font];
        _sizeOfTextInRadians = [GDIArcLabel sizeInRadiansOfText:self.text font:self.font radius:_radius kerning:self.kerning];
        [self setNeedsDisplay];
    }
    
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    if (self.text && self.font) {
        _attributedString = [GDIArcLabel attributedStringWithText:self.text font:self.font];
        _sizeOfTextInRadians = [GDIArcLabel sizeInRadiansOfText:self.text font:self.font radius:_radius kerning:self.kerning];
        [self setNeedsDisplay];
    }
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    if (self.text && self.font) {
        _sizeOfTextInRadians = [GDIArcLabel sizeInRadiansOfText:self.text font:self.font radius:_radius kerning:self.kerning];
        [self setNeedsDisplay];
    }
}

- (void)setKerning:(CGFloat)kerning
{
    _kerning = kerning;
    if (self.text && self.font) {
        _sizeOfTextInRadians = [GDIArcLabel sizeInRadiansOfText:self.text font:self.font radius:_radius kerning:self.kerning];
        [self setNeedsDisplay];
    }
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
            
            // get the glyph size
            CGFloat glyphWidth = CTRunGetTypographicBounds(run, glyphRange, NULL, NULL, NULL);
            CGFloat glyphSizeInRadians = (glyphWidth + kern) / radius;
            
            currentRotation += glyphSizeInRadians;
        }
    }
    
    CFRelease(ctFont);
    CFRelease(cgFont);
    
    return currentRotation;
}


@end
