//
//  ExpandingCircularMenuLayout.m
//  ExpandingCircularMenu
//
//  Created by Michael Quan on 2013-10-11.
//  Copyright (c) 2013 Michael Quan. All rights reserved.
//

#import "ExpandingCircularMenuLayout.h"

@implementation ExpandingCircularMenuLayout

- (instancetype) init
{
    self = [super init];
    if(self) {
        _angleSpread = M_PI_4;
        _translation = 100;
        _hoveredTranslation = 110;
        _hoveredScale = 1.3;
        _menuViews = [NSArray new];
        for (int i = 0; i < 5; i++) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [v setBackgroundColor:[UIColor whiteColor]];
            _menuViews = [_menuViews arrayByAddingObject:v];
        }
    }
    return self;
}



@end
