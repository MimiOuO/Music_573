//
//  MioSystemNoticeCell.m
//  573music
//
//  Created by Mimio on 2021/1/20.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioSystemNoticeCell.h"

@interface MioSystemNoticeCell()
@property (nonatomic, strong) MioLabel *contentLab;
@property (nonatomic, strong) MioLabel *timeLab;
@property (nonatomic, strong) MioView *split;
@end

@implementation MioSystemNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        
        UIView *iconView = [UIView creatView:frame(12, 12, 50, 50) inView:self bgColor:color_main radius:25];
        UIImageView *icon = [UIImageView creatImgView:frame(14, 14, 22, 22) inView:iconView image:@"xiaoxi_os" radius:0];
        _bgView = [UIView creatView:frame(0, 0, KSW_Mar2, 100) inView:self bgColor:color_card radius:0];
        
        _contentLab = [MioLabel creatLabel:frame(70, 17, (KSW - 86 -28), 0) inView:self.contentView text:@"" colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
        _timeLab = [MioLabel creatLabel:frame(70, _contentLab.bottom + 13, 200, 14) inView:self.contentView text:@"" colorName:name_text_two size:10 alignment:NSTextAlignmentLeft];
        _split = [MioView creatView:frame(60, _timeLab.bottom + 12, KSW - 76 -28, 0.5) inView:self bgColorName:name_split radius:0];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic{
    _contentLab.text = dic[@"data"][@"content"];
    _contentLab.height = [_contentLab.text heightForFont:Font(14) width:(KSW - 86 -28)];
    _timeLab.text = dic[@"created_at"];
    _timeLab.top = _contentLab.bottom + 13;
    _split.top = _timeLab.bottom + 12;
    _bgView.height = 56 + [dic[@"data"][@"content"] heightForFont:Font(14) width:(KSW - 86 -28)];
}
@end
