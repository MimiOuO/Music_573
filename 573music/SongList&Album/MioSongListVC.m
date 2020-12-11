//
//  MioSongListVC.m
//  573music
//
//  Created by Mimio on 2020/12/11.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSongListVC.h"

@interface MioSongListVC ()

@end

@implementation MioSongListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"歌单" forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.height = KSH;
}


@end
