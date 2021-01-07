//
//  MioMVRankView.m
//  573music
//
//  Created by Mimio on 2021/1/6.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMVRankView.h"

@implementation MioMVRankView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setRankDic:(NSDictionary *)rankDic{
    
    UIImageView *bgImg = [UIImageView creatImgView:frame(0, 0, 234, 140) inView:self image:@"" radius:6];
    [bgImg sd_setImageWithURL:Url(rankDic[@"cover_image_path"]) placeholderImage:image(@"gequ_zhanweitu")];
    UIView *bgView = [UIView creatView:frame(0, 0, 234, 140) inView:self bgColor:rgba(0, 0, 0, 0.3) radius:6];
    
    
    MioLabel *titleLab = [MioLabel creatLabel:frame(10, 8, 150, 20) inView:bgView text:rankDic[@"rank_title"] colorName:name_text_white size:14 alignment:NSTextAlignmentLeft];
    for (int j = 0;j < 3; j++) {
        UILabel *tip = [UILabel creatLabel:frame(10, 77 + j*21, 17, 17) inView:bgView text:[NSString stringWithFormat:@"0%d",j + 1] color:color_text_white boldSize:12 alignment:NSTextAlignmentLeft];
        UILabel *name = [UILabel creatLabel:frame(31, 77 + j*21, self.width - 31 - Mar, 17) inView:bgView text:@"" color:rgba(255, 255, 255, 0.7) size:12 alignment:NSTextAlignmentLeft];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@",((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).title,((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).singer_name]];
        [str addAttribute:NSForegroundColorAttributeName value:color_text_white range:NSMakeRange(0, ((MioMusicModel *)[MioMusicModel mj_objectWithKeyValues:rankDic[@"data"][j]]).title.length)];
        name.attributedText = str;
    }


}

@end
