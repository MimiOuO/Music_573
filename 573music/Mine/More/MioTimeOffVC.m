//
//  MioTimeOffVC.m
//  573music
//
//  Created by Mimio on 2020/12/15.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioTimeOffVC.h"

@interface MioTimeOffVC ()
@property (nonatomic, strong) NSArray *timeArr;
@end

@implementation MioTimeOffVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"定时关闭" forState:UIControlStateNormal];
    [self creatUI];
}

-(void)creatUI{
    _timeArr = @[@"不开启",@"10分钟后",@"20分钟后",@"30分钟后",@"60分钟后",@"90分钟后",@"120分钟后"];
    UIView *bgView1 = [UIView creatView:frame(Mar, 12 + NavH, KSW - Mar2 , 44*_timeArr.count) inView:self.view bgColor:cardColor radius:6];
    for (int i = 0;i < _timeArr.count; i++) {
        UILabel *title = [UILabel creatLabel:frame(12, i * 44, KSW - Mar2 - 24 , 44) inView:bgView1 text:_timeArr[i] color:text_main size:16 alignment:NSTextAlignmentLeft];
        [title whenTapped:^{
            [self click:i];
        }];
        UIView *split = [UIView creatView:frame(10, 44 * (i + 1), KSW_Mar2 - 20, 0.5) inView:bgView1 bgColor:dividerColor radius:0];
        UIImageView *arrow = [UIImageView creatImgView:frame(KSW_Mar2 - 12 - 24, 10 + i * 44 , 24, 24) inView:bgView1 image:@"xuanze_duigou" bgTintColor:mainColor radius:0];
        arrow.tag = 100 + i;
        arrow.hidden = YES;
        if (Equals(i, [_timeArr indexOfObject:[userdefault objectForKey:@"timeoff"]])) {
            arrow.hidden = NO;
        }
    }
}

-(void)click:(int)j{
    for (int i = 0;i < 10; i++) {
        ((UIImageView *)[self.view viewWithTag:i+100]).hidden = YES;
    }
    ((UIImageView *)[self.view viewWithTag:j+100]).hidden = NO;
    [userdefault setObject:_timeArr[j] forKey:@"timeoff"];
}

@end
