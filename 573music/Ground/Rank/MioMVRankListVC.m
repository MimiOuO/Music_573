//
//  MioMVRankListVC.m
//  573music
//
//  Created by Mimio on 2021/1/15.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMVRankListVC.h"
#import "MioMVRankVC.h"
@interface MioMVRankListVC ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation MioMVRankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"视频排行榜" forState:UIControlStateNormal];
    
    [self request];
}

-(void)request{
    [MioGetReq(api_ranks,(@{@"type":@"MV",@"lock":@"0"})) success:^(NSDictionary *result){
        _data = [result objectForKey:@"data"];
        
        [self creatUI];
    } failure:^(NSString *errorInfo) {}];
}

-(void)creatUI{
    UIScrollView *bgScroll = [UIScrollView creatScroll:frame(0, NavH, KSW, KSH - NavH - TabH) inView:self.view contentSize:CGSizeMake(KSW, _data.count * 196 + 12)];
    
    
    for (int i = 0;i < _data.count; i++) {
        NSDictionary *rankDic = _data[i];
        UIView *bgView = [UIView creatView:frame(Mar, 12 + i*196, KSW_Mar2, 184) inView:bgScroll bgColor:color_card radius:4];
        [bgView whenTapped:^{
            MioMVRankVC *vc = [[MioMVRankVC alloc] init];
            vc.rankId = rankDic[@"rank_id"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIImageView *coverImg = [UIImageView creatImgView:frame(0, 0, KSW_Mar2, 184) inView:bgView image:@"" radius:4];
        [coverImg sd_setImageWithURL:((NSString *)rankDic[@"cover_image_path"]).mj_url placeholderImage:image(@"gequ_zhanweitu")];
        UIView *shadow = [UIView creatView:frame(0, 0, KSW_Mar2, 184) inView:coverImg bgColor:rgba(0, 0, 0, 0.3) radius:4];
        
        UILabel *titleLab = [UILabel creatLabel:frame(12, 12, 150, 20) inView:bgView text:rankDic[@"rank_title"] color:appWhiteColor boldSize:14 alignment:NSTextAlignmentLeft];
        for (int j = 0;j < 3; j++) {
            UILabel *tip = [UILabel creatLabel:frame(12, 117 + j*21, 17, 17) inView:bgView text:[NSString stringWithFormat:@"0%d",j + 1] color:appWhiteColor boldSize:12 alignment:NSTextAlignmentLeft];
            UILabel *name = [UILabel creatLabel:frame(33, 117 + j*21, KSW_Mar2 - 50, 17) inView:bgView text:@"" color:appWhiteColor size:12 alignment:NSTextAlignmentLeft];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@",((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).title,((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).singer_name]];
            [str addAttribute:NSForegroundColorAttributeName value:appWhiteColor range:NSMakeRange(0, ((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).title.length)];
            name.attributedText = str;
        }
    }
}


@end
