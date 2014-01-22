//
//  ExpandingCircularMenu.m
//  ExpandingCircularMenu
//
//  Created by Michael Quan on 2013-10-11.
//  Copyright (c) 2013 Michael Quan. All rights reserved.
//

#import "ExpandingCircularMenu.h"

@interface ExpandingCircularMenu() {
    CGPoint initialPoint;
    BOOL didFinishExpand;
    BOOL didStart;
    
    NSInteger hoveredIndex;
    
    CGFloat baseAngle;
    CGPoint baseVector;
}

#define INVALID_HOVERED_INDEX -1

@property (nonatomic, weak) UIView *view;
@property (nonatomic) ExpandingCircularMenuLayout *layout;
@end

@implementation ExpandingCircularMenu

- (instancetype)initForView:(UIView*)view WithExpandingCircularLayout:(ExpandingCircularMenuLayout*)layout
{
    self = [super init];
    if(self) {
        _view = view;
        _layout = layout;
    }
    return self;
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan) {
        
        initialPoint = [gesture locationInView:self.view];
        didFinishExpand = NO;
        hoveredIndex = INVALID_HOVERED_INDEX;
        [self.layout.menuViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
            view.center = initialPoint;
            [self.view addSubview:view];
            view.transform = CGAffineTransformIdentity;
        }];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGPoint p = [gesture locationInView:self.view];
//            CGPoint direction = CGPointMake(p.x - initialPoint.x, p.y - initialPoint.y);
            CGPoint direction = CGPointMake(CGRectGetMidX(self.view.bounds) - p.x, CGRectGetMidY(self.view.bounds) - p.y);
            CGFloat hypot = hypotf(direction.x, direction.y);
            baseVector = CGPointMake(direction.x / hypot, direction.y / hypot);
            baseAngle = atan2f(baseVector.y, baseVector.x);
            CGPoint vector = CGPointMake(baseVector.x * self.layout.translation, baseVector.y * self.layout.translation);
            for (int i = 0; i < [self.layout.menuViews count]; i++) {
                UIView *v = [self.layout.menuViews objectAtIndex:i];
                CGPoint rotatedVector = CGPointApplyAffineTransform(vector, CGAffineTransformMakeRotation([self relativeAngle:i] * self.layout.angleSpread));
                v.transform = CGAffineTransformMakeTranslation(rotatedVector.x, rotatedVector.y);
            }
        } completion:^(BOOL finished) {
            didFinishExpand = YES;
        }];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint p = [gesture locationInView:self.view];
        CGFloat deltaY = p.y - initialPoint.y;
        CGFloat deltaX = p.x - initialPoint.x;
        CGFloat panAngle = atan2f(deltaY, deltaX);
        CGFloat deltaAngle = panAngle - baseAngle;
        if(deltaAngle <= -M_PI) {
            deltaAngle +=2 * M_PI;
        } else if(deltaAngle >= M_PI) {
            deltaAngle -= 2 *M_PI;
        }
        CGFloat differenceAngle = self.layout.angleSpread * 2 / ([self.layout.menuViews count] - 1);
        NSInteger indexHovered = [self.layout.menuViews count] - 1 - round(([self.layout.menuViews count] - 1) * 0.5 + deltaAngle / differenceAngle);
//        CGPoint vector = CGPointMake(baseVector.x * self.layout.translation, baseVector.y * self.layout.translation);
//        if(didFinishExpand) {
//            [UIView animateWithDuration:0.1f animations:^{
//            for (int i = 0; i < [self.layout.menuViews count]; i++) {
//                UIView *v = [self.layout.menuViews objectAtIndex:i];
//                CGPoint rotatedVector = CGPointApplyAffineTransform(vector, CGAffineTransformMakeRotation([self relativeAngle:i] * self.layout.angleSpread));
//                    if(i == indexHovered) {
//                        v.transform = CGAffineTransformConcat(
//                                                              CGAffineTransformMakeScale(self.layout.hoveredScale, self.layout.hoveredScale),
//                                                              CGAffineTransformMakeTranslation(rotatedVector.x * (self.layout.hoveredTranslation / self.layout.translation), rotatedVector.y * (self.layout.hoveredTranslation / self.layout.translation)));
//                        v.layer.zPosition = 10;
//                    } else {
//                v.transform = CGAffineTransformMakeTranslation(rotatedVector.x, rotatedVector.y);
//                v.layer.zPosition = 9;
//                    }
//            }
//            }];
//        }
        if(indexHovered != hoveredIndex) {
            if([self.delegate respondsToSelector:@selector(didStopHoveringOverView:withIndex:)] && hoveredIndex != INVALID_HOVERED_INDEX) {
                [self.delegate didStopHoveringOverView:self.layout.menuViews[hoveredIndex] withIndex:hoveredIndex];
            }
            if(indexHovered >= 0 && indexHovered < [self.layout.menuViews count]) {
                if([self.delegate respondsToSelector:@selector(didStartHoveringOverView:withIndex:)]) {
                    [self.delegate didStartHoveringOverView:self.layout.menuViews[indexHovered] withIndex:indexHovered];
                }
                hoveredIndex = indexHovered;
            } else {
                hoveredIndex = INVALID_HOVERED_INDEX;
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
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
//        CGFloat differenceAngle = self.layout.angleSpread * 2 / ([self.layout.menuViews count] - 1);
//        NSInteger indexHovered = [self.layout.menuViews count] - 1 - round(([self.layout.menuViews count] - 1) * 0.5 + deltaAngle / differenceAngle);
        if(hoveredIndex >= 0 && hoveredIndex < [self.layout.menuViews count]) {
            if([self.delegate respondsToSelector:@selector(didEndGestureHoveringOverView:withIndex:)]) {
                [self.delegate didEndGestureHoveringOverView:[self.layout.menuViews objectAtIndex:hoveredIndex] withIndex:hoveredIndex];
            }
        } else {
            if([self.delegate respondsToSelector:@selector(didEndGestureHoveringOverNoView)]) {
                [self.delegate didEndGestureHoveringOverNoView];
            }
        }
        [UIView animateWithDuration:0.3f animations:^{
            [self.layout.menuViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
                view.transform = CGAffineTransformIdentity;
            }];
        }completion:^(BOOL finished) {
            [self.layout.menuViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
                view.center = initialPoint;
                [view removeFromSuperview];
            }];
        }];
    } else if (gesture.state == UIGestureRecognizerStateFailed ||
               gesture.state == UIGestureRecognizerStateCancelled) {
    }
}

- (CGFloat)relativeAngle:(NSInteger)index
{
    CGFloat middle = ([self.layout.menuViews count] - 1) * 0.5;
    CGFloat i =  (index - middle) / (CGFloat)(([self.layout.menuViews count] - 1) *0.5);
    return -i;
}

@end
