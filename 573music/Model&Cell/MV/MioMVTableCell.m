//
//  MioMVTableCell.m
//  573music
//
//  Created by Mimio on 2020/12/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMVTableCell.h"

@interface MioMVTableCell()
@property (nonatomic, strong) MioView *bgView;
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *playCountLab;
@property (nonatomic, strong) MioLabel *titleLab;
@property (nonatomic, strong) MioLabel *singerLab;

@end

@implementation MioMVTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        
        _cover = [UIImageView creatImgView:frame(Mar, 6, 109, 61) inView:self.contentView image:@"qxt_mv" radius:4];
        UIImageView *shadow = [UIImageView creatImgView:frame(0, _cover.height - 22, 109, 22) inView:_cover image:@"zhuanji_mengban" radius:0];
        UIImageView *playCountIcon = [UIImageView creatImgView:frame(6, _cover.height - 15 , 11, 11) inView:_cover image:@"bofangliang" radius:0];
        _playCountLab = [UILabel creatLabel:frame(18, _cover.height - 17, 50, 15) inView:_cover text:@"0" color:appWhiteColor size:10 alignment:NSTextAlignmentLeft];
        _titleLab = [MioLabel creatLabel:frame(133, 14, self.width - 133 - Mar, 22) inView:self.contentView text:@"" colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
        _singerLab = [MioLabel creatLabel:frame(133, 40, self.width - 133 - Mar, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    }
    return self;
}

- (void)setModel:(MioMvModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_mv")];
    _playCountLab.text = model.hits_all;
    _titleLab.text = model.title;
    _singerLab.text = model.singer_name;
}
@end
