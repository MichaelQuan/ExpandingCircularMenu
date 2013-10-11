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
- (void)didStartHoveringOverView:(UIView*)view withIndex:(NSInteger)index;
- (void)didStopHoveringOverView:(UIView*)view withIndex:(NSInteger)index;
- (void)didEndGestureHoveringOverView:(UIView*)view withIndex:(NSInteger)index;
- (void)didEndGestureHoveringOverNoView;

@end
