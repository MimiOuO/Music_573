//
//  MioSonglistTableCell.m
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSonglistTableCell.h"

@interface MioSonglistTableCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *playCountLab;
@property (nonatomic, strong) MioLabel *songlistNameLab;
@property (nonatomic, strong) MioLabel *singerNameLab;
@end

@implementation MioSonglistTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = appClearColor;
        _cover = [UIImageView creatImgView:frame(Mar, 6, 60, 60) inView:self.contentView image:@"qxt_yinyue" radius:4];
    
        _songlistNameLab = [MioLabel creatLabel:frame(_cover.right + Mar, 16, KSW - 92 - 60, 22) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _playCountLab = [MioLabel creatLabel:frame(_cover.right + Mar, _songlistNameLab.bottom + 2, KSW - 92 - 60, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
//        _playCountLab = [MioLabel creatLabel:frame(KSW - 56 , 40, 40, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentRight];
    }
    return self;
}

- (void)setModel:(MioSongListModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_zhuanji")];
    _songlistNameLab.text = model.title;
    _playCountLab.text = model.hits_all;
}

@end
