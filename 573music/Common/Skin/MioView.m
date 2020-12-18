//
//  MioView.m
//  573music
//
//  Created by Mimio on 2020/11/23.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioView.h"

@implementation MioView

- (instancetype)init
{
    self = [super init];
    if (self) {
        RecieveChangeSkin;
    }
    return self;
}

+(MioView *)creatView:(CGRect)frame inView:(UIView *)view bgColorName:(NSString *)colorName radius:(CGFloat)radius{
    MioView *bgview = [[MioView alloc] init];
    bgview.colorName = colorName;
    bgview.frame = frame;
    bgview.backgroundColor = [MioColor colorWithName:colorName];
    if (radius && radius > 0) {
        bgview.layer.cornerRadius = radius;
        bgview.layer.masksToBounds = YES;
    }
    [view addSubview:bgview];
    return bgview;
}

-(void)changeSkin{
    self.backgroundColor = [MioColor colorWithName:self.colorName];
}

@end
