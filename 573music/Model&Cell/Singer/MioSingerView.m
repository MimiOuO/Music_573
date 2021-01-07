//
//  MioSingerView.m
//  573music
//
//  Created by Mimio on 2021/1/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioSingerView.h"

@interface MioSingerView()
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) MioLabel *singerNameLab;
@property (nonatomic, strong) MioLabel *fansCountLab;


@end

@implementation MioSingerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = appClearColor;
        
        _avatar = [UIImageView creatImgView:frame(0, 0, 56, 56) inView:self image:@"qxt_geshou" radius:28];
        
        _singerNameLab = [MioLabel creatLabel:frame(_avatar.right + 14, 8, KSW - 86 - 40, 22) inView:self text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _fansCountLab = [MioLabel creatLabel:frame(_avatar.right + 14, _singerNameLab.bottom + 2, KSW - 92 - 60, 17) inView:self text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    }
    return self;
}
- (void)setModel:(MioSingerModel *)model{
    [_avatar sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_geshou")];
    _singerNameLab.text = model.singer_name;
    _fansCountLab.text = [NSString stringWithFormat:@"粉丝%@",model.like_num];
    
}

@end
