//
//  MioSkinCenter.m
//  573music
//
//  Created by Mimio on 2021/1/6.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioSkinCenterVC.h"
#import "HQFlowView.h"
#import "CocoaDownloader.h"
#import <SSZipArchive.h>
@interface MioSkinCenterVC ()<HQFlowViewDelegate,HQFlowViewDataSource,DownloadTaskDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) HQFlowView *pageFlowView;
@property (nonatomic, strong) UIImageView *backGroundImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *useBtn;

@property (nonatomic, strong) DownloadManager *downloadManger;
@property (nonatomic, strong) DownloadInfo *downloadInfo;
@end

@implementation MioSkinCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *tempArr = [[userdefault objectForKey:@"skinlist"] mutableCopy];
    NSDictionary *baiDic = @{
        @"title":@"利休白",
        @"cover_image_path":@"lixiubai",
        @"theme_path":@"bai"
    };
    [tempArr insertObject:baiDic atIndex:0];
    _dataArr = tempArr;
    [self creatUI];
    
    [self.navView.centerButton setTitle:@"皮肤中心" forState:UIControlStateNormal];
    [self.navView.centerButton setTitleColor:appWhiteColor forState:UIControlStateNormal];
    [self.navView.leftButton setImage:backArrowWhiteIcon forState:UIControlStateNormal];
    self.navView.bgImg.hidden = YES;
    self.navView.mainView.backgroundColor = appClearColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    statusBarLight;
}

-(void)creatUI{
    _backGroundImg = [UIImageView creatImgView:frame(0, 0, KSW, KSH) inView:self.view image:@"" radius:0];
//    [_backGroundImg sd_setImageWithURL:Url(_dataArr[0][@"cover"]) placeholderImage:image(@"")];
    _backGroundImg.image = image(@"lixiubai");
    UIVisualEffectView *effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effect.frame = frame(0, 0, KSW, KSH);
    [_backGroundImg addSubview:effect];
    UIView *alphaView = [UIView creatView:frame(0, 0, KSW, KSH) inView:self.view bgColor:rgba(0, 0, 0, 0.2) radius:0];
    
    _pageFlowView = [[HQFlowView alloc] initWithFrame:frame(0,0, KSW, 500)];
    _pageFlowView.centerY = KSH/2;
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.3;
    _pageFlowView.leftRightMargin = 40;
    _pageFlowView.pageCount = _dataArr.count;
    _pageFlowView.isOpenAutoScroll = NO;
    _pageFlowView.orientation = HQFlowViewOrientationHorizontal;
    [self.view addSubview:_pageFlowView];
    [_pageFlowView reloadData];
    
//    _titleLab = [UILabel creatLabel:frame(0,_pageFlowView.bottom, KSW, 29) inView:self.view text:_dataArr[0][@"name"] color:appWhiteColor boldSize:14 alignment:NSTextAlignmentCenter];
    _useBtn = [UIButton creatBtn:frame(KSW/2 - 183/2, KSH - SafeBotH - 40 - 40, 183, 40) inView:self.view bgColor:appClearColor title:@"立即使用" titleColor:appWhiteColor font:14 radius:8 action:^{
        if (_useBtn.selected == NO) {
            [self switchSkin];
        }
    }];
    _useBtn.layer.borderColor = appWhiteColor.CGColor;
    _useBtn.layer.borderWidth = 1;
    [_useBtn setBackgroundColor:appWhiteColor forState:UIControlStateSelected];
    [_useBtn setTitle:@"正在使用" forState:UIControlStateSelected];
    [_useBtn setTitleColor:subColor forState:UIControlStateSelected];
    
    NSString *skinName=[((NSString *)[_dataArr[0][@"package"] componentsSeparatedByString:@"/"].lastObject) componentsSeparatedByString:@"."][0];
    if (Equals([userdefault objectForKey:@"skin"], skinName)) {
        _useBtn.selected = YES;
    }
}

-(void)switchSkin{
    NSString *url = _dataArr[_pageFlowView.currentPageIndex][@"theme_path"];

    NSString *fileName=[((NSString *)[url componentsSeparatedByString:@"/"].lastObject) componentsSeparatedByString:@"."][0];
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filepath=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Skin/%@",fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filepath]) {
        [userdefault setObject:fileName forKey:@"skin"];
        [userdefault synchronize];
        [userdefault setObject:colorDic forKey:@"colorJson"];
        [userdefault synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkin" object:nil];
        [UIWindow showSuccess:@"换肤成功"];
        _useBtn.selected = YES;
    } else{
        
        [self downLoadSkinWithUrl:url];
    };
}

-(void)downLoadSkinWithUrl:(NSString *)url{
    
    
    self.downloadManger = [DownloadManager sharedInstance];
    
    //save path
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Skin/%@",[url componentsSeparatedByString:@"/"].lastObject]];

    NSLog(@"ixuea download save path:%@",path);

    self.downloadInfo=[[DownloadInfo alloc] init];
    [self.downloadInfo setPath:path];
    [self.downloadInfo setUri:url];

    //Set download info id.
    [self.downloadInfo setId:Str(arc4random() % 10000)];



    //Set download callcabk.
    [self.downloadInfo setDownloadBlock:^(DownloadInfo * _Nonnull downloadInfo) {
        //TODO Progress, status changes are callbacks.
    }];

    //Start download.
    [self.downloadManger download:self.downloadInfo];
    WEAKSELF;
    [UIWindow showMaskLoading:@"皮肤下载中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.downloadInfo setDownloadBlock:^(DownloadInfo * _Nonnull downloadInfo) {
            
            if (downloadInfo.status == DownloadStatusCompleted) {
                [weakSelf unzipWithPath:downloadInfo.path];
            }
        }];
    });
}

-(void)unzipWithPath:(NSString *)path{
    

    NSString *unzipPath = [NSString stringWithFormat:@"%@/Skin",
                           NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
   
    NSLog(@"Unzip path: %@", unzipPath);
    if (!unzipPath) {
        return;
    }
    
    BOOL success = [SSZipArchive unzipFileAtPath:path
                                   toDestination:unzipPath
                              preserveAttributes:YES
                                       overwrite:YES
                                  nestedZipLevel:0
                                        password:nil
                                           error:nil
                                        delegate:nil
                                 progressHandler:nil
                               completionHandler:nil];
    if (success) {
        
        [userdefault setObject:[((NSString *)[path componentsSeparatedByString:@"/"].lastObject) componentsSeparatedByString:@"."][0] forKey:@"skin"];
        [userdefault synchronize];
        [userdefault setObject:colorDic forKey:@"colorJson"];
        [userdefault synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkin" object:nil];
        [UIWindow showSuccess:@"换肤成功"];
        _useBtn.selected = YES;
    } else {
        [UIWindow showInfo:@"换肤失败"];
        
        return;
    }
}

#pragma mark JQFlowViewDatasource
- (NSInteger)numberOfPagesInFlowView:(HQFlowView *)flowView
{
    return _dataArr.count;
}
- (HQIndexBannerSubview *)flowView:(HQFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    HQIndexBannerSubview *bannerView = (HQIndexBannerSubview *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[HQIndexBannerSubview alloc] initWithFrame:CGRectMake(0, 0, 266, 472)];
        bannerView.layer.cornerRadius = 8;
        bannerView.layer.masksToBounds = YES;
        bannerView.backgroundColor = appWhiteColor;
        
    }
    if (index == 0) {
        bannerView.mainImageView.image = image(@"lixiubai");
    }else{
        [bannerView.mainImageView sd_setImageWithURL:Url(_dataArr[index][@"cover_image_path"]) placeholderImage:nil];
    }
    
    return bannerView;
}

- (CGSize)sizeForPageInFlowView:(HQFlowView *)flowView{
    return CGSizeMake(266, 472);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(HQFlowView *)flowView{
    if (pageNumber == 0) {
        _backGroundImg.image = image(@"lixiubai");
    }else{
        [_backGroundImg sd_setImageWithURL:Url(_dataArr[pageNumber][@"cover_image_path"]) placeholderImage:nil];
    }
    
    _titleLab.text = _dataArr[pageNumber][@"title"];
    NSString *skinName=[((NSString *)[_dataArr[pageNumber][@"theme_path"] componentsSeparatedByString:@"/"].lastObject) componentsSeparatedByString:@"."][0];
    if (Equals([userdefault objectForKey:@"skin"], skinName)) {
        _useBtn.selected = YES;
    }else{
        _useBtn.selected = NO;
    }
}

@end
