//
//  MioChooseDownloadQuantityView.m
//  573music
//
//  Created by Mimio on 2021/2/18.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioChooseDownloadQuantityView.h"
#import <SJM3U8DownloadListController.h>
#import <SJM3U8DownloadListItem.h>
#import <WHC_ModelSqlite.h>
@interface MioChooseDownloadQuantityView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *quailtyView;
@end

@implementation MioChooseDownloadQuantityView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = rgba(0, 0, 0, 0.3);

        self.frame = frame(0, KSH, KSW, KSH);
        UIView *closeView = [UIView creatView:frame(0, 0, KSW, KSH - 210 - SafeBotH) inView:self bgColor:appClearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [closeView addGestureRecognizer:tap];
        
        _bgView = [UIView creatView:frame(0, KSH, KSW, 210 + SafeBotH) inView:self bgColor:appWhiteColor];
        MioImageView *bgImg = [MioImageView creatImgView:frame(0, 0, KSW, KSH) inView:_bgView skin:SkinName image:@"picture" radius:0];
        [_bgView addRoundedCorners:UIRectCornerTopRight|UIRectCornerTopLeft withRadii:CGSizeMake(16, 16)];
        
        UILabel *titleLab = [UILabel creatLabel:frame(0, 9, KSW, 20) inView:_bgView text:@"选择下载音质" color:color_text_one size:16];
        titleLab.textAlignment = NSTextAlignmentCenter;
        UILabel *tipLab = [UILabel creatLabel:frame(0, 30, KSW, 14) inView:_bgView text:@"歌曲没有所选音质将自动下载邻近音质" color:color_text_two size:10];
        tipLab.textAlignment = NSTextAlignmentCenter;
        
        UIView *splitView = [UIView creatView:frame(0, 51, KSW, 0.5) inView:_bgView bgColor:color_split];
        
        UIButton *closeBtn = [UIButton creatBtn:frame(0, 160, KSW, 50 + SafeBotH) inView:_bgView bgColor:appClearColor title:@"关闭" titleColor:color_text_one font:14 radius:0 action:^{
            [self hiddenView];
        }];
        _quailtyView = [UIView creatView:frame(0, 0, KSW, 160) inView:_bgView bgColor:appClearColor radius:0];
        
        RecieveNotice(switchMusic, hiddenView);
    }
    return self;
}

- (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self creatUI];
    self.frame = CGRectMake(0, 0, KSW, KSH);
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.top =KSH - 210 - SafeBotH;
    }];
}

- (void)hiddenView {
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.top =KSH;
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, KSH, KSW, KSH);
        [self removeFromSuperview];
    }];
}

-(void)creatUI{
    
//    NSString *quailty = _model.defaultQuailty;

//    float standardSize = 0;
//    float highSize = 0;
//    float losslessSize = 0;
    NSMutableArray *standardArr = [[NSMutableArray alloc] init];
    NSMutableArray *highArr = [[NSMutableArray alloc] init];
    NSMutableArray *losslessArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *titleArr = [[NSMutableArray alloc] init];
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSMutableArray *sizeArr = [[NSMutableArray alloc] init];
    
    for (int i = 0;i < _musicArr.count; i++) {
//        standardSize = standardSize + [_musicArr[i].standard[@"size"] floatValue];
//        highSize = highSize + [_musicArr[i].high[@"size"] floatValue];
//        losslessSize = losslessSize + [_musicArr[i].lossless[@"size"] floatValue];
        if (!Equals(_musicArr[i].standard[@"url"], @"")) {
            [standardArr addObject:_musicArr[i].standard[@"url"]];
        }
        if (!Equals(_musicArr[i].high[@"url"], @"")) {
            [highArr addObject:_musicArr[i].high[@"url"]];
        }
        if (!Equals(_musicArr[i].lossless[@"url"], @"")) {
            [losslessArr addObject:_musicArr[i].lossless[@"url"]];
        }
    }
    
    if (standardArr.count > 0) {
        [titleArr addObject:@"标准"];
        [imgArr addObject:@"yz_bz"];
//        [sizeArr addObject:[NSString stringWithFormat:@"%.2fM",standardSize/1024.0]];
    }
    if (highArr.count > 0) {
        [titleArr addObject:@"超品"];
        [imgArr addObject:@"yz_gq"];
//        [sizeArr addObject:[NSString stringWithFormat:@"%.2fM",highSize/1024.0]];
    }
    if (losslessArr.count > 0) {
        [titleArr addObject:@"无损"];
        [imgArr addObject:@"yz_ws"];
//        [sizeArr addObject:[NSString stringWithFormat:@"%.2fM",losslessSize/1024.0]];
    }

    [_quailtyView removeAllSubviews];
    for (int i = 0;i < titleArr.count; i++) {
        UIView *bgView = [UIView creatView:frame((KSW - 48*titleArr.count - 26*(titleArr.count - 1))/2 + i * 74 ,76 /*68*/, 48, 48) inView:_quailtyView bgColor:color_sup_four radius:6];
        MioImageView *icon = [MioImageView creatImgView:frame(13, 13, 22, 22) inView:bgView image:imgArr[i] bgTintColorName:name_icon_one radius:0];
        MioLabel *title = [MioLabel creatLabel:frame(bgView.left - 5,126 /*118*/, 58, 17) inView:_quailtyView text:titleArr[i] colorName:name_text_one size:12 alignment:NSTextAlignmentCenter];
//        MioLabel *size = [MioLabel creatLabel:frame(bgView.left - 5, 134, 58, 14) inView:_quailtyView text:sizeArr[i] colorName:name_text_two size:10 alignment:NSTextAlignmentCenter];
        [bgView whenTapped:^{
            
        
            NSString *downloadPath = [NSString stringWithFormat:@"%@/sj.download.files",
                                   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
        
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSMutableArray *downloadUrlArr =  [[NSMutableArray alloc] init];
            
            if (Equals(titleArr[i], @"标准")) {
                for (int j = 0;j < _musicArr.count; j++) {
                    if (_musicArr[j].hasSQ) {
                        [downloadUrlArr addObject:_musicArr[j].standard[@"url"]];
                    }else if(_musicArr[j].hasHQ){
                        [downloadUrlArr addObject:_musicArr[j].high[@"url"]];
                    }else{
                        [downloadUrlArr addObject:_musicArr[j].lossless[@"url"]];
                    }
                }
            }
            
            if (Equals(titleArr[i], @"超品")) {
                for (int j = 0;j < _musicArr.count; j++) {
                    if (_musicArr[j].hasHQ) {
                        [downloadUrlArr addObject:_musicArr[j].high
                         [@"url"]];
                    }else if(_musicArr[j].hasSQ){
                        [downloadUrlArr addObject:_musicArr[j].standard[@"url"]];
                    }else{
                        [downloadUrlArr addObject:_musicArr[j].lossless[@"url"]];
                    }
                }
            }
            
            if (Equals(titleArr[i], @"无损")) {
                for (int j = 0;j < _musicArr.count; j++) {
                    if (_musicArr[j].hasFlac) {
                        [downloadUrlArr addObject:_musicArr[j].lossless[@"url"]];
                    }else if(_musicArr[j].hasHQ){
                        [downloadUrlArr addObject:_musicArr[j].high[@"url"]];
                    }else{
                        [downloadUrlArr addObject:_musicArr[j].standard[@"url"]];
                    }
                }
            }
            
            
            NSMutableArray *realDownloadUrlArr = [[NSMutableArray alloc] init];
            NSMutableArray<MioMusicModel *> *realDownloadModelArr = [[NSMutableArray alloc] init];
            
            //筛选已下载过的
            for (int k = 0;k < downloadUrlArr.count; k++) {
                
                if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[downloadUrlArr[k] mj_url] hash]]]) {
                    
                }else{
                    [realDownloadUrlArr addObject:[NSString stringWithFormat:@"%@",[downloadUrlArr[k] mj_url]]];
                    [realDownloadModelArr addObject:_musicArr[k]];
                    
                }
            }
            
            if (realDownloadUrlArr.count == 0) {
                [UIWindow showInfo:@"该音质已经下载过"];
            }else{
                [MioGetReq(api_queryDownloadCount, @{@"k":@"v"}) success:^(NSDictionary *result){
                    int leftCount = [[[result objectForKey:@"data"] objectForKey:@"left"] intValue];
                    if (leftCount < realDownloadUrlArr.count) {
                        [UIWindow showInfo:@"当月下载次数不足"];
                        return;
                    }else{
                        //添加到下载列表
                        for (int l = 0;l < realDownloadUrlArr.count; l++) {
                            
                            //增加下载量
                            [MioPostReq(api_addPlayCount, (@{@"model_name":@"song",@"columns":@"download_num",@"model_id":realDownloadModelArr[l].song_id})) success:^(NSDictionary *result){} failure:^(NSString *errorInfo) {}];
                            
                            //清理数据库中模型

                            [WHCSqlite delete:[MioMusicModel class] where:[NSString stringWithFormat:@"savetype = 'downloaded' AND song_id = '%@'",realDownloadModelArr[l].song_id]];
                            
                            //清理已下载同一首歌曲的不同音质
                            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[realDownloadModelArr[l].standard[@"url"] mj_url] hash]] error:nil];
                            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[realDownloadModelArr[l].high[@"url"] mj_url] hash]] error:nil];
                            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%lu",downloadPath,[[realDownloadModelArr[l].lossless[@"url"] mj_url] hash]] error:nil];
                            
                            [SJM3U8DownloadListController.shared deleteItemForUrl:[NSString stringWithFormat:@"%@",[realDownloadModelArr[l].standard[@"url"] mj_url]]];
                            [SJM3U8DownloadListController.shared deleteItemForUrl:[NSString stringWithFormat:@"%@",[realDownloadModelArr[l].high[@"url"] mj_url]]];
                            [SJM3U8DownloadListController.shared deleteItemForUrl:[NSString stringWithFormat:@"%@",[realDownloadModelArr[l].lossless[@"url"] mj_url]]];
                            [SJM3U8DownloadListController.shared updateContentsForItemByUrl:[NSString stringWithFormat:@"%@",[realDownloadModelArr[l].standard[@"url"] mj_url]]];
                            [SJM3U8DownloadListController.shared updateContentsForItemByUrl:[NSString stringWithFormat:@"%@",[realDownloadModelArr[l].high[@"url"] mj_url]]];
                            [SJM3U8DownloadListController.shared updateContentsForItemByUrl:[NSString stringWithFormat:@"%@",[realDownloadModelArr[l].lossless[@"url"] mj_url]]];
                            
                            
                            [SJM3U8DownloadListController.shared addItemWithUrl:realDownloadUrlArr[l] withMusic:[realDownloadModelArr[l] mj_JSONObject]];
                            
                            
                            //下载歌词
                            if (realDownloadModelArr[l].lrc_url.length > 0) {
                                MioDownloadRequest *req = [[MioDownloadRequest alloc] initWinthUrl:[NSString stringWithFormat:@"%@",realDownloadModelArr[l].lrc_url.mj_url] fileName:[NSString stringWithFormat:@"%@.lrc",realDownloadModelArr[l].song_id]];
                                [req success:^(NSDictionary * _Nonnull result) {
                                    NSLog(@"批量歌词下载成功");
                                } failure:^(NSString * _Nonnull errorInfo) {
                                    NSLog(@"批量歌词下载失败");
                                }];
                                
                                [MioPostReq(api_addDownloadCount, @{@"k":@"v"}) success:^(NSDictionary *result){
                                    NSDictionary *data = [result objectForKey:@"data"];
                                    
                                } failure:^(NSString *errorInfo) {}];
                            }else{
                                
                            }
                        }
                        [UIWindow showSuccess:@"已加入下载列表"];
                    }
                    
                } failure:^(NSString *errorInfo) {
                    NSLog(@"%@",errorInfo);
                }];
                
               
                
            }

            [self hiddenView];
            if ([self.delegate respondsToSelector:@selector(chooseDownloadQuailtyDone)]) {
                [self.delegate chooseDownloadQuailtyDone];
            }
        }];
    }
}

@end
