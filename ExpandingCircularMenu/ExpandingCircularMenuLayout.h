//
//  ExpandingCircularMenuLayout.h
//  ExpandingCircularMenu
//
//  Created by Michael Quan on 2013-10-11.
//  Copyright (c) 2013 Michael Quan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpandingCircularMenuLayout : NSObject

/**
 * views
 */
@property (nonatomic) NSArray *menuViews;

/**
 * the angle spread relative to the expanding angle
 */
@property (nonatomic) CGFloat angleSpread;

/**
 * the amount the views spread out from the center point
 */
@property (nonatomic) CGFloat translation;

@end
