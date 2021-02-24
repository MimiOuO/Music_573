//
//  MioDownloadedMusicTableCell.m
//  573music
//
//  Created by Mimio on 2021/2/23.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioDownloadedMusicTableCell.h"
@interface MioDownloadedMusicTableCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) MioLabel *nameLab;
@property (nonatomic, strong) MioImageView *flacImg;
@property (nonatomic, strong) MioImageView *mvImg;
@property (nonatomic, strong) MioLabel *singerLab;
@end

@implementation MioDownloadedMusicTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        _cover = [UIImageView creatImgView:frame(Mar, 0, 58, 58) inView:self.contentView image:@"" radius:4];
    
        _nameLab = [MioLabel creatLabel:frame(_cover.right + 8, 8, KSW - 84 - 45, 22) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _flacImg = [MioImageView creatImgView:frame(_cover.right + 8, _nameLab.bottom + 5, 22, 12) inView:self.contentView image:@"" bgTintColorName:name_main radius:0];
        _mvImg = [MioImageView creatImgView:frame(_flacImg.right + 4, _nameLab.bottom + 5, 22, 12) inView:self.contentView image:@"playlist_mv" bgTintColorName:name_main radius:0];
        _singerLab = [MioLabel creatLabel:frame(_mvImg.right + 8, _nameLab.bottom + 2, KSW - 136 - 45, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        UIImageView *icon = [UIImageView creatImgView:frame(KSW - 46, 25, 22, 22) inView:self.contentView image:@"jdCount" radius:0];
    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_gequ")];
    _nameLab.text = model.title;
    _singerLab.text = model.singer_name;

    _mvImg.left = 110;
    if (model.hasMV) {
        _mvImg.hidden = NO;
        _singerLab.left = 136;
    }else{
        _mvImg.hidden = YES;
        _singerLab.left = 110;
    }
    NSString *downloadPath = [NSString stringWithFormat:@"%@/sj.download.files",
                           NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[model.standard[@"url"] mj_url] hash]]]) {
        _flacImg.image = image(@"playlist_standard");
    }
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[model.high[@"url"] mj_url] hash]]]) {
        _flacImg.image = image(@"playlist_hd");
    }
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[model.lossless[@"url"] mj_url] hash]]]) {
        _flacImg.image = image(@"playlist_nondestructive");
    }
}

@end
