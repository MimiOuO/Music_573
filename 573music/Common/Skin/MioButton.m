//
//  MioButton.m
//  573music
//
//  Created by Mimio on 2020/12/11.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioButton.h"

@implementation MioButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        RecieveChangeSkin;
    }
    return self;
}

+(MioButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgImage:(NSString *)image bgTintColorName:(NSString *)colorName action:(void (^)())block{
    MioButton *btn = [[MioButton alloc] init];
    btn.colorName = colorName;
    btn.frame = frame;
    [view addSubview:btn];
    UIImage * tempImage = [UIImage imageNamed:image];
    tempImage = [tempImage imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    [btn setBackgroundImage:tempImage forState:UIControlStateNormal];
    btn.tintColor = [MioColor colorWithName:colorName];
    btn.adjustsImageWhenHighlighted = NO;
    btn.block = ^(UIButton *sender) {
        block(sender);
    };
    return btn;
}

-(void)changeSkin{
    self.tintColor = [MioColor colorWithName:self.colorName];
}

@end
