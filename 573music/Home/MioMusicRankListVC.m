//
//  MioMusicRankListVC.m
//  573music
//
//  Created by Mimio on 2020/12/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMusicRankListVC.h"

@interface MioMusicRankListVC ()

@end

@implementation MioMusicRankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"排行榜" forState:UIControlStateNormal];
    
    
}

-(void)request{
    [MioGetReq(api_ranks, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        
    } failure:^(NSString *errorInfo) {}];
}


@end
