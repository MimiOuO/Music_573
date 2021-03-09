//
//  MioAlbumTableCell.m
//  573music
//
//  Created by Mimio on 2020/12/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioAlbumTableCell.h"

@interface MioAlbumTableCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *playCountLab;
@property (nonatomic, strong) MioLabel *albumNameLab;
@property (nonatomic, strong) MioLabel *singerNameLab;
@end

@implementation MioAlbumTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = appClearColor;
        UIImageView *bg = [UIImageView creatImgView:frame(23, 6, 60, 60) inView:self.contentView image:@"zhuanji_heijiao" radius:0];
        _cover = [UIImageView creatImgView:frame(Mar, 6, 60, 60) inView:self.contentView image:@"qxt_zhuanji" radius:4];
    
        _albumNameLab = [MioLabel creatLabel:frame(_cover.right + Mar, 16, self.width - 92 - 60, 22) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _singerNameLab = [MioLabel creatLabel:frame(_cover.right + Mar, _albumNameLab.bottom + 2, self.width - 92 - 60, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        _playCountLab = [MioLabel creatLabel:frame(self.width - 12 - 100 , 40, 100, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentRight];
    }
    return self;
}

- (void)setModel:(MioAlbumModel *)model{
    _albumNameLab.width = self.width - 92 - 60;
    _singerNameLab.width = self.width - 92 - 60;
    _playCountLab.left = self.width - 12 - 100;
    
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_zhuanji")];
    _albumNameLab.text = model.title;
    _singerNameLab.text = model.singer_name;
    _playCountLab.text = [NSString stringWithFormat:@"%@次播放",model.hits_all];
}

@end
