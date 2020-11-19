//
//  MioAgeView.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/12/23.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioAgeView.h"

@interface MioAgeView()
@property (nonatomic, strong) UIImageView *genderView;
@property (nonatomic, strong) UILabel *ageLab;
@end

@implementation MioAgeView

+ (UIView *)creatAgeView:(CGRect)frame inView:(UIView *)view Age:(NSString *)age gender:(NSInteger)gender{
    UIImageView *genderView = [UIImageView creatImgView:frame inView:view image:@"" radius:0];
    if (gender == 0) {//女
        genderView.image = [UIImage imageNamed:@"attention_Female"];
    }else{//男
        genderView.image = [UIImage imageNamed:@"attention_Male"];
    }
    UILabel *ageLab = [UILabel creatLabel:frame(frame.size.width/3, 0, frame.size.width/3 *2, frame.size.height) inView:genderView text:age color:appWhiteColor size:10 alignment:NSTextAlignmentCenter];
    ageLab.font = [UIFont fontWithName:@"Futura" size:10];
    return genderView;
}

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.genderView = [UIImageView creatImgView:frame(0,0,frame.size.width,frame.size.height) inView:self image:@"" radius:0];
        self.ageLab = [UILabel creatLabel:frame(frame.size.width/3, 0, frame.size.width/3 *2, frame.size.height) inView:self text:@"" color:appWhiteColor size:10 alignment:NSTextAlignmentCenter];
        self.ageLab.font = [UIFont fontWithName:@"Futura" size:10];
        [view addSubview:self];
    }
    return self;
}


-(void)setAge:(NSString *)age gender:(NSInteger)gender{
    if (gender == 0) {//女
        self.genderView.image = [UIImage imageNamed:@"attention_Female"];
    }else{//男
        self.genderView.image = [UIImage imageNamed:@"attention_Male"];
    }
    self.ageLab.text = age;
}

@end
