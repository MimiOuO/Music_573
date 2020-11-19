//
//  JJCardSliderCell.m
//  CardSliderDome
//
//  Created by  张礼栋 on 2019/12/10.
//  Copyright © 2019 mobile. All rights reserved.
//

#import "JJCardSliderCell.h"

@interface JJCardSliderCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIImageView *iconView;
@end

@implementation JJCardSliderCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.shadowOffset = CGSizeMake(0, 3);
        self.contentView.layer.shadowRadius = 12;
        self.contentView.layer.shadowOpacity = 0.1;
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)setCellData:(id)data
{
//    NSMutableString *mStr = [NSMutableString stringWithString:@"活动标签"];
//    if (mStr.length >= 2) {
//        [mStr insertString:@"\n" atIndex:2];
//    }
//    self.tagLabel.text = mStr;
    [self.imageView sd_setImageWithURL:Url(data) placeholderImage:image(@"defaultPic")];
//    self.imageView.image = data;//用SDWebImage
}

- (void)setupUI
{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.iconView];
    [self.iconView addSubview:self.tagLabel];
}

- (void)layout
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(2, 0, 0, 0));
    }];

    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_left).offset(10);
        make.top.equalTo(self.imageView.mas_top).offset(-2);
        make.height.equalTo(@(42));
        make.width.equalTo(@(34));
    }];

    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.iconView);
        make.bottom.equalTo(self.iconView).offset(-2);
    }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 12;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"icon_taglabel"];
    }
    return _iconView;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.numberOfLines = 0;
        _tagLabel.font = [UIFont boldSystemFontOfSize:9];
        _tagLabel.textColor = [UIColor orangeColor];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    /* 尽量不要在此约束，卡片轮播此会不停调用，若没限制会不停增加约束就会不停增长内存*/
    //[self layout];
}
@end
