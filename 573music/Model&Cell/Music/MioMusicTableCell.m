//
//  MioMusicTableCell.m
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMusicTableCell.h"

@interface MioMusicTableCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *flacImg;
@property (nonatomic, strong) UIImageView *mvImg;
@property (nonatomic, strong) UILabel *singerLab;
@end

@implementation MioMusicTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cover = [UIImageView creatImgView:frame(0, 6, 60, 60) inView:self.contentView image:@"" radius:4];
        _nameLab = [UILabel creatLabel:frame(_cover.right + 8, 16, KSW - 84 - 38, 16) inView:self.contentView text:@"你好啊哦哦啊好" color:color_text_one size:16 alignment:NSTextAlignmentLeft];
        _flacImg = [UIButton creatBtn:frame(_cover.right + 8, _nameLab.bottom + 5, 22, 12) inView:self.contentView bgImage:@"" bgTintColor:color_main action:^{
            
        }];
        _flacImg = [UIImageView creatImgView:frame(_cover.right + 8, _nameLab.bottom + 5, 22, 12) inView:self.contentView image:@"playlist_nondestructive" bgTintColor:color_main radius:0];

    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    
}

@end
