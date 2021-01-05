//
//  MioMusicRankListVC.m
//  573music
//
//  Created by Mimio on 2020/12/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMusicRankListVC.h"
#import "MioMusicRankVC.h"
@interface MioMusicRankListVC ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation MioMusicRankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"排行榜" forState:UIControlStateNormal];
    
    [self request];
}

-(void)request{
    [MioGetReq(api_ranks,(@{@"type":@"歌曲",@"limit":@"3"})) success:^(NSDictionary *result){
        _data = [result objectForKey:@"data"];
        
        [self creatUI];
    } failure:^(NSString *errorInfo) {}];
}

-(void)creatUI{
    UIScrollView *bgScroll = [UIScrollView creatScroll:frame(0, NavH, KSW, KSH - NavH - TabH) inView:self.view contentSize:CGSizeMake(KSW, _data.count * 120 + 12)];
    for (int i = 0;i < _data.count; i++) {
        NSDictionary *rankDic = _data[i];
        UIView *bgView = [UIView creatView:frame(Mar, 12 + i*120, KSW_Mar2, 108) inView:bgScroll bgColor:color_card radius:4];
        [bgView whenTapped:^{
            MioMusicRankVC *vc = [[MioMusicRankVC alloc] init];
            vc.rankId = rankDic[@"rank_id"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UILabel *titleLab = [UILabel creatLabel:frame(12, 12, 150, 20) inView:bgView text:rankDic[@"rank_title"] color:color_text_one boldSize:14 alignment:NSTextAlignmentLeft];
        for (int j = 0;j < 3; j++) {
            UILabel *tip = [UILabel creatLabel:frame(12, 41 + j*21, 17, 17) inView:bgView text:[NSString stringWithFormat:@"0%d",j + 1] color:color_text_one boldSize:12 alignment:NSTextAlignmentLeft];
            UILabel *name = [UILabel creatLabel:frame(33, 41 + j*21, KSW - 49 - 150, 17) inView:bgView text:@"" color:color_text_two size:12 alignment:NSTextAlignmentLeft];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@",((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).title,((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).singer_name]];
            [str addAttribute:NSForegroundColorAttributeName value:color_text_one range:NSMakeRange(0, ((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).title.length)];
            name.attributedText = str;
        }
        UIImageView *coverImg = [UIImageView creatImgView:frame(bgView.width - bgView.height, 0, bgView.height, bgView.height) inView:bgView image:@"" radius:0];
        [coverImg sd_setImageWithURL:((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][0]]).cover_image_path.mj_url placeholderImage:image(@"gequ_zhanweitu")];

    }
}

@end
