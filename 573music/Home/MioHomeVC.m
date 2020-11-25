//
//  MioHomeVC.m
//  ifixMerchat
//
//  Created by Mimio on 2020/4/10.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioHomeVC.h"
#import "MioFeedBackVC.h"
#import "MioTestVC.h"
#import "MioTest2VC.h"
#import "MioLabel.h"
@interface MioHomeVC ()
@end

@implementation MioHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = appWhiteColor;
    
    UIButton *sdfsd = [UIButton creatBtn:frame(100, 100, 100, 100) inView:self.view bgColor:mainColor title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
        if (Equals([userdefault objectForKey:@"skin"], @"bai") ) {
            [userdefault setObject:@"hei" forKey:@"skin"];
        }else{
            [userdefault setObject:@"bai" forKey:@"skin"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkin" object:nil];
//        MioFeedBackVC *vc = [[MioFeedBackVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIButton *sdfsdws = [UIButton creatBtn:frame(100, 220, 100, 100) inView:self.view bgColor:mainColor title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
        MioTestVC *vc = [[MioTestVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIButton *sdfsdw21s = [UIButton creatBtn:frame(100, 340, 100, 100) inView:self.view bgColor:mainColor title:@"222" titleColor:appWhiteColor font:14 radius:5 action:^{
        MioTest2VC *vc = [[MioTest2VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
//    UIImageView *avatar = [UIImageView creatImginView:self.view image:@"avatar_bai" radius:0];
    UIImageView *avatar = [UIImageView creatImgView:frame(100, 460, 100, 100) inView:self.view image:@"" radius:5];
    
    NSString *path = [NSString stringWithFormat:@"%@/Skin/bai/icon_bai.jpg",
                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
    avatar.image = [UIImage imageWithContentsOfFile:path];
//    UIImage *_image = [UIImage imageWithContentsOfFile:fullPathToFile];
    
    
    MioLabel *testlab = [[MioLabel alloc] init];
    testlab.frame = frame( 0, 580, KSW, 23);
    testlab.text = @"sdlfskjfsldjf234dsfsdfsf";
    testlab.textColor = subColor;
    [self.view addSubview:testlab];
    
    
    
    [MioGetCacheReq(api_otherUserinfo(@"4"), @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        NSLog(@"cacheYES__%@",data);
    } failure:^(NSString *errorInfo) {}];
    

    
}



@end
