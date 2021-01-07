//
//  HQIndexBannerSubview.m
//  HQCardFlowView
//
//  Created by Mr_Han on 2018/7/24.
//  Copyright © 2018年 Mr_Han. All rights reserved.
//  CSDN <https://blog.csdn.net/u010960265>
//  GitHub <https://github.com/HanQiGod>
//

#import "HQIndexBannerSubview.h"

@interface HQIndexBannerSubview()
@property (nonatomic, strong) UIImageView *effect;
@property (nonatomic, strong) UILabel *name;
@end

@implementation HQIndexBannerSubview

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _mainImageView = [UIImageView creatImgView:frame(0, 0, self.width,self.height) inView:self image:@"" radius:0];
//        _avatar = [[MioAvatarView alloc] initFrame:frame(IPHONE_X?25:20, 20, IPHONE_X?70:60, IPHONE_X?70:60) inView:self];
//        _effect = [UIImageView creatImgView:frame(0, 0, IPHONE_X? 120:100, IPHONE_X? 120:100) inView:self image:@"" radius:0];
//        _name = [UILabel creatLabel:frame(0, _avatar.bottom + (IPHONE_X?20:10), IPHONE_X? 120:100, 14) inView:self text:@"" color:appSubColor size:14  alignment:NSTextAlignmentCenter];

    }
    
    return self;
}

- (void)setData:(NSDictionary *)data{

    
//    if ([[data objectForKey:@"decoration_category"] isEqualToString:@"home_effects"]) {
//        [_effect sd_setImageWithURL:[data objectForKey:@"cover_image_path"]];
//        _avatar.hidden = YES;
//    }else{
//        [_avatar setAvatar:currentUserAvatar border:[data objectForKey:@"cover_image_path"]];
//        _effect.hidden = YES;
//    }
//    _name.text = [data objectForKey:@"decoration_name"];
}

- (void)singleCellTapAction:(UIGestureRecognizer *)gesture {
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(self.tag, self);
    }
}

- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    
    
    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    
    self.mainImageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
}



@end
