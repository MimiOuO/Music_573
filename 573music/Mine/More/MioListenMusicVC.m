//
//  MioListenMusicVC.m
//  573music
//
//  Created by Mimio on 2020/12/25.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioListenMusicVC.h"
#import "ACRCloudRecognition.h"
#import "ACRCloudConfig.h"
#import "YSCRippleView.h"
#import "PYSearchViewController.h"
#import "MioSearchResultVC.h"
@interface MioListenMusicVC ()
@property (nonatomic, strong) ACRCloudRecognition *client;
@property (nonatomic, strong) ACRCloudConfig *config;
@property (nonatomic, assign) BOOL start;
@property (nonatomic, strong) YSCRippleView *rippleView;
@end

@implementation MioListenMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"听歌识曲" forState:UIControlStateNormal];
    
    [self creatUI];
    _start = NO;
    
    _config = [[ACRCloudConfig alloc] init];
    
    _config.accessKey = @"91faff5dc1b1e1163da0864d88658672";
    _config.accessSecret = @"ZGF6TDm4QbMKG7LYtO5CIJ9IiGybJ68GansqaHCN";
    _config.host = @"identify-cn-north-1.acrcloud.cn";
    _config.protocol = @"https";
    _config.recMode = rec_mode_remote;
    _config.requestTimeout = 10;
    
    if (_config.recMode == rec_mode_local || _config.recMode == rec_mode_both)
        _config.homedir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"acrcloud_local_db"];
    
    __weak typeof(self) weakSelf = self;
    
    _config.stateBlock = ^(NSString *state) {
        [weakSelf handleState:state];
    };
    
    _config.resultBlock = ^(NSString *result, ACRCloudResultType resType) {
        [weakSelf handleResult:result resultType:resType];
        NSDictionary *resultDic = [result mj_JSONObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            //主线程执行
            
            NSArray *musicArr =  [[resultDic objectForKey:@"metadata"] objectForKey:@"music"];
            if (musicArr) {

                PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索品类、ID、昵称"];
                searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
                MioSearchResultVC *resultVC = [[MioSearchResultVC alloc] init];
                searchViewController.searchResultController = resultVC;
                searchViewController.delegate = resultVC;
                searchViewController.searchBarBackgroundColor = color_card;
                searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
                searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
                searchViewController.searchBar.text = [musicArr[0] objectForKey:@"title"];
                
                
                CATransition* transition = [CATransition animation];
                transition.type = kCATransitionMoveIn;//可更改为其他方式
                transition.subtype = kCATransitionFromTop;//可更改为其他方式
                [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

                [self.navigationController pushViewController:searchViewController animated:NO];
                [searchViewController autoSearch];
            }else{
                [UIWindow showInfo:@"没有识别到歌曲哦，换一段音乐试试吧"];
            
            }
            
            [self stopRecognition];
        });
        
    };
    
    _client = [[ACRCloudRecognition alloc] initWithConfig:_config];

    //start pre-record
    [_client startPreRecord:3000];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_client stopRecordRec];
}

-(void)creatUI{
    
    MioView *btnBg = [MioView creatView:frame((KSW - 80)/2, 20, 120, 120) inView:self.view bgColorName:name_main radius:60];
    btnBg.centerX = self.view.centerX;
    btnBg.centerY = 200 + (KSW - 375)/2 + 162.5 + 25;
    btnBg.layer.borderWidth = 2;
    btnBg.layer.borderColor = rgba(255, 255, 255, 0.5).CGColor;
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake((KSW - 80)/2, 20, 120, 120);
    btn1.centerX = self.view.centerX;
    btn1.centerY = 200 + (KSW - 375)/2 + 162.5 + 25;
    btn1.alpha = 0.5;
    [btn1 setImage:[UIImage imageNamed:@"tgsq_logo"] forState:UIControlStateNormal];
    [btn1 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(startRecognition:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startRecognition:(id)sender {
    if (_start) {
        return;
    }
    [self.view addSubview:self.rippleView];
    [self.view insertSubview:self.rippleView atIndex:1];
    [_rippleView showWithRippleType:YSCRippleTypeCircle];
    
//    self.resultView.text = @"";
//    self.costLabel.text = @"";
    
    [_client startRecordRec];
    _start = YES;
    
//    startTime = [[NSDate date] timeIntervalSince1970];
}

- (void)stopRecognition{
    if(_client) {
        [_client stopRecordRec];
        [_rippleView removeFromParentView];
    }
    _start = NO;
}

-(void)handleResultFp:(NSString *)result
         fingerprint:(NSData*)fingerprint
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", result);
        
        // the fingerprint is nil when can't generate fingerprint from pcm data.
        if (fingerprint) {
            NSLog(@"fingerprint data length = %ld", fingerprint.length);
        }
        [self->_client stopRecordRec];
        self->_start = NO;
    });
}

-(void)handleResultData:(NSString *)result
                   data:(NSData*)pcm_data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", result);
        
        if (pcm_data) {
            NSLog(@"pcm data length = %ld", pcm_data.length);
        }
        [self->_client stopRecordRec];
        self->_start = NO;
    });
}

-(void)handleResult:(NSString *)result
         resultType:(ACRCloudResultType)resType
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;

        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSString *r = nil;
        
        NSLog(@"%@", result);

        if ([[jsonObject valueForKeyPath: @"status.code"] integerValue] == 0) {
            if ([jsonObject valueForKeyPath: @"metadata.music"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.music"][0];
                NSString *title = [meta objectForKey:@"title"];
                NSString *artist = [meta objectForKey:@"artists"][0][@"name"];
                NSString *album = [meta objectForKey:@"album"][@"name"];
                NSString *play_offset_ms = [meta objectForKey:@"play_offset_ms"];
                NSString *duration = [meta objectForKey:@"duration_ms"];

                NSArray *ra = @[[NSString stringWithFormat:@"title:%@", title],
                            [NSString stringWithFormat:@"artist:%@", artist],
                              [NSString stringWithFormat:@"album:%@", album],
                                [NSString stringWithFormat:@"play_offset_ms:%@", play_offset_ms],
                                [NSString stringWithFormat:@"duration_ms:%@", duration]];
                r = [ra componentsJoinedByString:@"\n"];
            }
            if ([jsonObject valueForKeyPath: @"metadata.custom_files"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.custom_files"][0];
                NSString *title = [meta objectForKey:@"title"];
                NSString *audio_id = [meta objectForKey:@"audio_id"];
                
                r = [NSString stringWithFormat:@"title : %@\naudio_id : %@", title, audio_id];
            }
            if ([jsonObject valueForKeyPath: @"metadata.streams"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.streams"][0];
                NSString *title = [meta objectForKey:@"title"];
                NSString *title_en = [meta objectForKey:@"title_en"];
                
                r = [NSString stringWithFormat:@"title : %@\ntitle_en : %@", title,title_en];
            }
            if ([jsonObject valueForKeyPath: @"metadata.custom_streams"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.custom_streams"][0];
                NSString *title = [meta objectForKey:@"title"];
                
                r = [NSString stringWithFormat:@"title : %@", title];
            }
            if ([jsonObject valueForKeyPath: @"metadata.humming"]) {
                NSArray *metas = [jsonObject valueForKeyPath: @"metadata.humming"];
                NSMutableArray *ra = [NSMutableArray arrayWithCapacity:6];
                for (id d in metas) {
                    NSString *title = [d objectForKey:@"title"];
                    NSString *score = [d objectForKey:@"score"];
                    NSString *sh = [NSString stringWithFormat:@"title : %@  score : %@", title, score];
                    
                    [ra addObject:sh];
                }
                r = [ra componentsJoinedByString:@"\n"];
            }
            
//            self.resultView.text = r;
        } else {
//            self.resultView.text = result;
        }
        
        [self->_client stopRecordRec];
        self->_start = NO;

//        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
//        int cost = nowTime - startTime;
//        self.costLabel.text = [NSString stringWithFormat:@"cost : %ds", cost];

    });
}

-(void)handleState:(NSString *)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.stateLabel.text = [NSString stringWithFormat:@"State : %@",state];
    });
}

- (YSCRippleView *)rippleView {
    if (!_rippleView) {
        self.rippleView = [[YSCRippleView alloc] initWithFrame:CGRectMake(0, 100, KSW, KSW)];
        self.rippleView.rippleButton.centerY = self.rippleView.centerY;
        
//        self.rippleView.center = CGPointMake(100, 100);
    }
    return _rippleView;
}




@end
