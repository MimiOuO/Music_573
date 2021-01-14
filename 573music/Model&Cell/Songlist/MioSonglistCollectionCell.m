//
//  MioSonglistCollectionCell.m
//  573music
//
//  Created by Mimio on 2020/12/21.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSonglistCollectionCell.h"

@interface MioSonglistCollectionCell()
@property (nonatomic, strong) UIImageView *coverImg;
@property (nonatomic, strong) UILabel *playCountLab;
@property (nonatomic, strong) MioLabel *songlistNameLab;

@end

@implementation MioSonglistCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = appClearColor;
        CGFloat width = self.contentView.width;
        _coverImg = [UIImageView creatImgView:frame(0, 0, width, width) inView:self.contentView image:@"" radius:4];
        UIImageView *shadow = [UIImageView creatImgView:frame(0, width - 22, width, 22) inView:_coverImg image:@"zhuanji_mengban" radius:0];
        UIImageView *playCountImg = [UIImageView creatImgView:frame(6, width - 11 - 4, 11, 11) inView:_coverImg image:@"tinggeliang" radius:0];
        _playCountLab = [UILabel creatLabel:frame(18, width  - 17, 80, 15) inView:_coverImg text:@"0" color:appWhiteColor size:10 alignment:NSTextAlignmentLeft];
        _songlistNameLab = [MioLabel creatLabel:frame(0, width  + 4, width, 17) inView:self.contentView text:@"" colorName:name_text_one size:12 alignment:NSTextAlignmentLeft];
        _songlistNameLab.numberOfLines = 2;
    }
    return self;
}

- (void)setModel:(MioSongListModel *)model{
    [_coverImg sd_setImageWithURL:[model.cover_image_path mj_url] placeholderImage:image(@"qxt_zhuanji")];
    _playCountLab.text = model.hits_all;
    _songlistNameLab.text = model.title;
    if ([_songlistNameLab.text widthForFont:Font(12)] > self.width) {
        _songlistNameLab.height = 34;
    }else{
        _songlistNameLab.height = 17;
    }
    
}
@end
