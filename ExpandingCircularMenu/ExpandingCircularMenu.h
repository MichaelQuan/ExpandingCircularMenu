//
//  ExpandingCircularMenu.h
//  ExpandingCircularMenu
//
//  Created by Michael Quan on 2013-10-11.
//  Copyright (c) 2013 Michael Quan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpandingCircularMenuDelegate.h"
#import "ExpandingCircularMenuLayout.h"
@interface ExpandingCircularMenu : NSObject

@property (nonatomic, weak) id<ExpandingCircularMenuDelegate> delegate;

- (instancetype)initForView:(UIView*)view WithExpandingCircularLayout:(ExpandingCircularMenuLayout*)layout;
- (void)pan:(UIGestureRecognizer*)gesture;
@end
