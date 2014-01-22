//
//  ExpandingCircularMenuDelegate.h
//  ExpandingCircularMenu
//
//  Created by Michael Quan on 2013-10-11.
//  Copyright (c) 2013 Michael Quan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExpandingCircularMenuDelegate <NSObject>

@optional
/**
 * Tells the delegate that the gesture has started hovering over a view with a given index
 *
 * @param view The view that is being hovered over
 * @param index The index of the view in the view list array
 */
- (void)didStartHoveringOverView:(UIView*)view withIndex:(NSInteger)index;

/**
 * Tells the delegate that the gesture has stopped hovering over a view with a given index
 *
 * @param view The view that was being hovered over
 * @param index The index of the view in the view list array
 */
- (void)didStopHoveringOverView:(UIView*)view withIndex:(NSInteger)index;

/**
 * Tells the delegate that the gesture has ended hovering over a view with a given index
 *
 * @param view The view that was being hovered over
 * @param index The index of the view in the view list array
 */
- (void)didEndGestureHoveringOverView:(UIView*)view withIndex:(NSInteger)index;

/**
 * Tells the delegate that the gesture has ended hover over no view
 */
- (void)didEndGestureHoveringOverNoView;

@end
