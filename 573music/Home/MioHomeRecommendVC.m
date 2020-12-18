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

@interface MioHomeRecommendVC ()
@property (nonatomic, strong) MioUserInfo *user;
@end

@implementation MioHomeRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
    UIButton *sdfsd = [UIButton creatBtn:frame(100, 100, 100, 100) inView:self.view bgColor:color_main title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{

        if (Equals([userdefault objectForKey:@"skin"], @"bai") ) {
            [userdefault setObject:@"hei" forKey:@"skin"];
        }else{
            [userdefault setObject:@"bai" forKey:@"skin"];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkin" object:nil];
//        MioFeedBackVC *vc = [[MioFeedBackVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UILabel *name = [UILabel creatLabel:frame(100, 200, 200, 100) inView:self.view text:@"11111111" color:color_main size:20 alignment:NSTextAlignmentLeft];

    UIButton *butt = [UIButton creatBtn:frame(100, 300, 50, 50) inView:self.view bgImage:@"cycle_player" bgTintColor:color_main action:^{

        goLogin;
//        MioMvVC *vc = [[MioMvVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIButton *butt2 = [UIButton creatBtn:frame(100, 400, 50, 50) inView:self.view bgImage:@"cycle_player" bgTintColor:color_main action:^{
        MioMoreVC *vc = [[MioMoreVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
//        NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
//        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索品类、ID、昵称"];
//        searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
//        MioSearchResultVC *resultVC = [[MioSearchResultVC alloc] init];
//        searchViewController.searchResultController = resultVC;
//        searchViewController.delegate = resultVC;
//        searchViewController.searchBarBackgroundColor = rgb(246, 247, 249);
//        searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
//        searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
//
//        CATransition* transition = [CATransition animation];
//        transition.type = kCATransitionMoveIn;//可更改为其他方式
//        transition.subtype = kCATransitionFromTop;//可更改为其他方式
//        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//
//        [self.navigationController pushViewController:searchViewController animated:NO];
    }];
    
    UIButton *butt3 = [UIButton creatBtn:frame(100, 500, 50, 50) inView:self.view bgImage:@"cycle_player" bgTintColor:color_main action:^{
        MioEditInfoVC *vc = [[MioEditInfoVC alloc] init];
        vc.user = _user;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [MioGetReq(api_userInfo, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _user = [MioUserInfo mj_objectWithKeyValues:data];
    } failure:^(NSString *errorInfo) {}];
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
