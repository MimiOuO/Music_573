//
//  MioHomeRecommendVC.m
//  573music
//
//  Created by Mimio on 2020/12/14.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioHomeRecommendVC.h"
#import "MioMoreVC.h"
#import "MioEditInfoVC.h"
#import "MioUserInfo.h"
#import "PYSearch.h"
#import "MioSearchResultVC.h"
#import "MioMvVC.h"
#import "MioColor.h"
#import "MioTest2VC.h"
#import "MioMutipleVC.h"
#import "MioDownloadVC.h"
#import "SOSimulateDB.h"
#import <WHC_ModelSqlite.h>

@interface MioHomeRecommendVC ()
@property (nonatomic, strong) MioUserInfo *user;
@property (nonatomic, strong) NSArray *musicArr;
@end

@implementation MioHomeRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    [SOSimulateDB sharedDB];
    
    UIButton *sdfsd = [UIButton creatBtn:frame(100, 100, 100, 100) inView:self.view bgColor:color_main title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{

        if (Equals([userdefault objectForKey:@"skin"], @"bai") ) {
            [userdefault setObject:@"hei" forKey:@"skin"];
        }else{
            [userdefault setObject:@"bai" forKey:@"skin"];
        }
        [userdefault synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkin" object:nil];
//        MioFeedBackVC *vc = [[MioFeedBackVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UILabel *name = [UILabel creatLabel:frame(100, 200, 200, 100) inView:self.view text:@"11111111" color:color_main size:20 alignment:NSTextAlignmentLeft];


    
    UIButton *butt = [UIButton creatBtn:frame(100, 300, 50, 50) inView:self.view bgImage:@"cycle_player" bgTintColor:color_main action:^{


        NSArray *arr4 = [SOSimulateDB downloadingMusicArrayInDB];
        NSArray *arr5 = [SOSimulateDB pausedMusicArrayInDB];
        NSArray *arr6 = [SOSimulateDB complatedMusicArrayInDB];
    
        NSLog(@"%@%@%@",arr4,arr5,arr6);
        
//        MioTest2VC *vc = [[MioTest2VC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        goLogin;
//        MioMvVC *vc = [[MioMvVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIButton *butt2 = [UIButton creatBtn:frame(100, 400, 50, 50) inView:self.view bgImage:@"cycle_player" bgTintColor:color_main action:^{

        
        MioDownloadVC *vc = [[MioDownloadVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        

    }];
    
    [MioGetReq(api_songs, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        _musicArr = [MioMusicModel mj_objectArrayWithKeyValuesArray:data];
    } failure:^(NSString *errorInfo) {}];
    
    UIButton *butt3 = [UIButton creatBtn:frame(100, 500, 50, 50) inView:self.view bgImage:@"cycle_player" bgTintColor:color_main action:^{
        MioMutipleVC *vc = [[MioMutipleVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.musicArr = _musicArr;
        [self presentViewController:vc animated:YES completion:nil];
        
//        [mioPlayer playWithMusicList:_musicArr andIndex:0];
    }];
    
//    [MioGetReq(api_userInfo, @{@"k":@"v"}) success:^(NSDictionary *result){
//        NSDictionary *data = [result objectForKey:@"data"];
//        _user = [MioUserInfo mj_objectWithKeyValues:data];
//    } failure:^(NSString *errorInfo) {}];
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
