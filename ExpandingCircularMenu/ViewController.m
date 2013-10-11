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
        views = [views arrayByAddingObject:v];
    }
    layout.menuViews = views;
    layout.translation = 100;
    layout.hoveredTranslation = 105;
    layout.hoveredScale = 1.2;
    layout.angleSpread = M_PI * 0.333;

    menu = [[ExpandingCircularMenu alloc] initForView:self.view WithExpandingCircularLayout:layout];
    menu.delegate = self;
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:menu action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

#pragma mark -
#pragma mark ExpandingCircularMenuDelegate

- (void)didStartHoveringOverView:(UIView*)view withIndex:(NSInteger)index
{
    
}

- (void)didStopHoveringOverView:(UIView*)view withIndex:(NSInteger)index
{
    
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

//@interface ViewController () {
//    CGPoint initialPoint;
//    BOOL didStart;
//    UIGestureRecognizer *pan;
//    NSArray *views;
//    
//    CGFloat angle;
//    
//    CGPoint baseVector;
//    CGFloat baseAngle;
//    
//    __block BOOL didFinishExpand;
//}
//
//@end
//
//#define translation 150
//#define size 20
//#define extra_translation 1.05f
//#define extra_scale 1.4f
//
//@implementation ViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor lightGrayColor]];
//	pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [self.view addGestureRecognizer:pan];
//    views = [NSArray new];
//    CGRect r = CGRectMake(0,0, size, size);
//    for (int i = 0; i < 5; i++) {
//        UIView *v = [[UIView alloc] initWithFrame:r];
//        views = [views arrayByAddingObject:v];
//    }
//
//    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
//        [view setBackgroundColor:[UIColor colorWithRed:(arc4random() % 256)/255.0f green:(arc4random() % 256)/255.0f blue:(arc4random() % 256)/255.0f alpha:1]];
//        view.alpha = 0;
//    }];
//    angle = M_PI_4 * 0.5;
//}
//
//- (void)pan:(UIGestureRecognizer*)gesture
//{
//    if(gesture.state == UIGestureRecognizerStateBegan) {
//        initialPoint = [gesture locationInView:self.view];
//        didFinishExpand = NO;
//        [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
//            view.center = initialPoint;
//            [self.view addSubview:view];
//            view.transform = CGAffineTransformIdentity;
//        }];
//    } else if(gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed) {
//        CGPoint p = [gesture locationInView:self.view];
//        CGFloat deltaY = p.y - initialPoint.y;
//        CGFloat deltaX = p.x - initialPoint.x;
//        CGFloat panAngle = atan2f(deltaY, deltaX);
//        CGFloat deltaAngle = panAngle - baseAngle;
//        if(deltaAngle <= -M_PI) {
//            deltaAngle +=2 * M_PI;
//        } else if(deltaAngle >= M_PI) {
//            deltaAngle -= 2 *M_PI;
//        }
//        CGFloat differenceAngle = angle * 2 / ([views count] - 1);
//        NSInteger indexHovered = [views count] - 1 - round(([views count] - 1) * 0.5 + deltaAngle / differenceAngle);
//        if(indexHovered >= 0 && indexHovered < [views count]) {
//            NSLog(@"pan ended over index: %i",indexHovered);
//        } else {
//            NSLog(@"pan ended over non existant view");
//        }
//        [UIView animateWithDuration:0.3f animations:^{
//            [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
//                view.transform = CGAffineTransformIdentity;
//                view.alpha = 0;
//            }];
//        }completion:^(BOOL finished) {
//            [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
//                view.center = initialPoint;
//                [view removeFromSuperview];
//            }];
//        }];
//
//        didStart = NO;
//    } else if(gesture.state == UIGestureRecognizerStateChanged) {
//        if(!didStart) {
//            [UIView animateWithDuration:0.3f animations:^{
//                CGPoint p = [gesture locationInView:self.view];
//                CGPoint direction = CGPointMake(p.x - initialPoint.x, p.y - initialPoint.y);
//                CGFloat hypot = hypotf(direction.x, direction.y);
//                baseVector = CGPointMake(direction.x / hypot, direction.y / hypot);
//                baseAngle = atan2f(baseVector.y, baseVector.x);
//                CGPoint vector = CGPointMake(baseVector.x * translation, baseVector.y * translation);
//                for (int i = 0; i < [views count]; i++) {
//                    UIView *v = [views objectAtIndex:i];
//                    v.alpha = 1;
//                    CGPoint rotatedVector = CGPointApplyAffineTransform(vector, CGAffineTransformMakeRotation([self relativeAngle:i] * angle));
//                    v.transform = CGAffineTransformMakeTranslation(rotatedVector.x, rotatedVector.y);
//                }
//            } completion:^(BOOL finished) {
//                didFinishExpand = YES;
//            }];
//            didStart = YES;
//        } else {
//            CGPoint p = [gesture locationInView:self.view];
//            CGFloat deltaY = p.y - initialPoint.y;
//            CGFloat deltaX = p.x - initialPoint.x;
//            CGFloat panAngle = atan2f(deltaY, deltaX);
//            CGFloat deltaAngle = panAngle - baseAngle;
//            if(deltaAngle <= -M_PI) {
//                deltaAngle +=2 * M_PI;
//            } else if(deltaAngle >= M_PI) {
//                deltaAngle -= 2 *M_PI;
//            }
//            CGFloat differenceAngle = angle * 2 / ([views count] - 1);
//            NSInteger indexHovered = [views count] - 1 - round(([views count] - 1) * 0.5 + deltaAngle / differenceAngle);
//            CGPoint vector = CGPointMake(baseVector.x * translation, baseVector.y * translation);
//            if(didFinishExpand) {
//                [UIView animateWithDuration:0.1f animations:^{
//                    for (int i = 0; i < [views count]; i++) {
//                        UIView *v = [views objectAtIndex:i];
//                        CGPoint rotatedVector = CGPointApplyAffineTransform(vector, CGAffineTransformMakeRotation([self relativeAngle:i] * angle));
//                        if(i == indexHovered) {
//                            v.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(extra_scale, extra_scale), CGAffineTransformMakeTranslation(rotatedVector.x * extra_translation, rotatedVector.y * extra_translation));
//                            v.layer.zPosition = 10;
//                        } else {
//                            v.transform = CGAffineTransformMakeTranslation(rotatedVector.x, rotatedVector.y);
//                            v.layer.zPosition = 9;
//                        }
//                    }
//                }];
//            }
//        }
//    }
//}
//
//- (CGFloat)relativeAngle:(NSInteger)index
//{
//    CGFloat middle = ([views count] - 1) * 0.5;
//    CGFloat i =  (index - middle) / (CGFloat)(([views count] - 1) *0.5);
//    return -i;
//}
//
//@end
