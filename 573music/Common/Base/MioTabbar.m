//
//  XDJTabbar.m
//  XDJBookCourse
//
//  Created by csh on 16/6/27.
//  Copyright © 2016年 XDJ. All rights reserved.
//

#import "MioTabbar.h"

@implementation MioTabbar

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
    
//    if (self.isHidden) {
//        return [super hitTest:point withEvent:event];
//    }
//
//    CGPoint newP = [self convertPoint:point toView:self.tabV.plusBtn];
//
//    //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
//    if ( [self.tabV.plusBtn pointInside:newP withEvent:event]) {
//        return self.tabV.plusBtn;
//    }else{//如果点不在发布按钮身上，直接让系统处理就可以了
//
//        return [super hitTest:point withEvent:event];
//    }

//    UIView *view = [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (self.y < KSH) { //all
        if (point.y > - 50.0) {
            return YES;
        }else{
            return NO;
        }
    }

    else if (self.y == KSH) { //half
        if (point.y > - 50.0 - SafeBotH) {
            return YES;
        }else{
            return NO;
        }
    }

    else { //none
        return NO;
    }

}
@end
