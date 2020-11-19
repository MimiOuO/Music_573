//
//  MioLargeButton.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/10/29.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioLargeButton.h"
#import "TFQClickAreaButton.h"

@implementation MioLargeButton

#pragma mark - system method
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if(!self.showClickArea){
        return;
    }
    TFQClickAreaButton *btn = [[TFQClickAreaButton alloc] init];
    if([self canSuperResponseClickEvent]){
        btn.frame = self.bounds;
    }else{
        btn.frame = [self clickAreaRect];
    }
    [self addSubview:btn];
}

///重写系统方法
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if([self canSuperResponseClickEvent]){
        return [super pointInside:point withEvent:event];
    }else{
        return CGRectContainsPoint([self clickAreaRect], point);
    }
}

///点击区域的范围
- (CGRect)clickAreaRect{
    //UIEdgeInsetsInsetRect 在原先的rect上内切出另一个rect出来，-为变大，+为变小
    return  UIEdgeInsetsInsetRect(self.bounds, self.clickEdgeInsets);
}

///是否需要调用父类方法来处理事件
- (BOOL)canSuperResponseClickEvent{
    /**
    *  在系统的UIView中，以下4个条件不执行事件响应，所以当前对象没有修改edgeInsets或者下边的任意一种情况，我们都交给父类来处理事件
    *  1、hidden=YES的view
    *  2、userinteractionEnabled=NO的view
    *  3、alpha<0.01的view
    *  4、子view超出superView的区域
    */
    //UIEdgeInsetsEqualToEdgeInsets 判断两个值是否相等
    if(UIEdgeInsetsEqualToEdgeInsets(self.clickEdgeInsets, UIEdgeInsetsZero) || self.hidden || !self.userInteractionEnabled || self.alpha==0){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - set method
- (void)setClickScale:(CGFloat)clickScale{
    _clickScale = clickScale;
    if(clickScale <= 1){
        return;
    }
    clickScale -= 1;
    CGFloat width = self.bounds.size.width * clickScale;
    CGFloat height = self.bounds.size.height * clickScale;
    self.clickEdgeInsets = UIEdgeInsetsMake(-height, -width, -height, -width);
}

- (void)setClickWidthScale:(CGFloat)clickWidthScale{
    _clickWidthScale = clickWidthScale;
    if(clickWidthScale <= 1){
        return;
    }
    clickWidthScale -= 1;
    CGFloat width = self.bounds.size.width * clickWidthScale;
    self.clickEdgeInsets = UIEdgeInsetsMake(0, -width, 0, -width);
}

- (void)setClickHeightScale:(CGFloat)clickHeightScale{
    _clickHeightScale = clickHeightScale;
    if(clickHeightScale <= 1){
        return;
    }
    clickHeightScale -= 1;
    CGFloat height = self.bounds.size.height * clickHeightScale;
    self.clickEdgeInsets = UIEdgeInsetsMake(-height, 0, -height, 0);
}

@end
