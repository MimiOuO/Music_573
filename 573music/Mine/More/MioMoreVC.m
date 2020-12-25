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

@interface MioMoreVC ()
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UISwitch *integralSwitch;
@property (nonatomic, strong) UISwitch *wifiSwitch;
@property (nonatomic, strong) UISwitch *nightSwitch;
@property (nonatomic, strong) UILabel *defaultDownload;
@property (nonatomic, strong) UILabel *defaultPlay;
@property (nonatomic, strong) UILabel *cacheSize;
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
    NSArray *fuc1Arr = @[@"修改密码",@"定时关闭",@"显示积分倒计时",@"夜间模式",@"听歌识曲",@"仅WIFI联网",@"扫一扫",@"默认下载音质",@"默认播放音质"];
    NSArray *fuc2Arr = @[@"清除缓存",@"意见反馈",@"关于我们"];
    NSArray *arrowArr = @[@"设置密码",@"修改密码",@"听歌识曲",@"扫一扫",@"意见反馈",@"关于我们"];
    
    UIView *bgView1 = [UIView creatView:frame(Mar, 12, KSW - Mar2 , 44*fuc1Arr.count) inView:bgscroll bgColor:color_card radius:6];
    for (int i = 0;i < fuc1Arr.count; i++) {
        UILabel *title = [UILabel creatLabel:frame(12, i * 44, KSW - Mar2 - 12 , 44) inView:bgView1 text:fuc1Arr[i] color:color_text_one size:16 alignment:NSTextAlignmentLeft];
        [title whenTapped:^{
            [self click:fuc1Arr[i]];
        }];
        UIView *split = [UIView creatView:frame(10, 44 * (i + 1), KSW_Mar2 - 20, 0.5) inView:bgView1 bgColor:color_split radius:0];
        if ([arrowArr containsObject:fuc1Arr[i]]) {
            UIImageView *arrow = [UIImageView creatImgView:frame(KSW_Mar2 - 12 -20, 12 + 44*i, 20, 20) inView:bgView1 image:@"right" bgTintColor:color_icon_three radius:0];
        }
        if (Equals(fuc1Arr[i], @"定时关闭")) {
            _timeLab = [UILabel creatLabel:frame(KSW_Mar2 - 12 - 100, 44*i, 100, 44) inView:bgView1 text:@"关" color:color_text_two size:14 alignment:NSTextAlignmentRight];
        }
        if (Equals(fuc1Arr[i], @"显示积分倒计时")) {
            _integralSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(KSW_Mar2 - 38 - 20, 7.5 +44*i, 38, 23)];
            _integralSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [_integralSwitch addTarget:self action:@selector(integralClick) forControlEvents:(UIControlEventValueChanged)];
            [bgView1 addSubview:_integralSwitch];
        }
        if (Equals(fuc1Arr[i], @"夜间模式")) {
            _nightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(KSW_Mar2 - 38 - 20, 7.5 +44*i, 38, 23)];
            _nightSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [_nightSwitch addTarget:self action:@selector(nightClick) forControlEvents:(UIControlEventValueChanged)];
            [bgView1 addSubview:_nightSwitch];
            if (Equals(SkinName, @"hei")) {
                _nightSwitch.on = YES;
            }
        }
        if (Equals(fuc1Arr[i], @"仅WIFI联网")) {
            _wifiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(KSW_Mar2 - 38 - 20, 7.5 +44*i, 38, 23)];
            _wifiSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [_wifiSwitch addTarget:self action:@selector(wifiClick) forControlEvents:(UIControlEventValueChanged)];
            [bgView1 addSubview:_wifiSwitch];
        }
        if (Equals(fuc1Arr[i], @"默认下载音质")) {
            _cacheSize = [UILabel creatLabel:frame(KSW_Mar2 - 12 - 100, 44*i, 100, 44) inView:bgView1 text:@"标清" color:color_text_two size:14 alignment:NSTextAlignmentRight];
        }
        if (Equals(fuc1Arr[i], @"默认播放音质")) {
            _cacheSize = [UILabel creatLabel:frame(KSW_Mar2 - 12 - 100, 44*i, 100, 44) inView:bgView1 text:@"标清" color:color_text_two size:14 alignment:NSTextAlignmentRight];
        }
        
    }
    
    UIView *bgView2 = [UIView creatView:frame(Mar, bgView1.bottom + 8, KSW_Mar2 , 44*fuc2Arr.count) inView:bgscroll bgColor:color_card radius:6];
    for (int i = 0;i < fuc2Arr.count; i++) {
        UILabel *title = [UILabel creatLabel:frame(12, i * 44, KSW - Mar2 - 12 , 44) inView:bgView2 text:fuc2Arr[i] color:color_text_one size:16 alignment:NSTextAlignmentLeft];
        [title whenTapped:^{
            [self click:fuc2Arr[i]];
        }];
        UIView *split = [UIView creatView:frame(10, 44 * (i + 1), KSW - Mar2 - 20, 0.5) inView:bgView2 bgColor:color_split radius:0];
        if ([arrowArr containsObject:fuc2Arr[i]]) {
            UIImageView *arrow = [UIImageView creatImgView:frame(KSW_Mar2 - 12 -20, 12 + 44*i, 20, 20) inView:bgView2 image:@"right" bgTintColor:color_icon_three radius:0];
        }
        if (i == 0) {
            _cacheSize = [UILabel creatLabel:frame(KSW_Mar2 - 12 - 100, 44*i, 100, 44) inView:bgView2 text:[NSString stringWithFormat:@"%.1fM",[self filePath]] color:color_text_two size:14 alignment:NSTextAlignmentRight];
        }
    }
    
    UIButton *logoutBtn = [UIButton creatBtn:frame(Mar, bgView2.bottom + 8, KSW_Mar2, 44) inView:bgscroll bgColor:color_card title:@"退出登录" titleColor:redTextColor font:16 radius:6 action:^{
        [self logout];
    }];
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
        [userdefault setObject:nil forKey:@"isMaster"];
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
}

-(void)integralClick{
    
}

-(void)nightClick{

    if (_nightSwitch.on) {
        [userdefault setObject:@"hei" forKey:@"skin"];
    }else{
        [userdefault setObject:@"bai" forKey:@"skin"];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkin" object:nil];
}

-(void)wifiClick{
    NSLog(@"%d",_wifiSwitch.on);
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
