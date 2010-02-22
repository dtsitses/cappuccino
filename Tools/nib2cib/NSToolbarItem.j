/*
 * NSToolbarItem.j
 * nib2cib
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

@import <AppKit/CPToolbarItem.j>

var NSToolbarSeparatorItemIdentifier        = @"NSToolbarSeparatorItem",
    NSToolbarSpaceItemIdentifier            = @"NSToolbarSpaceItem",
    NSToolbarFlexibleSpaceItemIdentifier    = @"NSToolbarFlexibleSpaceItem",
    NSToolbarShowColorsItemIdentifier       = @"NSToolbarShowColorsItem",
    NSToolbarShowFontsItemIdentifier        = @"NSToolbarShowFontsItem",
    NSToolbarCustomizeToolbarItemIdentifier = @"NSToolbarCustomizeToolbarItem",
    NSToolbarPrintItemIdentifier            = @"NSToolbarPrintItem";
    

@implementation CPToolbarItem (NSCoding)

- (id)NS_initWithCoder:(CPCoder)aCoder
{
    if (self)
    {   
        _itemIdentifier      = [aCoder decodeObjectForKey:"NSToolbarItemIdentifier"];
        
        // change the NS stardard identifier to the CP equivalent
        switch (_itemIdentifier)
        {
            case NSToolbarSeparatorItemIdentifier:
                _itemIdentifier = CPToolbarSeparatorItemIdentifier;
                break;
	        case NSToolbarSpaceItemIdentifier:
                _itemIdentifier = CPToolbarSpaceItemIdentifier;
                break;
            case NSToolbarFlexibleSpaceItemIdentifier:
                _itemIdentifier = CPToolbarFlexibleSpaceItemIdentifier;
                break;
            case NSToolbarShowColorsItemIdentifier:
                _itemIdentifier = CPToolbarShowColorsItemIdentifier;
                break;
            case NSToolbarShowFontsItemIdentifier:
                _itemIdentifier = CPToolbarShowFontsItemIdentifier;
                break;
            case NSToolbarCustomizeToolbarItemIdentifier:
                _itemIdentifier = CPToolbarCustomizeToolbarItemIdentifier;
                break;
            case NSToolbarPrintItemIdentifier:
                _itemIdentifier = CPToolbarPrintItemIdentifier;
                break;
        }
		
        _label               = [aCoder decodeObjectForKey:"NSToolbarItemLabel"];
        _paletteLabel        = [aCoder decodeObjectForKey:"NSToolbarItemPaletteLabel"];
        _toolTip             = [aCoder decodeObjectForKey:"NSToolbarItemToolTip"];
        _tag                 = [aCoder decodeIntForKey:"NSToolbarItemTag"];
        _target              = [aCoder decodeObjectForKey:"NSToolbarItemTarget"];
        _action              = [aCoder decodeObjectForKey:"NSToolbarItemAction"];
        _isEnabled           = [aCoder decodeBoolForKey:"NSToolbarItemEnabled"];        
        _view                = [aCoder decodeObjectForKey:"NSToolbarItemView"];
        _minSize             = [aCoder decodeObjectForKey:"NSToolbarItemMinSize"];
        _maxSize             = [aCoder decodeObjectForKey:"NSToolbarItemMaxSize"];
        _visibilityPriority  = [aCoder decodeIntForKey:"NSToolbarItemVisibilityPriority"];
        _autovalidates       = [aCoder decodeBoolForKey:"NSToolbarItemAutovalidates"];
        
        _image               = [aCoder decodeObjectForKey:"NSToolbarItemImage"];
//      _alternateImage      = [aCoder decodeObjectForKey:""];                              // no altImage in Nib
    }
    
    return self;
}

@end

@implementation NSToolbarItem : CPToolbarItem
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
    return [self NS_initWithCoder:aCoder];
}

- (Class)classForKeyedArchiver
{
    return [CPToolbarItem class];
}

@end
