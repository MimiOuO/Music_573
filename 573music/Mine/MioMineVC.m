//
//  MioMineVC.m
//  jgsschool
//
//  Created by Mimio on 2020/9/18.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMineVC.h"
#import "MioSonglistCollectionCell.h"
#import "MioMoreVC.h"
#import "MioUserInfo.h"
#import "MioEditInfoVC.h"
#import "MioCreatSonglistVC.h"

@interface MioMineVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) MioUserInfo *user;

@property (nonatomic, strong) MioView *userBgView;
@property (nonatomic, strong) UILabel *loginLab;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *gender;
@property (nonatomic, strong) MioButton *editBtn;
@property (nonatomic, strong) MioLabel *nicknameLab;
@property (nonatomic, strong) MioLabel *signLab;
@property (nonatomic, strong) UIView *LvBg;
@property (nonatomic, strong) UIView *listenTimeBg;
@property (nonatomic, strong) UILabel *LvLab;
@property (nonatomic, strong) UIImageView *listenIcon;
@property (nonatomic, strong) UILabel *listenLab;

@property (nonatomic, strong) UICollectionView *mySonglistCollection;
@property (nonatomic, strong) UICollectionView *recentPlayCollection;
@end

@implementation MioMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateInfo];
    [_recentPlayCollection reloadData];
}


-(void)updateInfo{
    if (islogin) {
        _loginLab.hidden = YES;
        _tipLab.hidden = YES;
        _gender.hidden = NO;
        _editBtn.hidden = NO;
        _nicknameLab.hidden = NO;
        _signLab.hidden = NO;
        _LvBg.hidden = NO;
        _listenTimeBg.hidden = NO;
        _LvLab.hidden = NO;
        _listenIcon.hidden = NO;
        _listenLab.hidden = NO;
        [MioGetReq(api_otherUserinfo(currentUserId), @{@"k":@"v"}) success:^(NSDictionary *result){
            NSDictionary *data = [result objectForKey:@"data"];
            _user = [MioUserInfo mj_objectWithKeyValues:data];
            [_avatar sd_setImageWithURL:currentUserAvatar placeholderImage:image(@"icon")];
            _nicknameLab.text = _user.nickname;
            _nicknameLab.width = [_nicknameLab.text widthForFont:BoldFont(16)];
            _editBtn.left = _nicknameLab.right + 4;
        } failure:^(NSString *errorInfo) {}];
        
    }else{
        
        _loginLab.hidden = NO;
        _tipLab.hidden = NO;
        _avatar.image = image(@"icon");
        _gender.hidden = YES;
        _editBtn.hidden = YES;
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
        
    }];
    MioButton *moreBtn = [MioButton creatBtn:frame(KSW - 16 - 20, StatusH + 12, 20, 20) inView:self.view bgImage:@"me_more" bgTintColorName:name_icon_one action:^{
        MioMoreVC *vc = [[MioMoreVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    UIScrollView *bgScroll = [UIScrollView creatScroll:frame(0, NavH, KSW, KSH - NavH - TabH - 50) inView:self.view contentSize:CGSizeMake(KSW, 698)];
    _userBgView = [MioView creatView:frame(Mar,31, KSW_Mar2, 136) inView:bgScroll bgColorName:name_card radius:8];
    
    _loginLab = [MioLabel creatLabel:frame(92, 8, 250, 80) inView:_userBgView text:@"登录/注册\n\n" colorName:name_text_one boldSize:18 alignment:NSTextAlignmentLeft];
    _loginLab.numberOfLines = 0;
    _tipLab = [MioLabel creatLabel:frame(92, 35, 200, 25) inView:_userBgView text:@"点击登录 享受更多精彩音乐" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    [_loginLab whenTapped:^{
        goLogin;
    }];
    
    _avatar = [UIImageView creatImgView:frame(Mar + 12, 20, 70, 70) inView:bgScroll image:@"icon" radius:35];
    [_avatar sd_setImageWithURL:currentUserAvatar placeholderImage:image(@"icon")];
    _gender = [UIImageView creatImgView:frame(48, 56, 14, 14) inView:_avatar image:@"xb_nan" radius:0];
    _nicknameLab = [MioLabel creatLabel:frame(92, 4, 0, 22) inView:_userBgView text:@"" colorName:name_text_one boldSize:16 alignment:NSTextAlignmentLeft];
    _nicknameLab.text = currentUserNickName;
    _nicknameLab.width = [_nicknameLab.text widthForFont:BoldFont(16)];
    _editBtn = [MioButton creatBtn:frame(_nicknameLab.right + 4, 8, 14, 14) inView:_userBgView bgImage:@"bianji_icon" bgTintColorName:name_icon_three action:^{
        MioEditInfoVC *vc = [[MioEditInfoVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    _LvBg = [UIView creatView:frame(92, 28, 30, 16) inView:_userBgView bgColor:rgba(0, 0, 0, 0.15) radius:8];
    _LvLab = [UILabel creatLabel:frame(0, 0, 30, 16) inView:_LvBg text:@"Lv.1" color:appWhiteColor size:10 alignment:NSTextAlignmentCenter];
    _listenTimeBg = [UIView creatView:frame(_LvBg.right + 4, 28, 60, 16) inView:_userBgView bgColor:rgba(0, 0, 0, 0.15) radius:8];
    _listenIcon = [UIImageView creatImgView:frame(4, 2.5, 11, 11) inView:_listenTimeBg image:@"tinggeliang" radius:0];
    _listenLab = [UILabel creatLabel:frame(17, 1, 38, 14) inView:_listenTimeBg text:@"1小时" color:appWhiteColor size:10 alignment:NSTextAlignmentCenter];
    _listenLab.width = [_listenLab.text widthForFont:Font(10)];
    _listenTimeBg.width = 21 + [_listenLab.text widthForFont:Font(10)];
    _signLab = [MioLabel creatLabel:frame(92, 46, KSW - 108 - 39, 34) inView:_userBgView text:@"暂时没有个性签名哦，赶快去编写一个吧~~~" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    _signLab.numberOfLines = 2;
    
    _gender.hidden = YES;
    _editBtn.hidden = YES;
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
    MioView *songListView = [MioView creatView:frame(likeView.right + (KSW - 164 - 104)/3, 197, 52, 52) inView:bgScroll bgColorName:name_sup_one radius:26];
    MioView *localView = [MioView creatView:frame(songListView.right + (KSW - 164 - 104)/3, 197, 52, 52) inView:bgScroll bgColorName:name_sup_one radius:26];
    MioView *downLoadView = [MioView creatView:frame(KSW - 30 -52, 197, 52, 52) inView:bgScroll bgColorName:name_sup_one radius:26];
    MioImageView *likeImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:likeView image:@"me_like_biaodan" bgTintColorName:name_main radius:0];
    MioImageView *songListImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:songListView image:@"me_playlist" bgTintColorName:name_main radius:0];
    MioImageView *localImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:localView image:@"me_local" bgTintColorName:name_main radius:0];
    MioImageView *downloadImg = [MioImageView creatImgView:frame(13, 13, 26, 26) inView:downLoadView image:@"me_download" bgTintColorName:name_main radius:0];
    MioLabel *likeLab = [MioLabel creatLabel:frame(likeView.left, 253, 52, 17) inView:bgScroll text:@"喜欢" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
    MioLabel *songlistLab = [MioLabel creatLabel:frame(songListView.left, 253, 52, 17) inView:bgScroll text:@"歌单" colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
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
    
    [bgScroll addSubview:_mySonglistCollection];
    
    
    MioLabel *recentLab = [MioLabel creatLabel:frame(Mar, 507, 100, 20) inView:bgScroll text:@"最近播放" colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
    MioLabel *moreRecentLab = [MioLabel creatLabel:frame(KSW_Mar - 50, 507, 50, 23) inView:bgScroll text:@"更多" colorName:name_text_two size:12 alignment:NSTextAlignmentCenter];
    MioImageView *arrow2 = [MioImageView creatImgView:frame(KSW_Mar -  14, 611.5, 14, 14) inView:bgScroll image:@"return_more" bgTintColorName:name_icon_two radius:0];
    
    _recentPlayCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 535 , KSW, 149) collectionViewLayout:flowLayout];
    _recentPlayCollection.dataSource = self;
    _recentPlayCollection.delegate = self;
    _recentPlayCollection.showsHorizontalScrollIndicator = NO;
    _recentPlayCollection.backgroundColor = appClearColor;
    [_recentPlayCollection registerClass:[MioSonglistCollectionCell class] forCellWithReuseIdentifier:@"MioSonglistCollectionCell"];
    
    [bgScroll addSubview:_recentPlayCollection];
    
    [memberLab whenTapped:^{
        goLogin;
    }];
    [shareLab whenTapped:^{
            
    }];
    [skinLab whenTapped:^{
        goLogin;
    }];
    [signLab whenTapped:^{
        goLogin;
    }];
    [likeView whenTapped:^{
        goLogin;
    }];
    [songListView whenTapped:^{
            
    }];
    [localView whenTapped:^{
            
    }];
    [downLoadView whenTapped:^{
            
    }];
    
    [newSonglistLab whenTapped:^{
        goLogin;
        MioCreatSonglistVC *vc = [[MioCreatSonglistVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [moreSonglistLab whenTapped:^{
        goLogin;
    }];
    [moreRecentLab whenTapped:^{
            
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(109,149);
//    return CGSizeMake((KSW_Mar2 - 16)/3, (KSW_Mar2 - 16)/3 + 40);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MioSonglistCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MioSonglistCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = redTextColor;
//    cell.model = [MioRoomModel mj_objectWithKeyValues:roomDic];

    return cell;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:
(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8.0;
}


@end
