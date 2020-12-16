//
//  UIButton+MioExtension.m
//  longtengyuan
//
//  Created by Mimio on 2019/6/1.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "UIButton+MioExtension.h"
#import "objc/runtime.h"
static const void * extraBy = &extraBy;

static const char btnBlock;



@implementation UIButton (MioExtension)
@dynamic extra;
@dynamic block;
- (void)setExtra:(NSString *)extra{
     objc_setAssociatedObject(self, extraBy, extra, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)extra{
    return objc_getAssociatedObject(self, extraBy);
}

+(UIButton *)creatBtninView:(UIView *)view bgImage:(NSString *)image WithTag:(NSInteger)tag target:(id)vc action:(SEL)action{
    UIButton *btn = [[UIButton alloc] init];
    [view addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    return btn;
}
+(UIButton *)creatBtninView:(UIView *)view bgColor:(UIColor *)color title:(NSString *)title WithTag:(NSInteger)tag target:(id)vc action:(SEL)action{
    UIButton *btn = [[UIButton alloc] init];
    [view addSubview:btn];
    btn.tag = tag;
    btn.backgroundColor = color;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}



+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgImage:(NSString *)image WithTag:(NSInteger)tag target:(id)vc action:(SEL)action{
	UIButton *btn = [[UIButton alloc] initWithFrame:frame];
	[view addSubview:btn];
	[btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
	btn.adjustsImageWhenHighlighted = NO;
	[btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
	btn.tag = tag;
	return btn;
}
+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgColor:(UIColor *)color title:(NSString *)title WithTag:(NSInteger)tag target:(id)vc action:(SEL)action{
	UIButton *btn = [[UIButton alloc] initWithFrame:frame];
	[view addSubview:btn];
	btn.tag = tag;
	btn.backgroundColor = color;
	[btn setTitle:title forState:UIControlStateNormal];
	btn.adjustsImageWhenHighlighted = NO;
	[btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgImage:(NSString *)image action:(ButtonSenderBlock)block{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [view addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    btn.block = ^(UIButton *sender) {
        block(sender);
    };
    return btn;
}

+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgImage:(NSString *)image bgTintColor:(UIColor *)color action:(void (^)())block{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [view addSubview:btn];
    UIImage * tempImage = [UIImage imageNamed:image];
    tempImage = [tempImage imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    [btn setBackgroundImage:tempImage forState:UIControlStateNormal];
    btn.tintColor = color;
    btn.adjustsImageWhenHighlighted = NO;
    btn.block = ^(UIButton *sender) {
        block(sender);
    };
    return btn;
}



+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgColor:(UIColor *)color title:(NSString *)title titleColor:(UIColor *)titleColor font:(CGFloat)fontSize radius:(CGFloat)radius action:(void (^)())block{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [view addSubview:btn];
    btn.backgroundColor = color;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = Font(fontSize);
    btn.adjustsImageWhenHighlighted = NO;
    if (radius && radius > 0) {
        btn.layer.cornerRadius = radius;
        btn.layer.masksToBounds = YES;
    }
    btn.block = ^(UIButton *sender) {
        block(sender);
    };
    
    return btn;
}

-(void)setBlock:(ButtonSenderBlock)block
{
    objc_setAssociatedObject(self, &btnBlock, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(ButtonSenderOpen) forControlEvents:(UIControlEventTouchUpInside)];
}

-(ButtonSenderBlock)block
{
    return objc_getAssociatedObject(self, &btnBlock);
}


- (void)ButtonSenderOpen
{
    if (self.block)
    {
        self.block(self);
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}
 
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
