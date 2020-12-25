//
//  YSCRippleView.m
//  AnimationLearn
//
//  Created by yushichao on 16/2/17.
//  Copyright © 2016年 yushichao. All rights reserved.
//

#import "YSCRippleView.h"

@interface YSCRippleView ()


@property (nonatomic, strong) NSTimer *rippleTimer;
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, assign) YSCRippleType type;

@end

@implementation YSCRippleView

- (void)removeFromParentView {
    if (self.superview) {
        [_rippleButton removeFromSuperview];
        [self closeRippleTimer];
        [self removeAllSubLayers];
        [self removeFromSuperview];
        [self.layer removeAllAnimations];
    }
}

- (void)removeAllSubLayers {
    for (NSInteger i = 0; [self.layer sublayers].count > 0; i++) {
        [[[self.layer sublayers] firstObject] removeFromSuperlayer];
    }
}

- (void)showWithRippleType:(YSCRippleType)type {
    _type = type;
    [self setUpRippleButton];
    
    self.rippleTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(addRippleLayer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rippleTimer forMode:NSRunLoopCommonModes];
    [self addRippleLayer];
}

- (void)setUpRippleButton {
    _rippleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _rippleButton.center = self.center;
    _rippleButton.layer.backgroundColor = color_main.CGColor;//[UIColor colorWithRed:199/255 green:37/255 blue:37/255 alpha:1].CGColor;
    _rippleButton.layer.cornerRadius = 25;
    _rippleButton.layer.masksToBounds = YES;
//    _rippleButton.layer.borderColor = [UIColor yellowColor].CGColor;
//    _rippleButton.layer.borderWidth = 2;
    [_rippleButton addTarget:self action:@selector(rippleButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_rippleButton];
}

- (void)rippleButtonTouched:(id)sender {
    [self closeRippleTimer];
    [self addRippleLayer];
}

- (CGRect)makeEndRect {
    CGRect endRect = CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, 50, 50);
    endRect = CGRectInset(endRect, -100, -100);
    return endRect;
}

- (void)addRippleLayer {
    CAShapeLayer *rippleLayer = [[CAShapeLayer alloc] init];
    rippleLayer.position = CGPointMake(150, 150);
    rippleLayer.bounds = CGRectMake(0, 0, 300, 300);
    rippleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, 50, 50)];
    rippleLayer.path = path.CGPath;
    rippleLayer.strokeColor = color_main.CGColor; //[UIColor colorWithRed:199/255.0 green:37/255.0 blue:37/255.0 alpha:1].CGColor;
    if (YSCRippleTypeRing == _type) {
        rippleLayer.lineWidth = 5;
    } else {
        rippleLayer.lineWidth = 1.5;
    }
    
    if (YSCRippleTypeLine == _type || YSCRippleTypeRing == _type) {
        rippleLayer.fillColor = [UIColor clearColor].CGColor;
    } else if (YSCRippleTypeCircle == _type) {
        rippleLayer.fillColor = color_main.CGColor;//[UIColor colorWithRed:199/255 green:37/255 blue:37/255 alpha:1].CGColor;
    } else if (YSCRippleTypeMixed == _type) {
        rippleLayer.fillColor = [UIColor grayColor].CGColor;
    }
    
    [self.layer insertSublayer:rippleLayer below:_rippleButton.layer];
    
    //addRippleAnimation
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, 50, 50)];
    CGRect endRect = CGRectInset([self makeEndRect], -100, -100);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    rippleLayer.path = endPath.CGPath;
    rippleLayer.opacity = 0.0;
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = 3.0;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 3.0;
    
    [rippleLayer addAnimation:opacityAnimation forKey:@""];
    [rippleLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:rippleLayer afterDelay:3.0];
}

- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer {
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}

- (void)closeRippleTimer {
    if (_rippleTimer) {
        if ([_rippleTimer isValid]) {
            [_rippleTimer invalidate];
        }
        _rippleTimer = nil;
    }
}

@end
