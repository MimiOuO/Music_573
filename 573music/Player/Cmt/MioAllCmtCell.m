//
//  MioAllCmtCell.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2020/6/16.
//  Copyright © 2020 Brance. All rights reserved.
//

#import "MioAllCmtCell.h"
//#import "UIView+Common.h"
#import "SDAutoLayout.h"
@interface MioAllCmtCell()
@property (nonatomic, strong) UIImageView *avatatImage;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *timeAndAdress;
@property (nonatomic, strong) UIView *replayView;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UILabel *likeLab;
@end

@implementation MioAllCmtCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = appClearColor;
        WEAKSELF;
        _avatatImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        _avatatImage.layer.cornerRadius = 18;
        _avatatImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatatImage];


        _nickName = [UILabel creatLabelinView:self.contentView text:@"" color:color_text_one size:14];
        _nickName.font = [UIFont boldSystemFontOfSize:14];
        
        _likeBtn = [MioButton creatBtn:frame(KSW_Mar - 20, 10, 20, 20) inView:self.contentView bgImage:@"pinglun_wiedianzan" bgTintColorName:name_icon_three action:nil];
        
        _likeLab = [UILabel creatLabel:frame(KSW - 38 - 50, 12, 50, 18) inView:self.contentView text:@"0" color:color_text_three size:14 alignment:NSTextAlignmentRight];

        
        _content = [UILabel creatLabelinView:self.contentView text:@"" color:color_text_two size:14];
        _content.numberOfLines = 0;
//        [_content whenTapped:^{
//            if (weakSelf.replyBlock) {
//                weakSelf.replyBlock(self);
//            }
//        }];
        _timeAndAdress = [UILabel creatLabelinView:self.contentView text:@"" color:color_text_two size:12];
        
//        _praiseButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        _praiseButton.frame = CGRectMake(KSW - 70, 14, 40, 40);
//        [_praiseButton setImage:[UIImage imageNamed:@"icon_dianzan1"] forState:UIControlStateNormal];
//        [_praiseButton setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateSelected];
//        [_praiseButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, -5)];
//        [_praiseButton addTarget:self action:@selector(clickPraise:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_praiseButton];
//
//        _praiseLab = [[UILabel alloc] initWithFrame:CGRectMake(_praiseButton.right - 5, 14, 50, 40)];
//        _praiseLab.textColor = grayTextColor;
//        [self.contentView addSubview:_praiseLab];
//        _praiseLab.font = [UIFont boldSystemFontOfSize:14];
        
        UIView *split = [[UIView alloc] init];
        split.backgroundColor = grayTextColor;
        [self.contentView addSubview:split];

        UIView *contentView = self.contentView;
        _avatatImage.sd_layout.leftSpaceToView(contentView, 22).topSpaceToView(contentView, 16).widthIs(36).heightIs(36);
        _nickName.sd_layout.leftSpaceToView(_avatatImage, 6).topSpaceToView(contentView, 16 + 3).widthIs(200).heightIs(14);
        _timeAndAdress.sd_layout.leftSpaceToView(_avatatImage, 6).topSpaceToView(_nickName, 4).widthIs(200).heightIs(12);
        _content.sd_layout.leftSpaceToView(_avatatImage, 6).topSpaceToView(_avatatImage, 8).rightSpaceToView(contentView, 16).autoHeightRatio(0);
        
        split.sd_layout.leftSpaceToView(contentView, 16).topSpaceToView(_content, 8).widthIs(KSW - 16).heightIs(0);
        [self setupAutoHeightWithBottomView:split bottomMargin:0];
    }
    return self;
}

- (void)setReplyModel:(MioCmtModel *)replyModel{
   
    [_avatatImage sd_setImageWithURL:replyModel.from_user.avatar.mj_url placeholderImage:[UIImage imageNamed:@"qxt_yonhu"]];
    _nickName.text = replyModel.from_user.nickname;
//    if ([replyModel.comment_status isEqualToString:@"1"]) {
//        _praiseButton.selected = YES;
//    } else {
//        _praiseButton.selected = NO;
//    }
//    _praiseLab.text = replyModel.zan_num;
//    _nickName.textColor = appNickColor(replyModel.user.levelNum);
     NSString *timeStr = [NSString stringWithFormat:@"%@",replyModel.created_at];
    NSString *replyDicStr = [NSString stringWithFormat:@"回复%@：%@",replyModel.to_user.nickname,replyModel.content];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:replyDicStr];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:color_text_one range:NSMakeRange(2, replyModel.to_user.nickname.length)];
    _content.attributedText = AttributedStr;
    _timeAndAdress.text = [NSDate intervalFromNoewDateWithString:timeStr];
   
    
    _likeLab.text = replyModel.like_num;
    [_likeBtn whenTapped:^{
        [self likeClick:replyModel.comment_id];
    }];
    if (replyModel.is_like) {
        _likeBtn.selected = YES;
        [_likeBtn setTintColor:color_main];
        _likeLab.textColor = color_main;
    }else{
        _likeBtn.selected = NO;
        [_likeBtn setTintColor:color_text_three];
        _likeLab.textColor = color_text_three;
    }
}

-(void)likeClick:(NSString *)cmtId{
    [MioPostReq(api_likes, (@{@"model_name":@"comment",@"model_ids":@[cmtId]})) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _likeBtn.selected = !_likeBtn.selected;
        if (_likeBtn.selected == YES) {
            [_likeBtn setTintColor:color_main];
            _likeLab.textColor = color_main;
        }else{
            [_likeBtn setTintColor:color_text_three];
            _likeLab.textColor = color_text_three;
        }
        [UIWindow showSuccess:@"操作成功"];
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}

@end
