//
//  MioMusicCollectionCell.m
//  573music
//
//  Created by Mimio on 2021/1/12.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMusicCollectionCell.h"

@interface MioMusicCollectionCell()
@property (nonatomic, strong) UIImageView *coverImg;
@property (nonatomic, strong) MioLabel *title;
@property (nonatomic, strong) MioLabel *singerName;

@end

@implementation MioMusicCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = appClearColor;
        CGFloat width = self.contentView.width;
        _coverImg = [UIImageView creatImgView:frame(0, 0, width, width) inView:self.contentView image:@"" radius:4];
        
        _title = [MioLabel creatLabel:frame(0, width  + 4, width, 17) inView:self.contentView text:@"" colorName:name_text_one size:12 alignment:NSTextAlignmentLeft];
        _singerName = [MioLabel creatLabel:frame(0, width  + 22, width, 10) inView:self.contentView text:@"" colorName:name_text_two size:10 alignment:NSTextAlignmentLeft];
    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    [_coverImg sd_setImageWithURL:[model.cover_image_path mj_url] placeholderImage:image(@"qxt_zhuanji")];
    _title.text = model.title;
    _singerName.text = model.singer_name;
}
@end
