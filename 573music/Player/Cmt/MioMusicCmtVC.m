//
//  MioMusicCmtVC.m
//  573music
//
//  Created by Mimio on 2021/1/4.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMusicCmtVC.h"
#import "YDCommentInputView.h"
#import "MioMusicAllCmtVC.h"
#import "MioCmtCell.h"
@interface MioMusicCmtVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YDCommentInputViewDelegate,MioRefreshMusicCmtDelegate>
@property (nonatomic, strong) UIView *cmtToolView;
@property (nonatomic, strong) UITextField *cmtTextField;
@property (nonatomic, strong) UIButton *cmtBtn;
@property (assign, nonatomic) int message;/*消息类型*/
@property (strong, nonatomic) YDCommentInputView *commentInputView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray<MioCmtModel *> *dataArr;
@end

@implementation MioMusicCmtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"全部评论" forState:UIControlStateNormal];
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    [self requestData];
    [self creatUI];
}

-(void)requestData{
    [MioGetReq(api_songCmt(_musicId), @{@"page":Str(_page)}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        [self.tableView.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        if (data.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_dataArr addObjectsFromArray:[MioCmtModel mj_objectArrayWithKeyValuesArray:data]];
        [_tableView reloadData];
        
    } failure:^(NSString *errorInfo) {}];
}

-(void)creatUI{
    _tableView = [UITableView creatTable:frame(0, NavH, KSW, KSH - NavH - 44 - SafeBotH) inView:self.view vc:self];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self requestData];
    }];
    //======================================================================//
    //                               评论条
    //======================================================================//
    UIView *bottomView = [UIView creatView:frame(0, KSH - 44 - SafeBotH, KSW, 44 + SafeBotH) inView:self.view bgColor:color_input_bg];
    bottomView.layer.shadowColor = rgba(0, 0, 0, 1).CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(0, -2);
    bottomView.layer.shadowOpacity = 0.06;

    MioImageView *bgImg = [MioImageView creatImgView:frame(0, 0, KSW, 44 + SafeBotH) inView:bottomView skin:SkinName image:@"picture_li" radius:0];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YDCommentInputView" owner:self options:nil];
    self.commentInputView = [nib objectAtIndex:0];
    self.commentInputView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, _commentInputView.frame.size.height);
    //        [self.view addSubview:_commentInputView];
    self.commentInputView.delegate = self;
    [self.commentInputView.commentInputTextField becomeFirstResponder];
    [self.commentInputView.commentInputTextField resignFirstResponder];
    
    UIView *clickView = [UIView creatView:frame(Mar, 8, KSW_Mar - 44, 32) inView:bottomView bgColor:appClearColor radius:16];
    clickView.layer.borderWidth = 1;
    clickView.layer.borderColor = color_input_line.CGColor;
    [clickView whenTapped:^{
        self.message = 0;
        self.commentInputView.commentInputTextField.text = self.cmtTextField.text;
        self.commentInputView.commentInputTextField.placeholder = @"写评论(最多120字)...";
        [self.commentInputView showInputView];
    }];

    _cmtTextField = [[UITextField alloc] initWithFrame:CGRectMake(Mar, 0, clickView.width - 32 - 16, 32)];
    _cmtTextField.placeholder = @"请输入内容";
    _cmtTextField.font = Font(14);
    _cmtTextField.textColor = color_text_one;
    _cmtTextField.userInteractionEnabled = NO;
    [clickView addSubview:_cmtTextField];
    
    
    MioButton *sendBtn = [MioButton creatBtn:frame(KSW_Mar - 20 , 14, 20, 20) inView:bottomView bgImage:@"pinglun_fabu" bgTintColorName:name_main action:^{
        [self sendCmt:_cmtTextField.text];
    }];
}

-(void)sendCmt:(NSString *)content{
    goLogin;
    if (content.length == 0) {
        [UIWindow showInfo:@"评论内容不能为空"];
        return;
    }
    NSDictionary *dic = @{};
    if (self.message == 0) {
        dic = @{
            @"model_name":@"song",
            @"model_id":_musicId,
            @"content":content,
        };
    } else {
        dic = @{
            @"model_name":@"song",
            @"model_id":_musicId,
            @"content":content,
            @"pid":self.commentInputView.pid,
            @"tid":self.commentInputView.pid,
        };
    }

    [MioPostReq(api_sendCmt, dic) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        MioCmtModel *cmtModel = [MioCmtModel mj_objectWithKeyValues:data[0]];
        cmtModel.isBendi = @"1";
        [UIWindow showInfo:@"评论成功"];
        PostNotice(@"updateCmt");
        _cmtTextField.text = @"";
        _page = 1;
        if (self.message == 0) {
            [self requestData];
        }else{
            for (int i = 0;i < _dataArr.count; i++) {
                if (Equals(self.commentInputView.pid, ((MioCmtModel *)_dataArr[i]).comment_id)) {
                    NSMutableArray *tempSubArr = [((MioCmtModel *)_dataArr[i]).sub_comments mutableCopy];
                    [tempSubArr insertObject:cmtModel atIndex:0];
                    ((MioCmtModel *)_dataArr[i]).sub_comments = tempSubArr;
                }
            }
            [_tableView reloadData];
        }
        
    } failure:^(NSString *errorInfo) {
        NSLog(@"%@",errorInfo);
    }];
}

#pragma mark - 键盘代理
- (void)commentInputView:(YDCommentInputView *)anInputView onSendText:(NSString *)aText
{
    [self sendCmt:aText];
}

- (void)didHideCommentInputView:(YDCommentInputView *)anInputView onSendText:(NSString *)aText{
    _cmtTextField.text = aText;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class currentClass = [MioCmtCell class];
    MioCmtModel *model = _dataArr[indexPath.row];
    
    CGFloat height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"cmtModel" cellClass:currentClass contentViewWidth:KSW];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MioCmtCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MioCmtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MioCmtModel *cmtModel = _dataArr[indexPath.row];
    cell.cmtModel = cmtModel;
    cell.replyBlock = ^(MioCmtCell * cell) {
        MioMusicAllCmtVC *vc = [[MioMusicAllCmtVC alloc] init];
        vc.delegate = self;
        vc.cmtModel = _dataArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.cmtBlock = ^(MioCmtCell * cell) {
        self.message = 1;
        self.commentInputView.reply_user_id = cmtModel.from_user.user_id;
        self.commentInputView.pid = cmtModel.comment_id;
        self.commentInputView.commentInputTextField.placeholder = [NSString stringWithFormat:@"回复%@(最多120字)...",cmtModel.from_user.nickname];
        [self.commentInputView showInputView];
    };
    cell.likeBlock = ^(MioCmtCell * cell) {
        [_dataArr replaceObjectAtIndex:indexPath.row withObject:cell.cmtModel];
    };
    return cell;
}

-(void)refreshCmt{
    _page = 1;
    [self requestData];
}

- (void)likeCmt:(MioCmtModel *)cmtModel{
    for (int i = 0;i < _dataArr.count; i++) {
        if (Equals(_dataArr[i].comment_id, cmtModel.comment_id)) {
            [_dataArr replaceObjectAtIndex:i withObject:cmtModel];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


@end
