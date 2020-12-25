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
@property (nonatomic, strong) UIImageView *flacImg;
@property (nonatomic, strong) UIImageView *mvImg;
@end


@implementation MioMutipleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.multipleSelectionBackgroundView = [UIView new];
        self.tintColor = [UIColor redColor];
        self.backgroundColor = appClearColor;
        
        _titleLab = [UILabel creatLabel:frame(16, 6, KSW - 66, 22) inView:self.contentView text:@"" color:color_text_one boldSize:16 alignment:NSTextAlignmentLeft];
        _flacImg = [UIImageView creatImgView:frame(16, 34, 22, 12) inView:self.contentView image:@"playlist_nondestructive" radius:0];
        _mvImg = [UIImageView creatImgView:frame(16, 34, 22, 12) inView:self.contentView image:@"playlist_mv" radius:0];
        _singerLab = [UILabel creatLabel:frame(0, 32, 200, 17) inView:self.contentView text:@"" color:color_text_two size:12 alignment:NSTextAlignmentLeft];

        
    }
    return self;
}

- (void)setMusic:(MioMusicModel *)music{
    _titleLab.text = music.title;
    if (music.hasFlac) {
        _flacImg.hidden = NO;
        _mvImg.left = 42;
        if (music.hasMV) {
            _mvImg.hidden = NO;
            _singerLab.left = 68;
        }else{
            _mvImg.hidden = YES;
            _singerLab.left = 42;
        }
    }else{
        _flacImg.hidden = YES;
        _mvImg.left = 16;
        if (music.hasMV) {
            _mvImg.hidden = NO;
            _singerLab.left = 42;
        }else{
            _mvImg.hidden = YES;
            _singerLab.left = 20;
        }
    }
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
                        img.image=[UIImage imageNamed:@"xuanze_yixuan"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"xuanze_weixuan"];
                    }
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
