//
//  MioLikeAndCmtNoticeCell.m
//  573music
//
//  Created by Mimio on 2021/1/20.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLikeAndCmtNoticeCell.h"
#import "MioMusicCmtVC.h"
#import "MioMvVC.h"
#import "MioSongListVC.h"
@interface MioLikeAndCmtNoticeCell()
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) MioLabel *nameLab;
@property (nonatomic, strong) MioLabel *tipLab;
@property (nonatomic, strong) MioLabel *timeLab;
@property (nonatomic, strong) MioLabel *contentLab;
@property (nonatomic, strong) MioLabel *myCmtLab;
@property (nonatomic, strong) MioLabel *fromeLab;
@property (nonatomic, strong) MioView *split;
@property (nonatomic, strong) UIImageView *reddot;
@end

@implementation MioLikeAndCmtNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
    
        _bgView = [UIView creatView:frame(0, 0, KSW_Mar2, 0) inView:self bgColor:color_card radius:0];
        
        _avatar = [UIImageView creatImgView:frame(12, 12, 40, 40) inView:self.contentView image:@"qxt_geshou" radius:20];
        _nameLab = [MioLabel creatLabel:frame(_avatar.right + 8, 13, 250, 20) inView:self.contentView text:@"" colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
        
        _tipLab = [MioLabel creatLabel:frame(_avatar.right + 8, _nameLab.bottom, KSW - 92 - 60, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        _timeLab = [MioLabel creatLabel:frame(_tipLab.right + 4, _nameLab.bottom + 2, 120, 14) inView:self.contentView text:@"" colorName:name_text_two size:10 alignment:NSTextAlignmentLeft];
        _contentLab = [MioLabel creatLabel:frame(_avatar.right + 8, 63, (KSW - 76 -47), 0) inView:self.contentView text:@"" colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
        _contentLab.numberOfLines = 0;
        _myCmtLab = [MioLabel creatLabel:frame(_avatar.right + 8, _contentLab.bottom + 2, (KSW - 76 -47), 0) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        _myCmtLab.numberOfLines = 0;
        _fromeLab = [MioLabel creatLabel:frame(_avatar.right + 8, _myCmtLab.bottom + 12, (KSW - 76 -47), 20) inView:self.contentView text:@"" colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
        _split = [MioView creatView:frame(60, _fromeLab.bottom + 12, KSW - 76 -28, 0.5) inView:self bgColorName:name_split radius:0];
        _reddot = [UIImageView creatImgView:frame(KSW_Mar2-14, 0, 14, 14) inView:_bgView image:@"tongzhi_new" radius:0];
        _reddot.hidden = YES;
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic{
    [_avatar sd_setImageWithURL:dic[@"data"][@"from_user"][@"avatar"] placeholderImage:image(@"qxt_yonhu")];
    _nameLab.text = dic[@"data"][@"from_user"][@"nickname"];
    NSString *action = Equals(dic[@"data"][@"action"], @"reply")?@"回复":(Equals(dic[@"data"][@"model"], @"comment")?@"赞":@"喜欢");
    NSString *type = Equals(dic[@"data"][@"model"], @"comment")?@"评论":@"歌单";
    _tipLab.text = [NSString stringWithFormat:@"%@你的%@",action,type];
    _tipLab.width = [_tipLab.text widthForFont:Font(12)];
    _timeLab.left = _tipLab.right + 4;
    _timeLab.text = [NSDate intervalFromNoewDateWithString:dic[@"created_at"]];
    _fromeLab.text = [NSString stringWithFormat:@"来自%@：%@ >",Equals(dic[@"data"][@"from"], @"type")?@"歌单":(Equals(dic[@"data"][@"from"][@"type"], @"song")?@"歌曲":@"视频"),dic[@"data"][@"from"][@"title"]];
    
    if (Equals(type, @"歌单")) {
        _contentLab.text = @"";
        _myCmtLab.text = @"";
        _contentLab.height = 0;
        _myCmtLab.height = 0;
        _myCmtLab.top = _contentLab.bottom+ 2;
        _fromeLab.top = _tipLab.bottom + 12;
    }else if (Equals(action, @"赞")){
        _contentLab.text = dic[@"data"][@"extra"][@"my_content"];
        _contentLab.height = [_contentLab.text heightForFont:Font(14) width:(KSW - 76 -47)];
        _myCmtLab.text = @"";
        _myCmtLab.height = 0;
        _myCmtLab.top = _contentLab.bottom + 2;
        _fromeLab.top = _contentLab.bottom + 12;
    }else{
        _contentLab.text = dic[@"data"][@"content"];
        _contentLab.height = [_contentLab.text heightForFont:Font(14) width:(KSW - 76 -47)];
        _myCmtLab.text = [NSString stringWithFormat:@"我的评论：%@",dic[@"data"][@"extra"][@"my_content"]];
        _myCmtLab.height = [_contentLab.text heightForFont:Font(12) width:(KSW - 76 -47)];
        _myCmtLab.top = _contentLab.bottom+ 2;
        _fromeLab.top = _myCmtLab.bottom + 12;
    }
    _split.top = _fromeLab.bottom + 12;
    _bgView.height = _fromeLab.bottom + 12;
    
    [_fromeLab whenTapped:^{
        if ([_fromeLab.text containsString:@"来自歌曲"]) {
            MioMusicCmtVC *vc = [[MioMusicCmtVC alloc] init];
            vc.musicId = dic[@"data"][@"from"][@"id"];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        if ([_fromeLab.text containsString:@"来自视频"]) {
            MioMvVC *vc = [[MioMvVC alloc] init];
            vc.mvId = dic[@"data"][@"from"][@"id"];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        if ([_fromeLab.text containsString:@"来自歌单"]) {
            MioSongListVC *vc = [[MioSongListVC alloc] init];
            vc.songlistId = dic[@"data"][@"from"][@"id"];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    NSString *isread = dic[@"is_read"];
    if ([isread intValue] == 0) {
        _reddot.hidden = NO;
    }else{
        _reddot.hidden = YES;
    }
    [self sendSubviewToBack:_bgView];
}

@end
