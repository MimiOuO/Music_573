//
//  MioTest3VC.m
//  573music
//
//  Created by Mimio on 2020/11/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioTest3VC.h"

@interface MioTest3VC ()

@end

@implementation MioTest3VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *close = [UIButton creatBtn:frame(100, 100, 100, 100) inView:self.view bgColor:color_main title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
        [mioPlayer pause];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


@end
