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
        hoveredIndex = INVALID_HOVERED_INDEX;
        [self.layout.menuViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
            [self.view addSubview:view];
            view.transform = CGAffineTransformIdentity;
        }];
        
        CGPoint p = [gesture locationInView:self.view];
        CGPoint direction = CGPointMake(CGRectGetMidX(self.view.bounds) - p.x, CGRectGetMidY(self.view.bounds) - p.y);
        CGFloat hypot = hypotf(direction.x, direction.y);
        baseVector = CGPointMake(direction.x / hypot, direction.y / hypot);
        baseAngle = atan2f(baseVector.y, baseVector.x);
        CGPoint vector = CGPointMake(baseVector.x * self.layout.translation, baseVector.y * self.layout.translation);
        for (int i = 0; i < [self.layout.menuViews count]; i++) {
            UIView *v = [self.layout.menuViews objectAtIndex:i];
            CGPoint rotatedVector = CGPointApplyAffineTransform(vector, CGAffineTransformMakeRotation([self relativeAngleFactor:i] * self.layout.angleSpread));
            CGAffineTransform translate = CGAffineTransformMakeTranslation(rotatedVector.x, rotatedVector.y);
            v.center = CGPointApplyAffineTransform(initialPoint, translate);
            v.transform = CGAffineTransformInvert(translate);
        }
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:0 animations:^{
            [self.layout.menuViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
                view.transform = CGAffineTransformIdentity;
            }];
        } completion:^(BOOL finished) {
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
        if(hoveredIndex >= 0 && hoveredIndex < [self.layout.menuViews count]) {
            if([self.delegate respondsToSelector:@selector(didEndGestureHoveringOverView:withIndex:)]) {
                [self.delegate didEndGestureHoveringOverView:[self.layout.menuViews objectAtIndex:hoveredIndex] withIndex:hoveredIndex];
            }
        } else {
            if([self.delegate respondsToSelector:@selector(didEndGestureHoveringOverNoView)]) {
                [self.delegate didEndGestureHoveringOverNoView];
            }
        }
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.layout.menuViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
                view.center = initialPoint;
                view.transform = CGAffineTransformIdentity;
            }];
        }completion:^(BOOL finished) {
            [self.layout.menuViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop){
                [view removeFromSuperview];
            }];
        }];
    } else if (gesture.state == UIGestureRecognizerStateFailed ||
               gesture.state == UIGestureRecognizerStateCancelled) {
    }
}

- (CGFloat)relativeAngleFactor:(NSInteger)index
{
    CGFloat middle = ([self.layout.menuViews count] - 1) * 0.5;
    CGFloat i =  (index - middle) / (CGFloat)(([self.layout.menuViews count] - 1) * 0.5);
    return -i;
}

@end
