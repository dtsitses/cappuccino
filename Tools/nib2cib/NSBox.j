/*
 * NSBox.j
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

@import <AppKit/CPBox.j>


@implementation CPBox (NSCoding)

- (id)NS_initWithCoder:(CPCoder)aCoder
{
    if (self = [super NS_initWithCoder:aCoder])
    {
        _boxType       = [aCoder decodeIntForKey:@"NSBoxType"];
        _titlePosition = [aCoder decodeIntForKey:@"NSTitlePosition"];
        _contentView   = [aCoder decodeObjectForKey:@"NSContentView"];
       
        var titleCell  = [aCoder decodeObjectForKey:@"NSTitleCell"];        
        _titleFromNib  = [titleCell stringValue];
    }
    
    return self;
}

@end

@implementation NSBox : CPBox
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
    return [self NS_initWithCoder:aCoder];
}

- (Class)classForKeyedArchiver
{
    return [CPBox class];
}

@end
