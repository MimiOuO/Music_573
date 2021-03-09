//
//  MioMusicNoImgTableCell.m
//  573music
//
//  Created by Mimio on 2021/3/2.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMusicNoImgTableCell.h"

@interface MioMusicNoImgTableCell()
@property (nonatomic, strong) MioLabel *nameLab;
@property (nonatomic, strong) MioImageView *flacImg;
@property (nonatomic, strong) MioImageView *mvImg;
@property (nonatomic, strong) MioLabel *singerLab;
@property (nonatomic, strong) MioLabel *countLab;
@property (nonatomic, strong) MioImageView *countImg;
@end

@implementation MioMusicNoImgTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;

        _nameLab = [MioLabel creatLabel:frame(12, 7, KSW - 84 - 45, 22) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _flacImg = [MioImageView creatImgView:frame(12, _nameLab.bottom + 4.5, 22, 12) inView:self.contentView image:@"playlist_nondestructive" bgTintColorName:name_main radius:0];
        _mvImg = [MioImageView creatImgView:frame(_flacImg.right + 4, _nameLab.bottom + 4.5, 22, 12) inView:self.contentView image:@"playlist_mv" bgTintColorName:name_main radius:0];
        _singerLab = [MioLabel creatLabel:frame(_mvImg.right + 8, _nameLab.bottom + 2, KSW - 136 - 45, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        _countImg = [MioImageView creatImgView:frame(0, 32, 14, 14) inView:self.contentView image:@"dj_bf" bgTintColorName:name_main radius:0];
        _countLab = [MioLabel creatLabel:frame(KSW - 51, _nameLab.bottom + 3, 0, 15) inView:self text:@"" colorName:name_main size:12 alignment:NSTextAlignmentCenter];
    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    _nameLab.text = model.title;
    _singerLab.text = model.singer_name;
    _countLab.text = model.hits_all;
    _countLab.width = [_countLab.text widthForFont:Font(12)];
    if (model.hasFlac) {
        _flacImg.hidden = NO;
        _mvImg.left = 38;
        if (model.hasMV) {
            _mvImg.hidden = NO;
            _countImg.left = 64;
        }else{
            _mvImg.hidden = YES;
            _countImg.left = 38;
        }
    }else{
        _flacImg.hidden = YES;
        _mvImg.left = 12;
        if (model.hasMV) {
            _mvImg.hidden = NO;
            _countImg.left = 38;
        }else{
            _mvImg.hidden = YES;
            _countImg.left = 12;
        }
    }
    _countLab.left = _countImg.right + 1;
    _singerLab.left = _countLab.right + 4;
}


@end
