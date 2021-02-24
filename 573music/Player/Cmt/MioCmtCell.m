//
//  MioCmtCell.m
//  573music
//
//  Created by Mimio on 2021/1/4.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioCmtCell.h"
#import "NSDate+Helper.h"
@interface MioCmtCell()
@property (nonatomic, strong) UIImageView *avatatImage;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *timeAndAdress;
@property (nonatomic, strong) UIView *replayView;
@property (nonatomic, strong) UILabel *allcmtLab;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UILabel *likeLab;
@end

@implementation MioCmtCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        WEAKSELF;

        _avatatImage = [UIImageView creatImgView:frame(0, 0, 40, 40) inView:self.contentView image:@"" radius:20];

        _nickName = [UILabel creatLabel:frame(0, 0, 0, 0) inView:self.contentView text:@"" color:color_text_one boldSize:14 alignment:NSTextAlignmentLeft];

        _likeBtn = [MioButton creatBtn:frame(KSW_Mar - 20, 10, 20, 20) inView:self.contentView bgImage:@"pinglun_wiedianzan" bgTintColorName:name_icon_three action:nil];
        
        _likeLab = [UILabel creatLabel:frame(KSW - 38 - 50, 12, 50, 18) inView:self.contentView text:@"0" color:color_text_three size:14 alignment:NSTextAlignmentRight];

        
        _content = [UILabel creatLabel:frame(0, 0, 0, 0) inView:self.contentView text:@"" color:color_text_one size:14 alignment:NSTextAlignmentLeft];
        
        [_content whenTapped:^{
            if (weakSelf.cmtBlock) {
                weakSelf.cmtBlock(self);
            }
        }];

        _allcmtLab = [UILabel creatLabel:frame(0, 0, 0, 0) inView:self.contentView text:@"" color:color_text_two size:12 alignment:NSTextAlignmentLeft];
        
        [_allcmtLab whenTapped:^{
            if (weakSelf.replyBlock) {
                weakSelf.replyBlock(self);
            }
        }];
        
        _timeAndAdress = [UILabel creatLabel:frame(0, 0, 0, 0) inView:self.contentView text:@"" color:color_text_two size:12 alignment:NSTextAlignmentLeft];
        
        _replayView = [UIView creatView:frame(0, 0, 0, 0) inView:self.contentView bgColor:color_card radius:4];
        
        

        UIView *split = [[UIView alloc] init];
        split.backgroundColor = grayTextColor;
        [self.contentView addSubview:split];
        
        UIView *contentView = self.contentView;
        _avatatImage.sd_layout.leftSpaceToView(contentView, 16).topSpaceToView(contentView, 16).widthIs(40).heightIs(40);
        _nickName.sd_layout.leftSpaceToView(_avatatImage, 8).topSpaceToView(contentView, 16 + 1).widthIs(200).heightIs(20);
        _timeAndAdress.sd_layout.leftSpaceToView(_avatatImage, 8).topSpaceToView(_nickName, 1).widthIs(200).heightIs(17);
        _content.sd_layout.leftSpaceToView(_avatatImage, 8).topSpaceToView(_avatatImage, 8).rightSpaceToView(contentView, 16).autoHeightRatio(0);
        _allcmtLab.sd_layout.leftSpaceToView(_avatatImage, 8).topSpaceToView(_content, 10).rightSpaceToView(contentView, 16).heightIs(12);
        _replayView.sd_layout.leftSpaceToView(_avatatImage, 8).topSpaceToView(_allcmtLab, 10).rightSpaceToView(contentView, 16);
        [_replayView whenTapped:^{
            if (weakSelf.replyBlock) {
                weakSelf.replyBlock(self);
            }
        }];
        
        split.sd_layout.leftSpaceToView(contentView, 16).topSpaceToView(_replayView, 8).widthIs(KSW - 16).heightIs(0);
        [self setupAutoHeightWithBottomView:split bottomMargin:0];
    }
    return self;
}

- (void)setCmtModel:(MioCmtModel *)cmtModel{
    _cmtModel = cmtModel;
    [_avatatImage sd_setImageWithURL:cmtModel.from_user.avatar.mj_url placeholderImage:[UIImage imageNamed:@"qxt_yonhu"]];
    _nickName.text = cmtModel.from_user.nickname;
//    if ([cmtModel.comment_status isEqualToString:@"1"]) {
//        _praiseButton.selected = YES;
//    } else {
//        _praiseButton.selected = NO;
//    }
//    _praiseLab.text = cmtModel.zan_num;
//    _nickName.textColor = appNickColor(cmtModel.user.levelNum);
    _content.text = cmtModel.content;
//    NSString *timeStr = [NSString stringWithFormat:@"%@",cmtModel.createtime];
    if (cmtModel.sub_comments.count > 0) {
        _allcmtLab.text = [NSString stringWithFormat:@"%lu条回复>",(unsigned long)cmtModel.sub_comments.count];
        _allcmtLab.sd_layout.topSpaceToView(_content, 10).heightIs(12);
    }else{
        _allcmtLab.sd_layout.topSpaceToView(_content, 0).heightIs(0);
    }
    
    _timeAndAdress.text = [NSDate intervalFromNoewDateWithString:cmtModel.created_at];
    [_replayView removeAllSubviews];
    NSMutableArray *bendiArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < cmtModel.sub_comments.count ; i++) {
        MioCmtModel *subcmtModel = [MioCmtModel mj_objectWithKeyValues:cmtModel.sub_comments[i]];
        if (Equals(subcmtModel.isBendi, @"1")) {
            [bendiArr addObject:cmtModel.sub_comments[i]];
        }
    }
    
    if (bendiArr.count > 0) {
        CGFloat totalHeight = 0;
        for (int i = 0; i<bendiArr.count ; i++) {
            
            
            MioCmtModel *reply = bendiArr[i];
            NSString *replyDicStr = [NSString stringWithFormat:@"%@回复%@：%@",reply.from_user.nickname,reply.to_user.nickname,reply.content];
            CGFloat replayHeight = [replyDicStr heightForFont:Font(13) width:(KSW - 66)];
            
            UILabel *replayLab = [UILabel creatLabel:CGRectMake(8, 8 * (i + 1)+ totalHeight, KSW - 83, replayHeight) inView:_replayView text:replyDicStr color:color_text_two size:13 alignment:NSTextAlignmentLeft];
            
            
            
            replayLab.numberOfLines = 0;
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:replyDicStr];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:color_text_one range:NSMakeRange(0, reply.from_user.nickname.length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:color_text_one range:NSMakeRange(reply.from_user.nickname.length + 2, reply.from_user.nickname.length)];
            replayLab.attributedText = AttributedStr;
            totalHeight = totalHeight + replayHeight;
        }
        _replayView.sd_layout.topSpaceToView(_allcmtLab, 10).heightIs(totalHeight + (bendiArr.count + 1) * 8 );
    }else{
        _replayView.sd_layout.topSpaceToView(_allcmtLab, 0).heightIs(0);
    }
    
    
    _likeLab.text = cmtModel.like_num;
    [_likeBtn whenTapped:^{
        [self likeClick:cmtModel.comment_id];
    }];
    if (cmtModel.is_like) {
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
            _likeLab.text = [NSString stringWithFormat:@"%d",([_likeLab.text intValue] + 1)];
            _cmtModel.is_like = YES;
            _cmtModel.like_num = _likeLab.text;
        }else{
            [_likeBtn setTintColor:color_text_three];
            _likeLab.textColor = color_text_three;
            _likeLab.text = [NSString stringWithFormat:@"%d",([_likeLab.text intValue] - 1)];
            _cmtModel.is_like = NO;
            _cmtModel.like_num = _likeLab.text;
        }
        WEAKSELF;
       
        if (weakSelf.likeBlock) {
            weakSelf.likeBlock(self);
        }

        [UIWindow showSuccess:@"操作成功"];
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}

@end
