//
//  MioVerifyCodeVC.m
//  orrilan
//
//  Created by Mimio on 2019/8/16.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioVerifyCodeVC.h"
#import "HWTFCursorView.h"
#import "MioUserAgreementVC.h"
#import <SVGA.h>
@interface MioVerifyCodeVC ()
@property (nonatomic, strong) HWTFCursorView *code4View;
@end

@implementation MioVerifyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = appWhiteColor;
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    self.navView.split.hidden = YES;    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:@"verifyCode" object:nil];
    
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavH, KSW, KSH - NavH)];
    [self.view addSubview:scroll];
    UILabel *titleLabel = [UILabel creatLabel:frame(19,  IPHONE_X?60:30, 200, 30) inView:scroll text:@"请输入验证码" color:subColor size:18];
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    
    UILabel *tipLab = [UILabel creatLabel:frame(19, titleLabel.bottom + 59, 200, 17) inView:scroll text:[NSString stringWithFormat:@"验证码已发送至 %@",self.phoneNumber] color:grayTextColor size:12];
    
    _code4View = [[HWTFCursorView alloc] initWithCount:6 kmargin:20];
    _code4View.frame = CGRectMake(19, tipLab.bottom + 20, KSW - 38  , 50);
    
    [scroll addSubview:_code4View];
    
    
    SVGAPlayer *logoPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, KSH - KSW*0.972 - NavH, KSW, KSW*0.972)];
    [scroll addSubview:logoPlayer];
    SVGAParser *parser = [[SVGAParser alloc] init];
    [parser parseWithNamed:@"login" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            if (videoItem != nil) {
                NSLog(@"请求完毕");
                logoPlayer.videoItem = videoItem;
                [logoPlayer startAnimation];
                

            
        }
    } failureBlock:^(NSError * _Nonnull error) {
         NSLog(@"%@",error);
     }];
    
    UILabel *tip = [UILabel creatLabel:frame(KSW/2 - 120, KSH - NavH - SafeBotH - 34, 100, 17) inView:scroll text:@"登录即代表您同意" color:subColor size:12];
    UIButton *agreeMentBtn = [UIButton creatBtn:frame(tip.right, tip.top, 140, 17) inView:scroll bgColor:appClearColor title:@"《用户协议与隐私政策》" WithTag:1 target:self action:@selector(xieyi)];
          agreeMentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
          [agreeMentBtn setTitleColor:rgb(113, 140, 255) forState:UIControlStateNormal];

}

- (void)keyboardWillBeHiden:(NSNotification *)notification
{
    if (self.code4View.code.length == 4) {
        if (self.wx) {
            
        }else{
            [self loginRequest];
        }
    }
    
}


-(void)loginRequest{
    NSDictionary *dic = @{
                          @"verification_key":self.verification_key,
                          @"verification_code":self.code4View.code,
                          };

    MioPostRequest *request = [[MioPostRequest alloc] initWithRequestUrl:api_login argument:dic];
    if (self.wx) {
        MioPostRequest *request = [[MioPostRequest alloc] initWithRequestUrl:api_login argument:dic];
    }
    [request success:^(NSDictionary *result) {

        NSDictionary *data = [result objectForKey:@"data"];
        NSString * token = [data objectForKey:@"access_token"];
        MioUserInfo *user = [MioUserInfo mj_objectWithKeyValues:[data objectForKey:@"user"]];
        [userdefault setObject:token forKey:@"token"];
        [userdefault setObject:[[data objectForKey:@"shop"] objectForKey:@"shop_status"] forKey:@"shop_status"];
        [userdefault setObject:user.user_id forKey:@"user_id"];
        [userdefault setObject:user.nickname forKey:@"nickname"];
        [userdefault setObject:user.avatar forKey:@"avatar"];
        [userdefault synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        
    } failure:^(NSString *errorInfo) {
        //[svprogressHUD showErrorWithStatus:@"验证码不正确"];
    }];
}

-(void)xieyi{
    MioUserAgreementVC *vc = [[MioUserAgreementVC alloc] init];
    vc.url = @"https://duoduo.apphw.com/policy.html";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
