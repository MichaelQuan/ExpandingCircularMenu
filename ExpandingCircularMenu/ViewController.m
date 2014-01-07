//
//  ViewController.m
//  ExpandingCircularMenu
//
//  Created by Michael Quan on 2013-10-10.
//  Copyright (c) 2013 Michael Quan. All rights reserved.
//

#import "ViewController.h"
#import "ExpandingCircularMenuLayout.h"
#import "ExpandingCircularMenu.h"

@interface ViewController() {
    ExpandingCircularMenu *menu;
}

@end

@implementation ViewController

#define size 20

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    ExpandingCircularMenuLayout *layout = [[ExpandingCircularMenuLayout alloc] init];
    NSArray *views = [NSArray new];
    CGRect r = CGRectMake(0,0, size, size);
    for (int i = 0; i < 20; i++) {
        UIView *v = [[UIView alloc] initWithFrame:r];
        [v setBackgroundColor:[UIColor colorWithRed:(arc4random() % 256)/255.0f green:(arc4random() % 256)/255.0f blue:(arc4random() % 256)/255.0f alpha:1]];
        v.layer.cornerRadius = size/2;
        views = [views arrayByAddingObject:v];
    }
    layout.menuViews = views;
    layout.translation = 100;
    layout.hoveredTranslation = 105;
    layout.hoveredScale = 1.2;
    layout.angleSpread = M_PI * 0.333;

    menu = [[ExpandingCircularMenu alloc] initForView:self.view WithExpandingCircularLayout:layout];
    menu.delegate = self;
//    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:menu action:@selector(pan:)];
//    [self.view addGestureRecognizer:pan];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:menu action:@selector(longPress:)];
    [self.view addGestureRecognizer:longPress];
}

#pragma mark -
#pragma mark ExpandingCircularMenuDelegate

- (void)didStartHoveringOverView:(UIView*)view withIndex:(NSInteger)index
{
    NSLog(@"started hovering over %i", index);
}

- (void)didStopHoveringOverView:(UIView*)view withIndex:(NSInteger)index
{
    NSLog(@"ended hovering over %i", index);
}

- (void)didEndGestureHoveringOverView:(UIView*)view withIndex:(NSInteger)index
{
//    NSLog(@"ended on %i", index );
}

- (void)didEndGestureHoveringOverNoView
{
//    NSLog(@"ended over nothing");
}

@end
