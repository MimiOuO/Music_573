//
//  MioMoreVC.m
//  573music
//
//  Created by Mimio on 2020/12/15.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMoreVC.h"
#import "MioTimeOffVC.h"
#import "AppDelegate.h"
#import "MioTabbarVC.h"
#import "MioListenMusicVC.h"
#import "WBQRCodeVC.h"
#import "MioAboutUsVC.h"
#import "MioFeedBackVC.h"
#import "MioModiPassWordVC.h"
#import "MioChooseDefaultQuailtyView.h"
@interface MioMoreVC ()<defaultQuailtyDelegate>
@property (nonatomic, strong) MioLabel *timeLab;
@property (nonatomic, strong) UISwitch *jifenSwitch;
@property (nonatomic, strong) UISwitch *wifiSwitch;
@property (nonatomic, strong) UISwitch *nightSwitch;
@property (nonatomic, strong) MioLabel *defaultPlay;
@property (nonatomic, strong) MioLabel *cacheSize;
@end

@implementation MioMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"更多" forState:UIControlStateNormal];
    [self creatUI];
    RecieveNotice(@"timeoff", timeoff:);
}

-(void)creatUI{
    UIScrollView *bgscroll = [UIScrollView creatScroll:frame(0, NavH, KSW, KSH - NavH) inView:self.view contentSize:CGSizeMake(KSW, 580)];
    NSArray *fuc1Arr = @[@"修改密码",@"定时关闭",@"显示积分倒计时",@"夜间模式",@"听歌识曲",@"仅WIFI联网",@"扫一扫",@"默认播放音质"];
    NSArray *fuc2Arr = @[@"清除缓存",@"意见反馈",@"关于我们"];
    NSArray *arrowArr = @[@"设置密码",@"修改密码",@"听歌识曲",@"扫一扫",@"意见反馈",@"关于我们"];
    
    MioView *bgView1 = [MioView creatView:frame(Mar, 12, KSW - Mar2 , 44*fuc1Arr.count) inView:bgscroll bgColorName:name_card radius:6];
    for (int i = 0;i < fuc1Arr.count; i++) {
        MioLabel *title = [MioLabel creatLabel:frame(12, i * 44, KSW - Mar2 - 12 , 44) inView:bgView1 text:fuc1Arr[i] colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        [title whenTapped:^{
            [self click:fuc1Arr[i]];
        }];

        MioView *split = [MioView creatView:frame(10, 44 * (i + 1), KSW_Mar2 - 20, 0.5) inView:bgView1 bgColorName:name_split radius:0];
        if ([arrowArr containsObject:fuc1Arr[i]]) {
            MioImageView *arrow = [MioImageView creatImgView:frame(KSW_Mar2 - 12 -20, 12 + 44*i, 20, 20) inView:bgView1 image:@"right" bgTintColorName:name_icon_three radius:0];
        }
        if (Equals(fuc1Arr[i], @"定时关闭")) {

            _timeLab = [MioLabel creatLabel:frame(KSW_Mar2 - 12 - 100, 44*i, 100, 44) inView:bgView1 text:@"关" colorName:name_text_two size:14 alignment:NSTextAlignmentRight];

        }
        if (Equals(fuc1Arr[i], @"显示积分倒计时")) {
            _jifenSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(KSW_Mar2 - 38 - 20, 7.5 +44*i, 38, 23)];
            _jifenSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [_jifenSwitch addTarget:self action:@selector(jifenClick) forControlEvents:(UIControlEventValueChanged)];
            [bgView1 addSubview:_jifenSwitch];
            if (Equals([userdefault objectForKey:@"showJifen"], @"1")) {
                _jifenSwitch.on = YES;
            }else{
                _jifenSwitch.on = NO;
            }
        }
        if (Equals(fuc1Arr[i], @"夜间模式")) {
            _nightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(KSW_Mar2 - 38 - 20, 7.5 +44*i, 38, 23)];
            _nightSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [_nightSwitch addTarget:self action:@selector(nightClick) forControlEvents:(UIControlEventValueChanged)];
            [bgView1 addSubview:_nightSwitch];
            if (Equals(SkinName, @"hei")) {
                _nightSwitch.on = YES;
            }else{
                _nightSwitch.on = NO;
            }
        }
        if (Equals(fuc1Arr[i], @"仅WIFI联网")) {
            _wifiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(KSW_Mar2 - 38 - 20, 7.5 +44*i, 38, 23)];
            _wifiSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [_wifiSwitch addTarget:self action:@selector(wifiClick) forControlEvents:(UIControlEventValueChanged)];
            [bgView1 addSubview:_wifiSwitch];
            if (Equals([userdefault objectForKey:@"onlyWifi"], @"1")) {
                _wifiSwitch.on = YES;
            }else{
                _wifiSwitch.on = NO;
            }
        }
        if (Equals(fuc1Arr[i], @"默认播放音质")) {
            NSLog(@"%@",[userdefault objectForKey:@"defaultQuailty"]);
            _defaultPlay = [MioLabel creatLabel:frame(KSW_Mar2 - 12 - 100, 44*i, 100, 44) inView:bgView1 text:[userdefault objectForKey:@"defaultQuailty"] colorName:name_text_two size:14 alignment:NSTextAlignmentRight];
        }
        
    }

    MioView *bgView2 = [MioView creatView:frame(Mar, bgView1.bottom + 8, KSW_Mar2 , 44*fuc2Arr.count) inView:bgscroll bgColorName:name_card radius:6];
    for (int i = 0;i < fuc2Arr.count; i++) {
        MioLabel *title = [MioLabel creatLabel:frame(12, i * 44, KSW - Mar2 - 12 , 44) inView:bgView2 text:fuc2Arr[i] colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        [title whenTapped:^{
            [self click:fuc2Arr[i]];
        }];
        MioView *split = [MioView creatView:frame(10, 44 * (i + 1), KSW_Mar2 - 20, 0.5) inView:bgView2 bgColorName:name_split radius:0];
        if ([arrowArr containsObject:fuc2Arr[i]]) {
            MioImageView *arrow = [MioImageView creatImgView:frame(KSW_Mar2 - 12 -20, 12 + 44*i, 20, 20) inView:bgView2 image:@"right" bgTintColorName:name_icon_three radius:0];
        }
        if (i == 0) {
            _cacheSize = [MioLabel creatLabel:frame(KSW_Mar2 - 12 - 100, 44*i, 100, 44) inView:bgView2 text:[NSString stringWithFormat:@"%.1fM",[self filePath]] colorName:name_text_two size:14 alignment:NSTextAlignmentRight];
        }
    }
    
    if (islogin) {
        MioView *bgView3 = [MioView creatView:frame(Mar, bgView2.bottom + 8, KSW_Mar2, 44) inView:bgscroll bgColorName:name_card radius:6];
        UIButton *logoutBtn = [UIButton creatBtn:frame(Mar, bgView2.bottom + 8, KSW_Mar2, 44) inView:bgscroll bgColor:appClearColor title:@"退出登录" titleColor:redTextColor font:16 radius:6 action:^{
            [self logout];
        }];
    }

}

-(void)logout{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [userdefault setObject:nil forKey:@"token"];
        [userdefault setObject:nil forKey:@"user_id"];
        [userdefault setObject:nil forKey:@"nickname"];
        [userdefault setObject:nil forKey:@"avatar"];
        [userdefault setObject:nil forKey:@"phone"];
        [userdefault synchronize];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MioTabbarVC *tab = (MioTabbarVC *)delegate.window.rootViewController;
        tab.selectedIndex = 0;
        
        [self.navigationController popViewControllerAnimated:YES];

    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    alertController.modalPresentationStyle = 0;
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)click:(NSString *)title{
    if (Equals(title, @"修改密码")) {
        MioModiPassWordVC *timeOff = [[MioModiPassWordVC alloc] init];
        timeOff.phoneNumber = currentUserPhone;
        [self.navigationController pushViewController:timeOff animated:YES];
    }
    if (Equals(title, @"清除缓存")) {
        [self clearFile];
    }
    if (Equals(title, @"定时关闭")) {
        MioTimeOffVC *timeOff = [[MioTimeOffVC alloc] init];
        [self.navigationController pushViewController:timeOff animated:YES];
    }
    if (Equals(title, @"听歌识曲")) {
        MioListenMusicVC *vc = [[MioListenMusicVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (Equals(title, @"扫一扫")) {
        WBQRCodeVC *vc = [[WBQRCodeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (Equals(title, @"关于我们")) {
        MioAboutUsVC *vc = [[MioAboutUsVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (Equals(title, @"意见反馈")) {
        MioFeedBackVC *vc = [[MioFeedBackVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (Equals(title, @"默认播放音质")) {
        MioChooseDefaultQuailtyView *vc = [[MioChooseDefaultQuailtyView alloc] init];
        vc.delegate = self;
        [vc show];
    }
}

-(void)jifenClick{
    if (_jifenSwitch.on) {
        [userdefault setObject:@"1" forKey:@"showJifen"];
    }else{
        [userdefault setObject:@"0" forKey:@"showJifen"];
    }
    
}

-(void)nightClick{
    [UIWindow showInfo:@"模式切换中，请耐心等待"];
    if (_nightSwitch.on) {
        [userdefault setObject:[userdefault objectForKey:@"skin"] forKey:@"boforeSkin"];
        [userdefault setObject:@"hei" forKey:@"skin"];
        [userdefault synchronize];
        [userdefault setObject:colorDic forKey:@"colorJson"];
        [userdefault synchronize];
    }else{
        [userdefault setObject:[userdefault objectForKey:@"boforeSkin"] forKey:@"skin"];
        [userdefault synchronize];
        [userdefault setObject:colorDic forKey:@"colorJson"];
        [userdefault synchronize];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkin" object:nil];
    });
    
    [self.navView.centerButton setTitleColor:color_text_one forState:UIControlStateNormal];
    self.navView.leftButton.tintColor = color_text_one;
}

-(void)wifiClick{
    if (_wifiSwitch.on) {
        [userdefault setObject:@"1" forKey:@"onlyWifi"];
    }else{
        [userdefault setObject:@"0" forKey:@"onlyWifi"];
    }
}

- (void)changeDefaultQuailty{
    _defaultPlay.text = [userdefault objectForKey:@"defaultQuailty"];
}

#pragma mark - timeoff
- (void)timeoff:(NSNotification *)notification{
    NSString *count =  notification.userInfo[@"count"];
    if ([count intValue] < 1) {
        _timeLab.text = @"关";
    }else{
        _timeLab.text = [NSDate stringDuartion:[count floatValue]];
    }
    
}

#pragma mark - 清除缓存
// 显示缓存大小
-( float )filePath
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}

// 清理缓存

- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    [UIWindow showInfo:@"清除缓存成功"];
    _cacheSize.text = @"0.0M";
    
}


@end
