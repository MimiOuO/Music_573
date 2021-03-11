//
//  MioMineVC.m
//  jgsschool
//
//  Created by Mimio on 2020/9/18.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMineVC.h"
#import "MioSonglistCollectionCell.h"
#import "MioMusicCollectionCell.h"
#import "MioMoreVC.h"
#import "MioUserInfo.h"
#import "MioEditInfoVC.h"
#import "MioCreatSonglistVC.h"
#import "MioDownloadVC.h"
#import "MioLikeVC.h"
#import "MioSkinCenterVC.h"
#import "MioSongListVC.h"
#import <WHC_ModelSqlite.h>
#import "MioRecentVC.h"
#import "MioMySonglistListVC.h"
#import "MioNoticeCenterVC.h"
#import "MioLocalVC.h"
#import "MioIntegralVC.h"
#import <SJM3U8DownloadListController.h>
#import <SJM3U8DownloadListItem.h>
#import "MioShareResultVC.h"
#import "CountdownTimer.h"

@interface MioMineVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) MioUserInfo *user;

@property (nonatomic, strong) MioView *userBgView;
@property (nonatomic, strong) UILabel *loginLab;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *gender;
@property (nonatomic, strong) MioButton *editBtn;
@property (nonatomic, strong) UIImageView *vipImg;
@property (nonatomic, strong) UILabel *vipLab;
@property (nonatomic, strong) MioLabel *nicknameLab;
@property (nonatomic, strong) MioLabel *signLab;
@property (nonatomic, strong) UIView *LvBg;
@property (nonatomic, strong) UIView *listenTimeBg;
@property (nonatomic, strong) UILabel *LvLab;
@property (nonatomic, strong) UIImageView *listenIcon;
@property (nonatomic, strong) UILabel *listenLab;
@property (nonatomic, strong) UIView *reddot;

@property (nonatomic, strong) UICollectionView *mySonglistCollection;
@property (nonatomic, strong) UICollectionView *recentPlayCollection;
@property (nonatomic, strong) NSArray<MioSongListModel *> *mySonglistArr;
@property (nonatomic, strong) NSArray<MioMusicModel *> *recentPlayArr;

@property (nonatomic, strong) UIView *recentTitleView;
@end

@implementation MioMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _mySonglistArr = [[NSArray alloc] init];
    _recentPlayArr = [[NSArray alloc] init];
    [self creatUI];
    
    RecieveNotice(@"refreshInfo", updateInfo);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateInfo];
    [self requestMySonglist];
    [self requestUnred];
    _recentPlayArr = [[[WHCSqlite query:[MioMusicModel class] where:@"savetype = 'recentMusic'"] reverseObjectEnumerator] allObjects];
    [_recentPlayCollection reloadData];
    
}

-(void)updateInfo{
    if (islogin) {
        _loginLab.hidden = YES;
        _tipLab.hidden = YES;
        _gender.hidden = NO;
        _editBtn.hidden = YES;
        _vipImg.hidden = NO;
        _nicknameLab.hidden = NO;
        _signLab.hidden = NO;
        _LvBg.hidden = NO;
        _listenTimeBg.hidden = NO;
        _LvLab.hidden = NO;
        _listenIcon.hidden = NO;
        _listenLab.hidden = NO;
        [MioGetReq(api_userInfo, @{@"k":@"v"}) success:^(NSDictionary *result){
            NSDictionary *data = [result objectForKey:@"data"];
            _user = [MioUserInfo mj_objectWithKeyValues:data];
            [_avatar sd_setImageWithURL:_user.avatar.mj_url placeholderImage:image(@"qxt_yonhu")];
            _nicknameLab.text = _user.nickname;
            _nicknameLab.width = [_nicknameLab.text widthForFont:BoldFont(14)];
            _signLab.text = (_user.sign.length > 0)?_user.sign:@"暂时没有个性签名哦，赶快去编写一个吧~~~";
//            _editBtn.left = _nicknameLab.right + 4;
            _vipImg.left = _nicknameLab.right;
            _LvLab.text = [NSString stringWithFormat:@"Lv.%@",_user.level];
            _listenLab.text = [NSString stringWithFormat:@"%d小时",(int)round([_user.listen_time intValue]/3600.0)];
            _listenLab.width = [_listenLab.text widthForFont:Font(10)];
            _listenTimeBg.width = 21 + _listenLab.width;
            if (_user.gender == 0) {
                _gender.hidden = NO;
                _gender.image = image(@"xingbie_nvsheng");
            }
            if (_user.gender == 1) {
                _gender.hidden = NO;
                _gender.image = image(@"xingbie_nansheng");
            }
            if (_user.gender == 2) {
                _gender.hidden = YES;
            }
            if (_user.is_vip) {
                _vipImg.image = image(@"vip_yes");
                _vipLab.text = _user.vip_remain_format;
            }else{
                _vipImg.image = image(@"vip_no");
                _vipLab.text = @"非会员";
            }
            if (_user.vip_remain.intValue > 0) {
                [userdefault setObject:@"1" forKey:@"isVip"];
                [userdefault synchronize];
       
                [CountdownTimer startTimerWithKey:vipCutDown count:_user.vip_remain.intValue callBack:^(NSInteger count, BOOL isFinished) {
                    
//                    NSLog(@"会员剩余时间%ld",(long)count);
                    if (count == 1) {
                        [userdefault setObject:@"0" forKey:@"isVip"];
                        [userdefault synchronize];
                    }
                }];
            }
        } failure:^(NSString *errorInfo) {}];
    }else{
        _loginLab.hidden = NO;
        _tipLab.hidden = NO;
        _avatar.image = image(@"qxt_yonhu");
        _gender.hidden = YES;
        _editBtn.hidden = YES;
        _vipImg.hidden = YES;
        _nicknameLab.hidden = YES;
        _signLab.hidden = YES;
        _LvBg.hidden = YES;
        _listenTimeBg.hidden = YES;
        _LvLab.hidden = YES;
        _listenIcon.hidden = YES;
        _listenLab.hidden = YES;
    }
}

-(void)creatUI{
    MioLabel *titleLab = [MioLabel creatLabel:frame(Mar, StatusH + 8, 50, 28) inView:self.view text:@"我的" colorName:name_main boldSize:20 alignment:NSTextAlignmentLeft];
    MioButton *messegeBtn = [MioButton creatBtn:frame(KSW - 56 - 20, StatusH + 12, 20, 20) inView:self.view bgImage:@"me_yidu" bgTintColorName:name_icon_one action:^{
        goLogin;
        MioNoticeCenterVC *vc = [[MioNoticeCenterVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    messegeBtn.clickArea = @"2";

    
    _reddot = [UIView creatView:frame(16, 0, 6, 6) inView:messegeBtn bgColor:redTextColor radius:3];
    _reddot.hidden = YES;
    
    MioButton *moreBtn = [MioButton creatBtn:frame(KSW - 16 - 20, StatusH + 12, 20, 20) inView:self.view bgImage:@"me_more" bgTintColorName:name_icon_one action:^{
        MioMoreVC *vc = [[MioMoreVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    moreBtn.clickArea = @"2";

    UIScrollView *bgScroll = [UIScrollView creatScroll:frame(0, NavH, KSW, KSH - NavH - TabH - 50) inView:self.view contentSize:CGSizeMake(KSW, 698)];
    _userBgView = [MioView creatView:frame(Mar,31, KSW_Mar2, 136) inView:bgScroll bgColorName:name_card radius:8];
    
    _loginLab = [MioLabel creatLabel:frame(92, 8, 250, 80) inView:_userBgView text:@"登录/注册\n\n" colorName:name_text_one boldSize:18 alignment:NSTextAlignmentLeft];
    _loginLab.numberOfLines = 0;
    _tipLab = [MioLabel creatLabel:frame(92, 35, 200, 25) inView:_userBgView text:@"点击登录 享受更多精彩音乐" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    [_loginLab whenTapped:^{
        goLogin;
    }];
    
    _avatar = [UIImageView creatImgView:frame(Mar + 12, 20, 70, 70) inView:bgScroll image:@"qxt_yonhu" radius:35];
    [_avatar sd_setImageWithURL:currentUserAvatar placeholderImage:image(@"qxt_yonhu")];
    [_avatar whenTapped:^{
        goLogin;
        MioEditInfoVC *vc = [[MioEditInfoVC alloc] init];
        vc.user = _user;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    _gender = [UIImageView creatImgView:frame(76, 76, 14, 14) inView:bgScroll image:@"" radius:0];
    _nicknameLab = [MioLabel creatLabel:frame(92, 4, 0, 22) inView:_userBgView text:@"" colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
    _nicknameLab.text = currentUserNickName;
    _nicknameLab.width = [_nicknameLab.text widthForFont:BoldFont(16)];
    _editBtn = [MioButton creatBtn:frame(_nicknameLab.right + 4, 8, 14, 14) inView:_userBgView bgImage:@"bianji_icon" bgTintColorName:name_icon_three action:^{
        MioEditInfoVC *vc = [[MioEditInfoVC alloc] init];
        vc.user = _user;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    _editBtn.clickArea = @"3";
    
    
    _vipImg = [UIImageView creatImgView:frame(-100, 0, 65, 27) inView:_userBgView image:@"vip_no" radius:0];
    _vipLab = [UILabel creatLabel:frame(28, 10, 34, 14) inView:_vipImg text:@"" color:appWhiteColor size:10 alignment:NSTextAlignmentCenter];

    
    _LvBg = [UIView creatView:frame(92, 28, 30, 16) inView:_userBgView bgColor:rgba(0, 0, 0, 0.15) radius:8];
    _LvLab = [UILabel creatLabel:frame(0, 0, 30, 16) inView:_LvBg text:@"Lv.1" color:appWhiteColor size:10 alignment:NSTextAlignmentCenter];
    _listenTimeBg = [UIView creatView:frame(_LvBg.right + 4, 28, 60, 16) inView:_userBgView bgColor:rgba(0, 0, 0, 0.15) radius:8];
    _listenIcon = [UIImageView creatImgView:frame(4, 2.5, 11, 11) inView:_listenTimeBg image:@"bfl" radius:0];
    _listenLab = [UILabel creatLabel:frame(17, 1, 38, 14) inView:_listenTimeBg text:@"0小时" color:appWhiteColor size:10 alignment:NSTextAlignmentCenter];
    _listenLab.width = [_listenLab.text widthForFont:Font(10)];
    _listenTimeBg.width = 21 + [_listenLab.text widthForFont:Font(10)];
    _signLab = [MioLabel creatLabel:frame(92, 46, KSW - 108 - 39, 34) inView:_userBgView text:@"暂时没有个性签名哦，赶快去编写一个吧~~~" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    _signLab.numberOfLines = 2;
    
    _gender.hidden = YES;
    _editBtn.hidden = YES;
    _vipImg.hidden = YES;
    _nicknameLab.hidden = YES;
    _signLab.hidden = YES;
    _LvBg.hidden = YES;
    _listenTimeBg.hidden = YES;
    _LvLab.hidden = YES;
    _listenIcon.hidden = YES;
    _listenLab.hidden = YES;
    
    MioView *split = [MioView creatView:frame(12, 91.5, KSW_Mar2 - 24, 0.5) inView:_userBgView bgColorName:name_split radius:0];
    MioView *split1 = [MioView creatView:frame(KSW_Mar2/4, 108, 0.5 , 12) inView:_userBgView bgColorName:name_split radius:0];
    MioView *split2 = [MioView creatView:frame(KSW_Mar2/2, 108, 0.5 , 12) inView:_userBgView bgColorName:name_split radius:0];
    MioView *split3 = [MioView creatView:frame(KSW_Mar2*3/4, 108, 0.5 , 12) inView:_userBgView bgColorName:name_split radius:0];
    MioLabel *memberLab = [MioLabel creatLabel:frame(0, 92, KSW_Mar2/4, 44) inView:_userBgView text:@"积分" colorName:name_text_one size:14 alignment:NSTextAlignmentCenter];
    MioLabel *shareLab = [MioLabel creatLabel:frame(KSW_Mar2/4, 92, KSW_Mar2/4, 44) inView:_userBgView text:@"分享" colorName:name_text_one size:14 alignment:NSTextAlignmentCenter];
    MioLabel *skinLab = [MioLabel creatLabel:frame(KSW_Mar2/2, 92, KSW_Mar2/4, 44) inView:_userBgView text:@"换肤" colorName:name_text_one size:14 alignment:NSTextAlignmentCenter];
    MioLabel *signLab = [MioLabel creatLabel:frame(KSW_Mar2*3/4, 92, KSW_Mar2/4, 44) inView:_userBgView text:@"签到" colorName:name_text_one size:14 alignment:NSTextAlignmentCenter];
    
    
    MioView *likeView = [MioView creatView:frame(30, 197, 52, 52) inView:bgScroll bgColorName:name_sup_one radius:26];
    MioView *recentView = [MioView creatView:frame((KSW/2 - (KSW-82*2 - 52*2)/6 - 52), 197, 52, 52) inView:bgScroll bgColorName:name_sup_one radius:26];
    MioView *localView = [MioView creatView:frame(KSW/2 + (KSW-82*2 - 52*2)/6, 197, 52, 52) inView:bgScroll bgColorName:name_sup_one radius:26];
    MioView *downLoadView = [MioView creatView:frame(KSW - 30 -52, 197, 52, 52) inView:bgScroll bgColorName:name_sup_one radius:26];
    MioImageView *likeImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:likeView image:@"me_like_biaodan" bgTintColorName:name_main radius:0];
    MioImageView *songListImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:recentView image:@"shouye_gedan" bgTintColorName:name_main radius:0];
    MioImageView *localImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:localView image:@"me_local" bgTintColorName:name_main radius:0];
    MioImageView *downloadImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:downLoadView image:@"me_download" bgTintColorName:name_main radius:0];
    MioLabel *likeLab = [MioLabel creatLabel:frame(likeView.left, 253, 52, 17) inView:bgScroll text:@"喜欢" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *songlistLab = [MioLabel creatLabel:frame(recentView.left, 253, 52, 17) inView:bgScroll text:@"最近" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *loalLab = [MioLabel creatLabel:frame(localView.left, 253, 52, 17) inView:bgScroll text:@"本地" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *downloadLab = [MioLabel creatLabel:frame(downLoadView.left, 253, 52, 17) inView:bgScroll text:@"下载" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    

    MioLabel *mySonglistLab = [MioLabel creatLabel:frame(Mar, 300, 100, 20) inView:bgScroll text:@"我的歌单" colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
    MioLabel *moreSonglistLab = [MioLabel creatLabel:frame(KSW_Mar - 50, 300, 50, 23) inView:bgScroll text:@"更多" colorName:name_text_two size:12 alignment:NSTextAlignmentCenter];
    MioImageView *arrow1 = [MioImageView creatImgView:frame(KSW_Mar -  14, 304.5, 14, 14) inView:bgScroll image:@"return_more" bgTintColorName:name_icon_two radius:0];
    MioLabel *newSonglistLab = [MioLabel creatLabel:frame(KSW_Mar - 90, 300, 40, 23) inView:bgScroll text:@"新建" colorName:name_text_two size:12 alignment:NSTextAlignmentCenter];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, Mar, 0, Mar);
    _mySonglistCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 328 , KSW, 149) collectionViewLayout:flowLayout];
    _mySonglistCollection.dataSource = self;
    _mySonglistCollection.delegate = self;
    _mySonglistCollection.showsHorizontalScrollIndicator = NO;
    _mySonglistCollection.backgroundColor = appClearColor;
    [_mySonglistCollection registerClass:[MioSonglistCollectionCell class] forCellWithReuseIdentifier:@"MioSonglistCollectionCell"];
    [_mySonglistCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MioCreatSonglistCollectionCell"];
    [bgScroll addSubview:_mySonglistCollection];
    
    _recentTitleView = [UIView creatView:frame(0, 507, KSW, 23) inView:bgScroll bgColor:appClearColor radius:0];
    MioLabel *recentLab = [MioLabel creatLabel:frame(Mar, 0, 100, 20) inView:_recentTitleView text:@"最近播放" colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
    MioLabel *moreRecentLab = [MioLabel creatLabel:frame(KSW_Mar - 50, 0, 50, 23) inView:_recentTitleView text:@"更多" colorName:name_text_two size:12 alignment:NSTextAlignmentCenter];
    MioImageView *arrow2 = [MioImageView creatImgView:frame(KSW_Mar -  14, 4.5, 14, 14) inView:_recentTitleView image:@"return_more" bgTintColorName:name_icon_two radius:0];
    
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc]init];
    flowLayout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout2.sectionInset = UIEdgeInsetsMake(0, Mar, 0, Mar);
    
    _recentPlayCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 535 , KSW, 149) collectionViewLayout:flowLayout2];
    _recentPlayCollection.dataSource = self;
    _recentPlayCollection.delegate = self;
    _recentPlayCollection.showsHorizontalScrollIndicator = NO;
    _recentPlayCollection.backgroundColor = appClearColor;
    [_recentPlayCollection registerClass:[MioMusicCollectionCell class] forCellWithReuseIdentifier:@"MioMusicCollectionCell"];
    
    [bgScroll addSubview:_recentPlayCollection];
    
    [memberLab whenTapped:^{
        goLogin;
        MioIntegralVC *vc = [[MioIntegralVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [shareLab whenTapped:^{
        goLogin;
        MioShareResultVC *vc = [[MioShareResultVC alloc] init];
        vc.jump_URL = _user.share_url;
        [self.navigationController pushViewController:vc animated:YES];
        
//        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
//        if (islogin) {
//            pastboard.string = _user.share_url;
//            [UIWindow showSuccess:@"邀请链接已复制到剪切板"];
//        }else{
//            pastboard.string = [userdefault objectForKey:@"shareUrl"];
//            [UIWindow showSuccess:@"邀请链接已复制到剪切板，登录后分享才能获取积分奖励哦"];
//        }
    }];
    [skinLab whenTapped:^{
        MioSkinCenterVC *vc = [[MioSkinCenterVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [signLab whenTapped:^{
        goLogin;
        [MioPostReq(api_sign, @{@"k":@"v"}) success:^(NSDictionary *result){
            NSString *data = [result objectForKey:@"message"];
            [UIWindow showSuccess:data];
        } failure:^(NSString *errorInfo) {
            [UIWindow showInfo:errorInfo];
        }];
    }];
    [likeView whenTapped:^{
        goLogin;
        MioLikeVC *vc = [[MioLikeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [recentView whenTapped:^{
        MioRecentVC *vc = [[MioRecentVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [localView whenTapped:^{

        if ([self isMediaPlayerService]) {
            MioLocalVC *vc = [[MioLocalVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }];
    [downLoadView whenTapped:^{

        MioDownloadVC *vc = [[MioDownloadVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [newSonglistLab whenTapped:^{
        goLogin;
        MioCreatSonglistVC *vc = [[MioCreatSonglistVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [moreSonglistLab whenTapped:^{
        goLogin;
        MioMySonglistListVC *vc = [[MioMySonglistListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [moreRecentLab whenTapped:^{
        MioRecentVC *vc = [[MioRecentVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

-(void)requestMySonglist{
    [MioGetReq(api_mySongLists, @{@"k":@"v"}) success:^(NSDictionary *result){
        _mySonglistArr = [MioSongListModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"data"]];
        [_mySonglistCollection reloadData];
        
    } failure:^(NSString *errorInfo) {
        if (Equals(errorInfo, @"授权失败") ) {
            _mySonglistArr = @[];
            [_mySonglistCollection reloadData];
        }
    }];
}

-(void)requestUnred{
    [MioGetReq(api_unread, @{@"k":@"v"}) success:^(NSDictionary *result){
        NSString *count = [result objectForKey:@"data"][@"count"];
        if ([count intValue] == 0) {
            _reddot.hidden = YES;
        }else{
            _reddot.hidden = NO;
        }
    } failure:^(NSString *errorInfo) {}];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(109,149);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _mySonglistCollection) {
        return _mySonglistArr.count + 1;
    }else{
        if (_recentPlayArr.count == 0) {
            _recentTitleView.hidden = YES;
        }else{
            _recentTitleView.hidden = NO;
        }
        return _recentPlayArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _mySonglistCollection) {
        if ((indexPath.row <= _mySonglistArr.count - 1) && (_mySonglistArr.count > 0)) {
            MioSonglistCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioSonglistCollectionCell" forIndexPath:indexPath];
            cell.model = _mySonglistArr[indexPath.row];
            return cell;
        }else{
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioCreatSonglistCollectionCell" forIndexPath:indexPath];
            [cell removeAllSubviews];
            MioView *iconBg = [MioView creatView:frame(0, 0, 109, 109) inView:cell bgColorName:name_card radius:4];
            MioImageView *icon = [MioImageView creatImgView:frame(39.5, 39.5, 30, 30) inView:iconBg image:@"me_xinjiangedan" bgTintColorName:name_icon_three radius:0];
            MioLabel *title = [MioLabel creatLabel:frame(0, 113, 109, 17) inView:cell text:@"新建歌单" colorName:name_text_one size:12 alignment:NSTextAlignmentLeft];
            return cell;
        }
    }else{
        MioMusicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioMusicCollectionCell" forIndexPath:indexPath];
        cell.model = _recentPlayArr[indexPath.row];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _mySonglistCollection) {
        if (indexPath.row <= (_mySonglistArr.count - 1) && (_mySonglistArr.count > 0)) {
            MioSongListVC *vc = [[MioSongListVC alloc] init];
            vc.songlistId = _mySonglistArr[indexPath.row].song_list_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            goLogin;
            MioCreatSonglistVC *vc = [[MioCreatSonglistVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [mioM3U8Player playWithMusicList:_recentPlayArr andIndex:indexPath.row fromModel:MioFromRecent andId:@""];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:
(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8.0;
}

// MARK:- 判断是否有权限
- (BOOL)isMediaPlayerService{

    MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
    if (authStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            
        }];
        return NO;
    }else if (authStatus == MPMediaLibraryAuthorizationStatusAuthorized){
        return YES;
    }else{
        return NO;
    }
}


@end
