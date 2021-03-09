//
//  MioMusicPlaylistCell.m
//  573music
//
//  Created by Mimio on 2021/1/13.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMusicPlaylistCell.h"

@interface MioMusicPlaylistCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) MioLabel *nameLab;
@property (nonatomic, strong) MioImageView *flacImg;
@property (nonatomic, strong) MioImageView *mvImg;
@property (nonatomic, strong) MioLabel *singerLab;
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) UIImageView *playIcon;
@end

@implementation MioMusicPlaylistCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        
        _nameLab = [MioLabel creatLabel:frame(Mar, 0, KSW - 16 - 40, 44) inView:self.contentView text:@"" colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
//        _flacImg = [MioImageView creatImgView:frame(0,Mar, 22, 12) inView:self.contentView image:@"playlist_nondestructive" bgTintColorName:name_main radius:0];
//        _mvImg = [MioImageView creatImgView:frame(0, Mar, 22, 12) inView:self.contentView image:@"playlist_mv" bgTintColorName:name_main radius:0];
//        _singerLab = [MioLabel creatLabel:frame(0, 0, 0, 44) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        MioImageView *icon = [MioImageView creatImgView:frame(KSW - 32, 14, 16, 16) inView:self.contentView image:@"liebiao_qingchu" bgTintColorName:name_icon_three radius:0];
        [icon whenTapped:^{
            if (self.deleteBlock) {
                self.deleteBlock(self);
            }
        }];
        
        _fromView = [UIView creatView:frame(KSW - 38 - 60 , 11, 60, 22) inView:self.contentView bgColor:appClearColor radius:11];
        _fromView.layer.borderColor = color_icon_three.CGColor;
        _fromView.layer.borderWidth = 0.5;
        
        MioLabel *fromLab = [MioLabel creatLabel:frame(0, 0, 60, 22) inView:_fromView text:@"播放来源" colorName:name_text_one size:10 alignment:NSTextAlignmentCenter];
        
        _playIcon = [MioImageView creatImgView:frame(0, 10, 24, 24) inView:self.contentView image:@"state" bgTintColorName:name_main radius:0];

    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    _model = model;
    _nameLab.text = [NSString stringWithFormat:@"%@  %@",model.title,model.singer_name];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_nameLab.text];
    
    [text addAttribute:NSForegroundColorAttributeName
                     value:color_text_two
                 range:[_nameLab.text rangeOfString:model.singer_name]];
    _nameLab.attributedText = text;
    
    [_fromView whenTapped:^{
        if (self.fromClickBlock) {
            self.fromClickBlock(self);
        }
    }];
//    _singerLab.text = model.singer_name;
//    _nameLab.width = [_nameLab.text widthForFont:Font(14)];
//    if (_nameLab.width > (KSW - 54)*0.5 ) {
//        _nameLab.width = (KSW - 54)*0.5;
//    }
    
//    if (model.hasFlac) {
//        _flacImg.hidden = NO;
//        _flacImg.left = _nameLab.right + 4;
//        _mvImg.left = _flacImg.right + 4;
//        if (model.hasMV) {
//            _mvImg.hidden = NO;
//            _singerLab.left = _mvImg.right + 4;
//        }else{
//            _mvImg.hidden = YES;
//            _singerLab.left = _flacImg.right + 4;
//        }
//    }else{
//        _flacImg.hidden = YES;
//        _mvImg.left = _nameLab.right + 4;
//        if (model.hasMV) {
//            _mvImg.hidden = NO;
//            _singerLab.left = _mvImg.right + 4;
//        }else{
//            _mvImg.hidden = YES;
//            _singerLab.left = _nameLab.right + 4;
//        }
//    }
//    _singerLab.width = [_singerLab.text widthForFont:Font(12)];
//    if (_singerLab.width > (KSW - 54)*0.3 ) {
//        _singerLab.width = (KSW - 54)*0.3;
//    }
}

- (void)setIsplaying:(BOOL)isplaying{
    if (isplaying) {
        _nameLab.textColor = color_main;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",_model.title,_model.singer_name]];
        [text addAttribute:NSFontAttributeName
                         value:Font(12)
                         range:[_nameLab.text rangeOfString:_model.singer_name]];
        [text addAttribute:NSForegroundColorAttributeName
                         value:color_main
                     range:[_nameLab.text rangeOfString:_model.singer_name]];
        _nameLab.attributedText = text;
        _nameLab.width = KSW - 16 - 38 - 68;
        if (_model.fromModel != MioFromUnkown) {
            _fromView.hidden = NO;
        }else{
            _fromView.hidden = YES;
        }
        _playIcon.hidden = NO;
        _playIcon.left = [_model.title widthForFont:Font(14)] + [_model.singer_name widthForFont:Font(12)] + Mar + 12;
    }else{
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",_model.title,_model.singer_name]];
        [text addAttribute:NSFontAttributeName
                         value:Font(12)
                         range:[_nameLab.text rangeOfString:_model.singer_name]];
        [text addAttribute:NSForegroundColorAttributeName
                         value:color_text_one
                     range:[_nameLab.text rangeOfString:_model.title]];
        [text addAttribute:NSForegroundColorAttributeName
                         value:color_text_two
                     range:[_nameLab.text rangeOfString:_model.singer_name]];
        _nameLab.attributedText = text;
        _nameLab.width = KSW - 16 - 40;
        _fromView.hidden = YES;
        _playIcon.hidden = YES;
    }
}

@end
