//
//  TestCell.m
//  tableview
//
//  Created by 苏凡 on 2017/1/19.
//  Copyright © 2017年 sf. All rights reserved.
//

#import "MioMutipleCell.h"
@interface MioMutipleCell()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *singerLab;
@property (nonatomic, strong) MioImageView *flacImg;
@property (nonatomic, strong) MioImageView *mvImg;
@property (nonatomic, strong) MioImageView *officialImg;
@property (nonatomic, strong) MioImageView *vipImg;

@end


@implementation MioMutipleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.multipleSelectionBackgroundView = [UIView new];
        self.tintColor = [UIColor redColor];
        self.backgroundColor = appClearColor;
        
        _titleLab = [UILabel creatLabel:frame(16, 6, KSW - 66, 22) inView:self.contentView text:@"" color:color_text_one boldSize:16 alignment:NSTextAlignmentLeft];

        _flacImg = [MioImageView creatImgView:frame(-100, 34, 22, 12) inView:self.contentView image:@"playlist_nondestructive" bgTintColorName:name_main radius:0];
        _mvImg = [MioImageView creatImgView:frame(-100 ,34, 22, 12) inView:self.contentView image:@"playlist_mv" bgTintColorName:name_main radius:0];
        _officialImg = [MioImageView creatImgView:frame(-100, 34, 22, 12) inView:self.contentView image:@"playlist_zhengban" bgTintColorName:name_main radius:0];
        _vipImg = [MioImageView creatImgView:frame(-100 ,34, 22, 12) inView:self.contentView image:@"playlist_vip" bgTintColorName:name_main radius:0];
        _singerLab = [UILabel creatLabel:frame(0, 32, 200, 17) inView:self.contentView text:@"" color:color_text_two size:12 alignment:NSTextAlignmentLeft];

        
    }
    return self;
}

- (void)setMusic:(MioMusicModel *)music{
    _titleLab.text = music.title;

    _flacImg.hidden = YES;
    _mvImg.hidden = YES;
    _officialImg.hidden = YES;
    _vipImg.hidden = YES;
    NSMutableArray *tagArr = [[NSMutableArray alloc] init];
    if (music.hasFlac) {
        _flacImg.hidden = NO;
        [tagArr addObject:_flacImg];
    }
    if (music.hasMV) {
        _mvImg.hidden = NO;
        [tagArr addObject:_mvImg];
    }
    if (music.official) {
        _officialImg.hidden = NO;
        [tagArr addObject:_officialImg];
    }
    if (music.need_vip) {
        _vipImg.hidden = NO;
        [tagArr addObject:_vipImg];
    }
    
    for (int i = 0;i < tagArr.count; i++) {
        ((UIView *)tagArr[i]).left = 16 + i * 26;
    }

    _singerLab.left = 16 + tagArr.count * 26;
    _singerLab.text = music.singer_name;
}


-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[[UIImage imageNamed:@"xuanze_yixuan"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
                    }else
                    {
                        img.image=[[UIImage imageNamed:@"xuanze_weixuan"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
                    }
                    img.tintColor = color_main;
                }
            }
        }
    }
    [super layoutSubviews];
}

//适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"weixuanzhong_icon"];
                    }
                }
            }
        }
    }
    
}




@end
