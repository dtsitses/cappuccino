/*
 * CPToolbarItem.j
 * AppKit
 *
 * Created by Francisco Tolmasky.
 * Copyright 2008, 280 North, Inc.
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

@import <AppKit/CPImage.j>
@import <AppKit/CPView.j>


/*
    @global
    @class CPToolbarItem
*/
CPToolbarItemVisibilityPriorityStandard = 0;
/*
    @global
    @class CPToolbarItem
*/
CPToolbarItemVisibilityPriorityLow      = -1000;
/*
    @global
    @class CPToolbarItem
*/
CPToolbarItemVisibilityPriorityHigh     = 1000;
/*
    @global
    @class CPToolbarItem
*/
CPToolbarItemVisibilityPriorityUser     = 2000;

CPToolbarSeparatorItemIdentifier        = @"CPToolbarSeparatorItemIdentifier";
CPToolbarSpaceItemIdentifier            = @"CPToolbarSpaceItemIdentifier";
CPToolbarFlexibleSpaceItemIdentifier    = @"CPToolbarFlexibleSpaceItemIdentifier";
CPToolbarShowColorsItemIdentifier       = @"CPToolbarShowColorsItemIdentifier";
CPToolbarShowFontsItemIdentifier        = @"CPToolbarShowFontsItemIdentifier";
CPToolbarCustomizeToolbarItemIdentifier = @"CPToolbarCustomizeToolbarItemIdentifier";
CPToolbarPrintItemIdentifier            = @"CPToolbarPrintItemIdentifier";

/*! 
    @ingroup appkit
    @class CPToolbarItem

    A representation of an item in a CPToolbar.
*/
@implementation CPToolbarItem : CPObject
{
    CPString    _itemIdentifier;
    
    CPToolbar   _toolbar;
    
    CPString    _label;
    CPString    _paletteLabel;
    CPString    _toolTip;
    int         _tag;
    id          _target;
    SEL         _action;
    BOOL        _isEnabled;
    CPImage     _image;
    CPImage     _alternateImage;
    
    CPView      _view;
    
    CGSize      _minSize;
    CGSize      _maxSize;    
    
    int         _visibilityPriority;

    BOOL        _autovalidates;
}

- (id)init
{
    return [self initWithItemIdentifier:@""];
}

// Creating a Toolbar Item
/*!
    Initializes the toolbar item with a specified identifier.
    @param anItemIdentifier the item's identifier
    @return the initialized toolbar item
*/
- (id)initWithItemIdentifier:(CPString)anItemIdentifier
{
    self = [super init];
    
    if (self)
    {
        _itemIdentifier = anItemIdentifier;
     
        _tag = 0;
        _isEnabled = YES;
     
        _minSize = CGSizeMakeZero();
        _maxSize = CGSizeMakeZero();
     
        _visibilityPriority = CPToolbarItemVisibilityPriorityStandard;
    }
    
    return self;
}

// Managing Attributes
/*!
    Returns the item's identifier.
*/
- (CPString)itemIdentifier
{
    return _itemIdentifier;
}

/*!
    Returns the toolbar of which this item is a part.
*/
- (CPToolbar)toolbar
{
    return _toolbar;
}

/* @ignore */
- (void)_setToolbar:(CPToolbar)aToolbar
{
    _toolbar = aToolbar;
}

/*!
    Returns the item's label
*/
- (CPString)label
{
    return _label;
}

/*!
    Sets the item's label.
    @param aLabel the new label for the item
*/
- (void)setLabel:(CPString)aLabel
{
    _label = aLabel;
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns the palette label.
*/
- (CPString)paletteLabel
{
    return _paletteLabel;
}

/*!
    Sets the palette label
    @param aPaletteLabel the new palette label
*/
- (void)setPaletteLabel:(CPString)aPaletteLabel
{
    _paletteLabel = aPaletteLabel;
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns the item's tooltip. A tooltip pops up
    next to the cursor when the user hovers over
    the item with the mouse.
*/
- (CPString)toolTip
{
    if ([_view respondsToSelector:@selector(toolTip)])
        return [_view toolTip];
    
    return _toolTip;
}

/*!
    Sets the item's tooltip. A tooltip pops up next to the cursor when the user hovers over the item with the mouse.
    @param aToolTip the new item tool tip
*/
- (void)setToolTip:(CPString)aToolTip
{
    if ([_view respondsToSelector:@selector(setToolTip:)])
        [view setToolTip:aToolTip];
    
    _toolTip = aToolTip;
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns the item's tag.
*/
- (int)tag
{
    if ([_view respondsToSelector:@selector(tag)])
        return [_view tag];
    
    return _tag;
}

/*!
    Sets the item's tag.
    @param aTag the new tag for the item
*/
- (void)setTag:(int)aTag
{
    if ([_view respondsToSelector:@selector(setTag:)])
        [_view setTag:aTag];
    
    _tag = aTag;
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns the item's action target.
*/
- (id)target
{
    if (_view)
        return [_view respondsToSelector:@selector(target)] ? [_view target] : nil;
    
    return _target;
}

/*!
    Sets the target of the action that is triggered when the user clicks this item. \c nil will cause 
    the action to be passed on to the first responder.
    @param aTarget the new target
*/
- (void)setTarget:(id)aTarget
{
    if (!_view)
        _target = aTarget;
    
    else if ([_view respondsToSelector:@selector(setTarget:)])
        [_view setTarget:aTarget];
        
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns the action that is triggered when the user clicks this item.
*/
- (SEL)action
{
    if (_view)
        return [_view respondsToSelector:@selector(action)] ? [_view action] : nil;
    
    return _action;
}

/*!
    Sets the action that is triggered when the user clicks this item.
    @param anAction the new action
*/
- (void)setAction:(SEL)anAction
{
    if (!_view)
        _action = anAction;

    else if ([_view respondsToSelector:@selector(setAction:)])
        [_view setAction:anAction];
        
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns \c YES if the item is enabled.
*/
- (BOOL)isEnabled
{
    if ([_view respondsToSelector:@selector(isEnabled)])
        return [_view isEnabled];
    
    return _isEnabled;
}

/*!
    Sets whether the item is enabled.
    @param aFlag \c YES enables the item
*/
- (void)setEnabled:(BOOL)shouldBeEnabled
{
    if ([_view respondsToSelector:@selector(setEnabled:)])
        [_view setEnabled:shouldBeEnabled];
    
    _isEnabled = shouldBeEnabled;
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns the item's image
*/
- (CPImage)image
{
    if ([_view respondsToSelector:@selector(image)])
        return [_view image];
        
    return _image;
}

/*!
    Sets the item's image.
    @param anImage the new item image
*/
- (void)setImage:(CPImage)anImage
{
    if ([_view respondsToSelector:@selector(setImage:)])
        [_view setImage:anImage];

    _image = anImage;
    
    if (!_image)
    {
        if(_toolbar)
            [_toolbar toolbarItemDidChange:self];
            
        return;
    }
    
    if (_minSize.width == 0 && _minSize.height == 0 && 
        _maxSize.width == 0 && _maxSize.height == 0)
    {
        var imageSize = [_image size];

        if (imageSize.width > 0 || imageSize.height > 0)
        {
            [self setMinSize:imageSize];
            [self setMaxSize:imageSize];
        }
    }
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Sets the alternate image. This image is displayed on the item when the user is clicking it.
    @param anImage the new alternate image
*/
- (void)setAlternateImage:(CPImage)anImage
{
    if ([_view respondsToSelector:@selector(setAlternateImage:)])
        [_view setAlternateImage:anImage];
    
    _alternateImage = anImage;
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns the alternate image. This image is displayed on the item when the user is clicking it.
*/
- (CPImage)alternateImage
{
    if ([_view respondsToSelector:@selector(alternateIamge)])
        return [_view alternateImage];
    
    return _alternateImage;
}

/*!
    Returns the item's view.
*/
- (CPView)view
{
    return _view;
}

/*!
    Sets the item's view
    @param aView the item's new view
*/
- (void)setView:(CPView)aView
{
    if (_view == aView)
        return;
    
    _view = aView;

    if (_view)
    {
        // Tags get forwarded.
        if (_tag !== 0 && [_view respondsToSelector:@selector(setTag:)])
            [_view setTag:_tag];
        
        _target = nil;
        _action = nil;
    }
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns the item's minimum size.
*/
- (CGSize)minSize
{
    return _minSize;
}

/*!
    Sets the item's minimum size.
    @param aMinSize the new minimum size
*/
- (void)setMinSize:(CGSize)aMinSize
{
    if(!aMinSize.height || !aMinSize.width)
        return;

    _minSize = CGSizeMakeCopy(aMinSize);
    
    // Try to provide some sanity: Make maxSize >= minSize
    _maxSize = CGSizeMake(MAX(_minSize.width, _maxSize.width), MAX(_minSize.height, _maxSize.height));
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

/*!
    Returns the item's maximum size.
*/
- (CGSize)maxSize
{
    return _maxSize;
}

/*!
    Sets the item's new maximum size.
    @param aMaxSize the new maximum size
*/
- (void)setMaxSize:(CGSize)aMaxSize
{
    if(!aMaxSize.height || !aMaxSize.width)
        return;
        
    _maxSize = CGSizeMakeCopy(aMaxSize);
    
    // Try to provide some sanity: Make minSize <= maxSize
    _minSize = CGSizeMake(MIN(_minSize.width, _maxSize.width), MIN(_minSize.height, _maxSize.height));
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

// Visibility Priority
/*!
    Returns the item's visibility priority. The value will be one of:
<pre>
CPToolbarItemVisibilityPriorityStandard
CPToolbarItemVisibilityPriorityLow
CPToolbarItemVisibilityPriorityHigh
CPToolbarItemVisibilityPriorityUser
</pre>
*/
- (int)visibilityPriority
{
    return _visibilityPriority;
}

/*!
    Sets the item's visibility priority. The value must be one of:
<pre>
CPToolbarItemVisibilityPriorityStandard
CPToolbarItemVisibilityPriorityLow
CPToolbarItemVisibilityPriorityHigh
CPToolbarItemVisibilityPriorityUser
</pre>
    @param aVisiblityPriority the priority
*/
- (void)setVisibilityPriority:(int)aVisibilityPriority
{
    _visibilityPriority = aVisibilityPriority;
    
    if(_toolbar)
        [_toolbar toolbarItemDidChange:self];
}

- (void)validate
{
    var action = [self action],
        target = [self target];

    // View items do not do any target-action analysis.
    if (_view)
    {
        if ([target respondsToSelector:@selector(validateToolbarItem:)])
            [self setEnabled:[target validateToolbarItem:self]];

        return;
    }

    if (!action)
        return [self setEnabled:NO];

    if (target && ![target respondsToSelector:action])
        return [self setEnabled:NO];

    target = [CPApp targetForAction:action to:target from:self];

    if (!target)
        return [self setEnabled:NO];

    if ([target respondsToSelector:@selector(validateToolbarItem:)])
        [self setEnabled:[target validateToolbarItem:self]];
    else
        [self setEnabled:YES];
}

- (BOOL)autovalidates
{
    return _autovalidates;
}

- (void)setAutovalidates:(BOOL)shouldAutovalidate
{
    _autovalidates = !!shouldAutovalidate;
}

@end

@implementation CPToolbarItem (CPCopying)

- (id)copy
{
    var copy = [[[self class] alloc] initWithItemIdentifier:_itemIdentifier];
    
    if (_view)
        [copy setView:[CPKeyedUnarchiver unarchiveObjectWithData:[CPKeyedArchiver archivedDataWithRootObject:_view]]];
    
    [copy _setToolbar:_toolbar];
    
    [copy setLabel:_label];
    [copy setPaletteLabel:_paletteLabel];
    [copy setToolTip:[self toolTip]];

    [copy setTag:[self tag]];
    [copy setTarget:[self target]];
    [copy setAction:[self action]];
    
    [copy setEnabled:[self isEnabled]];

    [copy setImage:[self image]];
    [copy setAlternateImage:[self alternateImage]];

    [copy setMinSize:_minSize];
    [copy setMaxSize:_maxSize];
    
    [copy setVisibilityPriority:_visibilityPriority];
    
    return copy;
}

@end


var CPToolbarItemIdentifierKey          = "CPToolbarItemIdentifierKey",
    CPToolbarItemLabelKey               = "CPToolbarItemLabelKey",
    CPToolbarItemPaletteLabelKey        = "CPToolbarItemPaletteLabelKey",
    CPToolbarItemToolTipKey             = "CPToolbarItemToolTipKey",
    CPToolbarItemTagKey                 = "CPToolbarItemTagKey",
    CPToolbarItemTargetKey              = "CPToolbarItemTargetKey",
    CPToolbarItemActionKey              = "CPToolbarItemActionKey",
    CPToolbarItemEnabledKey             = "CPToolbarItemEnabledKey",
    CPToolbarItemImageKey               = "CPToolbarItemImageKey",
    CPToolbarItemAlternateImageKey      = "CPToolbarItemAlternateImageKey",
    CPToolbarItemViewKey                = "CPToolbarItemViewKey",
    CPToolbarItemMinSizeKey             = "CPToolbarItemMinSizeKey",
    CPToolbarItemMaxSizeKey             = "CPToolbarItemMaxSizeKey",
    CPToolbarItemVisibilityPriorityKey  = "CPToolbarItemVisibilityPriorityKey";
    CPToolbarItemAutovalidatesKey       = "CPToolbarItemAutovalidatesKey";

@implementation CPToolbarItem (CPCoding)

/*
    Initializes the toolbar item by unarchiving data from <code>aCoder</code>.
    @param aCoder the coder containing the archived CPToolbarItem.
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _itemIdentifier             = [aCoder decodeObjectForKey:CPToolbarItemIdentifierKey];
        
        _label                      = [aCoder decodeObjectForKey:CPToolbarItemLabelKey];
        _paletteLabel               = [aCoder decodeObjectForKey:CPToolbarItemPaletteLabelKey];
        _toolTip                    = [aCoder decodeObjectForKey:CPToolbarItemToolTipKey];
        _tag                        = [aCoder decodeIntForKey:CPToolbarItemTagKey];
        _target                     = [aCoder decodeObjectForKey:CPToolbarItemTargetKey];
        _action                     = [aCoder decodeObjectForKey:CPToolbarItemActionKey];
        _isEnabled                  = [aCoder decodeBoolForKey:CPToolbarItemEnabledKey];
        _view                       = [aCoder decodeObjectForKey:CPToolbarItemViewKey];
        _minSize                    = [aCoder decodeSizeForKey:CPToolbarItemMinSizeKey];
        _maxSize                    = [aCoder decodeSizeForKey:CPToolbarItemMaxSizeKey];
        _visibilityPriority         = [aCoder decodeIntForKey:CPToolbarItemVisibilityPriorityKey];
        _autovalidates              = [aCoder decodeBoolForKey:CPToolbarItemAutovalidatesKey];
        
        if(!_minSize.height || !_minSize.width)
            _minSize = CGSizeMakeZero();

        if(!_maxSize.height || !_maxSize.width)
            _maxSize = CGSizeMakeZero();
        
        [self setImage:             [aCoder decodeObjectForKey:CPToolbarItemImageKey]];
//      [self setAlternateImage:    [aCoder decodeObjectForKey:CPToolbarItemAlternateImageKey]];   // no altImage in Nib
    }
    
    return self;
}

/*
    Archives this toolbar item into the provided coder.
    @param aCoder the coder to which the toolbar item's instance data will be written.
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_itemIdentifier  forKey:CPToolbarItemIdentifierKey];
    
    [aCoder encodeObject:_label           forKey:CPToolbarItemLabelKey];
    [aCoder encodeObject:_paletteLabel    forKey:CPToolbarItemPaletteLabelKey];
    [aCoder encodeObject:_toolTip         forKey:CPToolbarItemToolTipKey];
    [aCoder encodeInt:_tag                forKey:CPToolbarItemTagKey];
    [aCoder encodeBool:_isEnabled         forKey:CPToolbarItemEnabledKey];
    [aCoder encodeObject:_view            forKey:CPToolbarItemViewKey];    
    [aCoder encodeSize:_minSize           forKey:CPToolbarItemMinSizeKey];
    [aCoder encodeSize:_maxSize           forKey:CPToolbarItemMaxSizeKey];
    [aCoder encodeInt:_visibilityPriority forKey:CPToolbarItemVisibilityPriorityKey];
    [aCoder encodeBool:_autovalidates     forKey:CPToolbarItemAutovalidatesKey];
    
    [aCoder encodeObject:_image           forKey:CPToolbarItemImageKey];
//  [aCoder encodeObject:_alternateImage  forKey:CPToolbarItemAlternateImageKey];                  // no altImage in IB

}

@end


// Standard toolbar identifiers

@implementation CPToolbarItem (Standard)

/* @ignore */
+ (CPToolbarItem)_standardItemWithItemIdentifier:(CPString)anItemIdentifier
{
    var item = [[CPToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];                                                        

    switch (anItemIdentifier)
    {
        case CPToolbarSeparatorItemIdentifier:          [item setMinSize:CGSizeMake(2.0, 0.0)];
                                                        [item setMaxSize:CGSizeMake(2.0, 100000.0)];
                                                        
                                                        return item;

        case CPToolbarSpaceItemIdentifier:              [item setMinSize:CGSizeMake(32.0, 32.0)];
                                                        [item setMaxSize:CGSizeMake(32.0, 32.0)];
                                                        
                                                        return item;
                                                        
        case CPToolbarFlexibleSpaceItemIdentifier:      [item setMinSize:CGSizeMake(32.0, 32.0)];
                                                        [item setMaxSize:CGSizeMake(10000.0, 32.0)];
                                                        
                                                        return item;
                                                        
        case CPToolbarShowColorsItemIdentifier:         return nil;
        case CPToolbarShowFontsItemIdentifier:          return nil;
        case CPToolbarCustomizeToolbarItemIdentifier:   return nil;
        case CPToolbarPrintItemIdentifier:              return nil;
    }
    
    return nil;
}

@end
