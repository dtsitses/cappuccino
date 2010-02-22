/*
 * CPBox.j
 * AppKit
 *
 * Created by Dimitris Tsitses.
 * Copyright 2009, Blueberry Associates LLC.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@import <AppKit/CPColor.j>
@import <AppKit/CPImage.j>
@import <AppKit/CPTextField.j>
@import <AppKit/CPView.j>

#include "CoreGraphics/CGGeometry.h"


/*
    The box has no title.
    @global
    @group CPTitlePosition
*/
CPNoTitle     = 0;
/*
    Title positioned above the box’s top border.
    @global
    @group CPTitlePosition
*/
//CPAboveTop    = 1;
/*
    Title positioned within the box’s top border.
    @global
    @group CPTitlePosition
*/
CPAtTop       = 2;
/*
    Title positioned below the box’s top border.
    @global
    @group CPTitlePosition
*/
//CPBelowTop    = 3;
/*
    Title positioned above the box’s bottom border.
    @global
    @group CPTitlePosition
*/
//CPAboveBottom = 4;
/*
    Title positioned within the box’s bottom border.
    @global
    @group CPTitlePosition
*/
//CPAtBottom    = 5;
/*
    Title positioned below the box’s bottom border.
    @global
    @group CPTitlePosition
*/
//CPBelowBottom = 6;


/*
    Specifies the primary box appearance. This is the default box type.
    @global
    @group CPBoxType
*/
CPBoxPrimary   = 0;
/*
    Specifies the secondary box appearance.
    @global
    @group CPBoxType
*/
//CPBoxSecondary = 1;
/*
    Specifies that the box is a separator.
    @global
    @group CPBoxType
*/
//CPBoxSeparator = 2;
/*
    Specifies that the box is a Mac OS X v10.2–style box.
    @global
    @group CPBoxType
*/
CPBoxOldStyle  = 3;
/*
    Specifies that the appearance of the box is determined entirely by the by box-configuration methods, without automatically applying Cappuccino UI guidelines. 
    @global
    @group CPBoxType
*/
//CPBoxCustom    = 4;


var CPBoxPrimaryBezelBackgroundColor  = nil,
    CPBoxOldStyleBezelBackgroundColor = nil;

var PRIMARY_LEFT_INSET    = 7.0,
    PRIMARY_RIGHT_INSET   = 7.0,
    PRIMARY_TOP_INSET     = 7.0,
    PRIMARY_BOTTOM_INSET  = 7.0,
    
    OLDSTYLE_LEFT_INSET   = 7.0,
    OLDSTYLE_RIGHT_INSET  = 7.0,
    OLDSTYLE_TOP_INSET    = 1.0,
    OLDSTYLE_BOTTOM_INSET = 1.0;
    
/*! 
    @ingroup appkit
    @class CPBox

    A CPBox object is a view that draws a line around its rectangular bounds and that displays a title
    on or near the line (or might display neither line nor title). A CPBox also has a content view to
    which other views can be added; it thus offers a way for an application to group related views.
*/
@implementation CPBox : CPView
{
    _CPBoxTitle       _titleView;
    CPTextField       _titleField;
    CPString          _titleFromNib;
    
    CPView            _contentView;
    CPView            _backgroundView;
    
    CPBoxType         _boxType;
    
    CPTitlePosition   _titlePosition;
}

/*
    @ignore
*/
+ (void)initialize
{
    if (self != CPBox)
        return;
    
    var bundle = [CPBundle bundleForClass:self],

        // for CPBoxPrimary
        primaryBezelTopLeftImage     = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxPrimaryBezelTopLeft.png"] size:CGSizeMake(7.0, 7.0)],
        primaryBezelTopImage         = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxPrimaryBezelTop.png"] size:CGSizeMake(1.0, 7.0)],
        primaryBezelTopRightImage    = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxPrimaryBezelTopRight.png"] size:CGSizeMake(7.0, 7.0)],
        
        primaryBezelLeftImage        = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxPrimaryBezelLeft.png"] size:CGSizeMake(7.0, 1.0)],
        primaryBackgroundImage       = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxPrimaryBackgroundCenter.png"] size:CGSizeMake(1.0, 1.0)],
        primaryBezelRightImage       = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxPrimaryBezelRight.png"] size:CGSizeMake(7.0, 1.0)],

        primaryBezelBottomLeftImage  = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxPrimaryBezelBottomLeft.png"] size:CGSizeMake(7.0, 7.0)],
        primaryBezelBottomImage      = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxPrimaryBezelBottom.png"] size:CGSizeMake(1.0, 7.0)],
        primaryBezelBottomRightImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxPrimaryBezelBottomRight.png"] size:CGSizeMake(7.0, 7.0)],
        
        // for CPBoxOldStyle
        oldStyleBezerImage           = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxOldStyleBezel.png"] size:CGSizeMake(1.0, 1.0)],
        
        oldStyleBezelLeftImage       = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxOldStyleBezelLeft.png"] size:CGSizeMake(7.0, 1.0)],
        oldStyleBackgroundImage      = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxOldStyleBackgroundCenter.png"] size:CGSizeMake(1.0, 1.0)],
        oldStyleBezelRightImage      = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPBox/CPBoxOldStyleBezelRight.png"] size:CGSizeMake(7.0, 1.0)];
       
    CPBoxPrimaryBezelBackgroundColor = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:
        [
            primaryBezelTopLeftImage,
            primaryBezelTopImage,
            primaryBezelTopRightImage,
            
            primaryBezelLeftImage,
            primaryBackgroundImage,
            primaryBezelRightImage,

            primaryBezelBottomLeftImage,
            primaryBezelBottomImage,
            primaryBezelBottomRightImage
        ]]];       
            
    CPBoxOldStyleBezelBackgroundColor = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:
        [
            oldStyleBezelLeftImage,
            oldStyleBezerImage,
            oldStyleBezelRightImage,
            
            oldStyleBezelLeftImage,
            oldStyleBackgroundImage,
            oldStyleBezelRightImage,

            oldStyleBezelLeftImage,
            oldStyleBezerImage,
            oldStyleBezelRightImage
        ]]];
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        _boxType = CPBoxPrimary;
        _titlePosition = CPAtTop;
        
        [self _createSubviews];
    }
    
    return self;
}

- (void)viewDidMoveToWindow
{
    // only these box types are supported at the moment
    if (_boxType != CPBoxPrimary && _boxType != CPBoxOldStyle)
        return;

    // only these title positions are supported at the moment
    if (_titlePosition != CPAtTop && _titlePosition != CPNoTitle)
        return;
        
    [self _layoutSubviews];
}

/* @ignore */
- (void)_createSubviews
{
    var bounds = [self bounds];
    
    _titleView = [[_CPBoxTitle alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(bounds), 0.0)];
    [_titleView setAutoresizingMask:CPViewWidthSizable];
    [self addSubview:_titleView];
    _titleField = [_titleView titleField];
    [_titleField setStringValue:_titleFromNib];
    
    _backgroundView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
    [_backgroundView setBackgroundColor:(_boxType == CPBoxPrimary) ? CPBoxPrimaryBezelBackgroundColor : CPBoxOldStyleBezelBackgroundColor];
    [_backgroundView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [self addSubview:_backgroundView];
    
    _contentView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
    [self addSubview:_contentView];
}

/* @ignore */
- (void)_layoutSubviews
{
    var backgroundRect = [self bounds],
        labelViewHeight = (_titlePosition != CPNoTitle) ? [_CPBoxTitle height] : 0;
        
    backgroundRect.origin.y += labelViewHeight;
    backgroundRect.size.height -= labelViewHeight;
    [_backgroundView setFrame:backgroundRect];
    
    [_contentView setFrame:[self contentRect]];
}

/*!
    Returns the content rectangle.
*/
- (CGRect)contentRect
{
    var contentRect = [self bounds],
        labelViewHeight = (_titlePosition != CPNoTitle) ? [_CPBoxTitle height] : 0;
    
    if(_boxType == CPBoxPrimary)
    {
        contentRect.origin.y += labelViewHeight + PRIMARY_TOP_INSET;
        contentRect.size.height -= labelViewHeight + PRIMARY_TOP_INSET + PRIMARY_BOTTOM_INSET;
    
        contentRect.origin.x += PRIMARY_LEFT_INSET;
        contentRect.size.width -= PRIMARY_LEFT_INSET + PRIMARY_RIGHT_INSET;
    }
    else
    {
        contentRect.origin.y += labelViewHeight + OLDSTYLE_TOP_INSET;
        contentRect.size.height -= labelViewHeight + OLDSTYLE_TOP_INSET + OLDSTYLE_BOTTOM_INSET;
    
        contentRect.origin.x += OLDSTYLE_LEFT_INSET;
        contentRect.size.width -= OLDSTYLE_LEFT_INSET + OLDSTYLE_RIGHT_INSET;
    }

    return contentRect;
}

/*!
    Returns the receiver’s box type.
*/
- (CPBoxType)boxType
{
    return _boxType;
}

/*!
    Sets the box type.
    @param aBoxType A constant describing the type of box; this must be a valid box type. These constants are described in CPBoxType.
*/
- (void)setBoxType:(CPBoxType)aBoxType
{
    _boxType = aBoxType;
    
    [_backgroundView setBackgroundColor:(_boxType == CPBoxPrimary) ? CPBoxPrimaryBezelBackgroundColor : CPBoxOldStyleBezelBackgroundColor];
    
    [self _layoutSubviews];
}

/*!
    Returns the contentView of the box.
*/
- (CPView)contentView
{
    return _contentView;
}

/*!
    Sets the content view of the box. The view passed as an argument to this method will be resized to fit the box's bounds
    @param aView the view that will be displayed inside for the box
*/
- (void)setContentView:(CPView)aView
{
    if(_contentView === aView)
        return;

    [_contentView removeFromSuperview];
    
    if(!aView)
        aView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
    
    _contentView = aView;
    [self addSubview:_contentView];
    [self _layoutSubviews];
}

/*!
    Returns the title of the box.
*/
- (CPString)title
{
    return [_titleField stringValue];
}

/*!
    Sets the title of the box.
    @param aTitle the new title for the box
*/
- (void)setTitle:(CPString)aTitle
{
    [_titleField setStringValue:aTitle];
}

/*!
    Returns the font object used to draw the box’s title.
*/
- (CPString)titleFont
{
    return [_titleField font];
}

/*!
    Sets the font object used to draw the box’s title.
    @param aFont The CPFont object used to draw the box's title
*/
- (void)setTitleFont:(CPFont)aFont
{
    [_titleField setFont:aFont];
}

/*!
    Returns a constant representing the title position.
*/
- (CPTitlePosition)titlePosition
{
    return _titlePosition;
}

/*!
    Sets the position of the box's title.
    @param aPosition A constant describing the position of the box's title. These constants are described in CPTitlePosition. The default position is CPAtTop.
*/
- (void)setTitlePosition:(CPTitlePosition)aPosition
{
    _titlePosition = aPosition;
    
    [self _layoutSubviews];
}


@end

var CPBoxTypeKey         = "CPBoxTypeKey",
    CPTitlePositionKey   = "CPTitlePositionKey",
    CPTitleCellKey       = "CPTitleCellKey",
    CPContentViewKey     = "CPContentViewKey",
    BoxTitle             = "BoxTitle";
        
@implementation CPBox (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        _boxType       = [aCoder decodeIntForKey:CPBoxTypeKey];
        _titlePosition = [aCoder decodeIntForKey:CPTitlePositionKey];
        _titleFromNib  = [aCoder decodeObjectForKey:BoxTitle];
        
        [self _createSubviews];
        
        [self setContentView:[aCoder decodeObjectForKey:CPContentViewKey]];
    }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInt:_boxType         forKey:CPBoxTypeKey];
    [aCoder encodeInt:_titlePosition   forKey:CPTitlePositionKey];
    [aCoder encodeObject:_titleField   forKey:CPTitleCellKey];
    [aCoder encodeObject:_contentView  forKey:CPContentViewKey];
    [aCoder encodeObject:_titleFromNib forKey:BoxTitle];
}

@end



var _CPBoxTitleViewHeight = 25.0;

/* @ignore */
@implementation _CPBoxTitle : CPView
{
    CPTextField     _titleField;
}

+ (void)initialize
{
    if (self != [_CPBoxTitle class])
        return;
        
    // nothing to initialize yet
}

+ (float)height
{
    return _CPBoxTitleViewHeight;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {   
        [self setFrameSize:CGSizeMake(CGRectGetWidth(aFrame), _CPBoxTitleViewHeight)];
    
        _titleField = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
        [_titleField setAlignment:CPLeftTextAlignment];
        [_titleField setFrame:CGRectMake(PRIMARY_LEFT_INSET - 2, 5.0, CGRectGetWidth(aFrame), 15.0)];
        [_titleField setAutoresizingMask:CPViewWidthSizable];
        [_titleField setFont:[CPFont systemFontOfSize:11.0]];
        [self addSubview:_titleField];
    }
    
    return self;
}

- (CPTextField)titleField
{
    return _titleField;
}

- (void)setTitleField:(CPTextField)aTitleField
{
    _titleField = aTitleField;
}

@end
