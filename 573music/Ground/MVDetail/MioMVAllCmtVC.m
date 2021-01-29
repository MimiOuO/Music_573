//
//  MioMVAllCmtVC.m
//  573music
//
//  Created by Mimio on 2021/1/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMVAllCmtVC.h"
#import "MioAllCmtCell.h"
#import "YDCommentInputView.h"
#import "SDAutoLayout.h"
@interface MioMVAllCmtVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *replyTable;
@property (strong, nonatomic) YDCommentInputView *commentInputView;
@property (nonatomic, strong) NSMutableArray *replyArr;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UILabel *likeLab;
@end

@implementation MioMVAllCmtVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = appClearColor;
    self.bgImg.hidden = YES;

    UIView *closeView = [UIView creatView:frame(0, 0, KSW, StatusH + KSW * 9/16) inView:self.view bgColor:appClearColor radius:0];
    MioImageView *bgView = [MioImageView creatImgView:frame(0, StatusH + KSW * 9/16, KSW, KSH) inView:self.view skin:SkinName image:@"picture" radius:0];
    MioImageView *menuBg = [MioImageView creatImgView:frame(0, 0, KSW, 44) inView:bgView skin:SkinName image:@"picture_li" radius:0];
    MioLabel *title = [MioLabel creatLabel:frame(Mar, 0, 100, 44) inView:menuBg text:@"全部回复" colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
    UIButton *closeBtn = [UIButton creatBtn:frame(KSW - 56, StatusH + KSW * 9/16, 56, 44) inView:self.view bgImage:@"landing_icon_exit" bgTintColor:color_icon_one action:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [closeView whenTapped:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)setCmtModel:(MioCmtModel *)cmtModel{
    _cmtModel = cmtModel;
    _replyArr = cmtModel.sub_comments.mutableCopy;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSW, 0)];
    headerView.backgroundColor = appClearColor;
    UIView *cmtView = [UIView creatView:CGRectMake(Mar, Mar, KSW - 2*16, 0) inView:headerView bgColor:color_card];
    cmtView.layer.cornerRadius = 6;
    cmtView.layer.masksToBounds =  YES;
    
    UIImageView *avatatImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 36, 36)];
    [cmtView addSubview:avatatImage];
    avatatImage.layer.cornerRadius =  18;
    avatatImage.layer.masksToBounds = YES;
    [avatatImage sd_setImageWithURL:cmtModel.from_user.avatar.mj_url placeholderImage:image(@"qxt_yonhu")];
    
 
    UILabel *nickName = [UILabel creatLabelinView:cmtView text:cmtModel.from_user.nickname color:appBlackColor size:14];
    nickName.frame = CGRectMake(avatatImage.right + 6, 13, 200, 14);

    _likeBtn = [MioButton creatBtn:frame(KSW_Mar2 - 28, 18, 20, 20) inView:cmtView bgImage:@"pinglun_wiedianzan" bgTintColorName:name_icon_three action:nil];
    
    _likeLab = [UILabel creatLabel:frame(KSW_Mar - 46 - 50, 20, 50, 18) inView:cmtView text:@"0" color:color_text_three size:14 alignment:NSTextAlignmentRight];

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
    
    UILabel *timeAndAdress = [UILabel creatLabel:CGRectMake(avatatImage.right + 6, nickName.bottom + 4, 200, 12) inView:cmtView text:[NSDate intervalFromNoewDateWithString:cmtModel.created_at] color:rgba(125, 142, 165, 1) size:12 alignment:NSTextAlignmentLeft];
    
    UILabel *content = [UILabel creatLabel:CGRectMake(52, 51, KSW - 86, 0) inView:cmtView text:cmtModel.content color:color_text_one size:14];
    content.numberOfLines = 0;
    content.height = [content.text heightForFont:Font(14) width:KSW - 86];
    
    [cmtView whenTapped:^{
        
        self.commentInputView.pid = cmtModel.comment_id;
        self.commentInputView.commentInputTextField.placeholder = [NSString stringWithFormat:@"回复%@",cmtModel.from_user.nickname];
        [self.commentInputView showInputView];
    }];
    cmtView.height = content.height + 61;
    headerView.height = cmtView.height + 20;
    _replyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusH + KSW * 9/16 + 44, KSW, KSH - StatusH - KSW * 9/16 - 44)];
    _replyTable.backgroundColor = appClearColor;
    _replyTable.delegate = self;
    _replyTable.dataSource = self;
    _replyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _replyTable.tableHeaderView = headerView;
    [self.view addSubview:_replyTable];
    
//    self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view];
//    self.keyboard.topBar.top = kScreen_Height - 46.5 - IS_IPhoneX_All?34:0;

//    self.keyboard.delegate = self;
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YDCommentInputView" owner:self options:nil];
    self.commentInputView = [nib objectAtIndex:0];
    self.commentInputView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, _commentInputView.frame.size.height);
//            [self.view addSubview:_commentInputView];
    self.commentInputView.delegate = self;
    [self.commentInputView.commentInputTextField becomeFirstResponder];
    [self.commentInputView.commentInputTextField resignFirstResponder];
    

}

-(void)sendCmt:(NSString *)content{
    goLogin;
    if (content.length == 0) {
        [UIWindow showInfo:@"评论内容不能为空"];
        return;
    }
    NSDictionary *dic = @{
            @"model_name":@"mv",
            @"model_id":_cmtModel.commentable_id,
            @"content":content,
            @"pid":self.commentInputView.pid,
            @"tid":_cmtModel.comment_id,
        };

    [MioPostReq(api_sendCmt, dic) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        MioCmtModel *currentReplyModel = [MioCmtModel mj_objectWithKeyValues:data[0]];
//        cmtModel.isBendi = @"1";
        [UIWindow showInfo:@"评论成功"];
        PostNotice(@"mvCmtSuccess");
        NSMutableArray *tempSubArr = [_cmtModel.sub_comments mutableCopy];
        [tempSubArr insertObject:data[0] atIndex:0];
        _replyArr = tempSubArr;
        [_replyTable reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCmt)]) {
            [self.delegate refreshCmt];
        }
        
    } failure:^(NSString *errorInfo) {
        NSLog(@"%@",errorInfo);
    }];
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
            _cmtModel.is_like = YES;
            _cmtModel.like_num = _likeLab.text;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCmt)]) {
            [self.delegate refreshCmt];
        }
        [UIWindow showSuccess:@"操作成功"];
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _replyArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class currentClass = [MioAllCmtCell class];
    NSDictionary *cmtDic = _replyArr[indexPath.row];
    MioCmtModel *model = [MioCmtModel mj_objectWithKeyValues:cmtDic];
//
    CGFloat height = [_replyTable cellHeightForIndexPath:indexPath model:model keyPath:@"replyModel" cellClass:currentClass contentViewWidth:KSW];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioAllCmtCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioAllCmtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = appClearColor;
    MioCmtModel *replyModel = [MioCmtModel mj_objectWithKeyValues:_replyArr[indexPath.row]];
    WEAKSELF;
    cell.replyModel = replyModel;
        cell.tapReplyPraiseBlock = ^(MioAllCmtCell * cell) {
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MioCmtModel *replyModel = [MioCmtModel mj_objectWithKeyValues:_replyArr[indexPath.row]];
    self.commentInputView.pid = replyModel.comment_id;
    self.commentInputView.commentInputTextField.placeholder = [NSString stringWithFormat:@"回复%@",replyModel.from_user.nickname];
    [self.commentInputView showInputView];
}




#pragma mark - 键盘代理
- (void)commentInputView:(YDCommentInputView *)anInputView onSendText:(NSString *)aText
{
    [self sendCmt:aText];
}


@end
