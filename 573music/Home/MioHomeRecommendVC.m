//
//  MioHomeRecommendVC.m
//  573music
//
//  Created by Mimio on 2020/12/14.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioHomeRecommendVC.h"
#import "MioMoreVC.h"

@interface MioHomeRecommendVC ()

@end

@implementation MioHomeRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    UILabel *name = [UILabel creatLabel:frame(100, 200, 200, 100) inView:self.view text:@"11111111" color:mainColor size:20 alignment:NSTextAlignmentLeft];

    UIButton *butt = [UIButton creatBtn:frame(100, 300, 100, 100) inView:self.view bgImage:@"cycle_player" bgTintColor:mainColor action:^{
        MioMoreVC *vc = [[MioMoreVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
