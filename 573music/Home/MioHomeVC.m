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
@interface MioHomeVC ()
@end

@implementation MioHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = appWhiteColor;
    
    UIButton *sdfsd = [UIButton creatBtn:frame(100, 100, 100, 100) inView:self.view bgColor:mainColor title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
        MioFeedBackVC *vc = [[MioFeedBackVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIButton *sdfsdws = [UIButton creatBtn:frame(100, 300, 100, 100) inView:self.view bgColor:mainColor title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
        MioTestVC *vc = [[MioTestVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
}
@end
