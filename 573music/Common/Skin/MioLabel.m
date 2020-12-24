//
//  MioLabel.m
//  573music
//
//  Created by Mimio on 2020/11/23.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioLabel.h"
@interface MioLabel()
@property (nonatomic, strong) UIColor *tempColor;
@end

@implementation MioLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        RecieveChangeSkin;
    }
    return self;
}

+(MioLabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text colorName:(NSString *)colorName size:(CGFloat)fontSize alignment:(NSTextAlignment)alignment{
    MioLabel *label = [[MioLabel alloc] init];
    label.colorName = colorName;
    label.frame = frame;
    label.text = text;
    label.textColor = [MioColor colorWithName:colorName];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = alignment;
    [view addSubview:label];
    return label;
}

+(MioLabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text colorName:(NSString *)colorName boldSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment{
    MioLabel *label = [[MioLabel alloc] init];
    label.colorName = colorName;
    label.frame = frame;
    label.text = text;
    label.textColor = [MioColor colorWithName:colorName];
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    label.textAlignment = alignment;
    [view addSubview:label];
    return label;
}

-(void)changeSkin{
    NSLog(@"%@",self.colorName);
    self.textColor = [MioColor colorWithName:self.colorName];
}

@end
