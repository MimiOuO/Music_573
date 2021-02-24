//
//  MioHallRankView.m
//  573music
//
//  Created by Mimio on 2021/1/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioHallRankView.h"

@interface MioHallRankView()

@end

@implementation MioHallRankView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setRankDic:(NSDictionary *)rankDic{
    
    UIImageView *bgImg = [UIImageView creatImgView:frame(Mar, 10, KSW_Mar2, 100) inView:self image:@"" radius:4];
    [bgImg sd_setImageWithURL:[rankDic[@"cover_image_path"] mj_url] placeholderImage:image(@"gequ_zhanweitu")];
    MioView *bgView = [MioView creatView:frame(Mar, 10, KSW_Mar2, 100) inView:self bgColorName:name_sup_two radius:4];
    UIImageView *coverImg = [UIImageView creatImgView:frame(Mar, 0, 110, 110) inView:self image:@"" radius:4];
    [coverImg sd_setImageWithURL:[rankDic[@"cover_image_path"] mj_url] placeholderImage:image(@"gequ_zhanweitu")];
    
    
    MioLabel *titleLab = [MioLabel creatLabel:frame(123, 10, 150, 20) inView:bgView text:rankDic[@"rank_title"] colorName:name_text_white size:14 alignment:NSTextAlignmentLeft];
    for (int j = 0;j < 3; j++) {
        UILabel *tip = [UILabel creatLabel:frame(123, 35 + j*21, 17, 17) inView:bgView text:[NSString stringWithFormat:@"0%d",j + 1] color:color_text_white boldSize:12 alignment:NSTextAlignmentLeft];
        UILabel *name = [UILabel creatLabel:frame(144, 35 + j*21, KSW - 49 - 150, 17) inView:bgView text:@"" color:rgba(255, 255, 255, 0.7) size:12 alignment:NSTextAlignmentLeft];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@",((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).title,((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).singer_name]];
        [str addAttribute:NSForegroundColorAttributeName value:color_text_white range:NSMakeRange(0, ((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).title.length)];
        name.attributedText = str;
    }


}

@end
