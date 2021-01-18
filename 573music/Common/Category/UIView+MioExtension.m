//
//  UIView+MioExtension.m
//  longtengyuan
//
//  Created by Mimio on 2019/6/2.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "UIView+MioExtension.h"
typedef void (^XP_WhenTappedBlock)();
static char kWhenTappedBlockKey;
@implementation UIView (MioExtension)

+(UIView *)creatViewWinView:(UIView *)view bgColor:(UIColor *)bgColor{
    UIView *bgview = [[UIView alloc] init];
    bgview.backgroundColor = bgColor;
    [view addSubview:bgview];
    return bgview;
}

+(UIView *)creatView:(CGRect)frame inView:(UIView *)view bgColor:(UIColor *)bgColor{
    UIView *bgview = [[UIView alloc] initWithFrame:frame];
    bgview.backgroundColor = bgColor;
    [view addSubview:bgview];
    return bgview;
}


+(UIView *)creatView:(CGRect)frame inView:(UIView *)view bgColor:(UIColor *)bgColor radius:(CGFloat)radius{
	UIView *bgview = [[UIView alloc] initWithFrame:frame];
	bgview.backgroundColor = bgColor;
    if (radius && radius > 0) {
        bgview.layer.cornerRadius = radius;
        bgview.layer.masksToBounds = YES;
    }
	[view addSubview:bgview];
	return bgview;
}
	


- (UIViewController *)viewController {
    UIResponder *next = [self nextResponder];
    do {if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next !=nil);
    return nil;
}

- (void)removeAllSubviews {
	//[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	while (self.subviews.count) {
		[self.subviews.lastObject removeFromSuperview];
	}
}

- (CGFloat)left {
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)top {
	return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)width {
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height {
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGFloat)centerX {
	return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
	return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
	return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

- (CGSize)size {
	return self.frame.size;
}

- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

- (void)whenTapped:(void (^)())block {
    
    UITapGestureRecognizer *gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewWasTapped)];
    
    [self addRequiredToDoubleTapsRecognizer:gesture];
    [self setBlock:block forKey:&kWhenTappedBlockKey];
}
- (void)viewWasTapped {
    [self runBlockForKey:&kWhenTappedBlockKey];
}
- (void)runBlockForKey:(void *)blockKey {
    XP_WhenTappedBlock block = objc_getAssociatedObject(self, blockKey);
    
    if (block) block();
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    return tapGesture;
}

- (void)addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer *)recognizer {
    for (UIGestureRecognizer *gesture in[self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)gesture;
            
            if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                [recognizer requireGestureRecognizerToFail:tapGesture];
            }
        }
    }
}

- (void)setBlock:(XP_WhenTappedBlock)block forKey:(void *)blockKey {
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
