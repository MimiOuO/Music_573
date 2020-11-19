//
//  ZMLoginViewController.m
//  ZMBCY
//
//  Created by ZOMAKE on 2018/1/5.
//  Copyright © 2018年 Brance. All rights reserved.
//

#import "MioLoginVC.h"
#import "WLCaptcheButton.h"
#import "MioUserAgreementVC.h"
#import "UITextField+NumberFormat.h"
#import "MioBoundPhoneVC.h"
#import "MioLargeButton.h"
@interface MioLoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *verifyTF;
@property (nonatomic, strong) MioLargeButton *agreeBtn;
@property (nonatomic, strong) WLCaptcheButton *countBtn;
@property (nonatomic,copy) NSString * key;
@property (nonatomic, strong) MioLargeButton *friendshipBtn1;
@end

@implementation MioLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = appWhiteColor;

    [self.navView.centerButton setTitle:@"" forState:UIControlStateNormal];
    self.navView.split.hidden = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLoginSuccess:) name:@"wxLoginSuccess" object:nil];
    [self creatUI];
}

-(void)creatUI{

    UIScrollView *scroll = [UIScrollView creatScroll:frame(0, StatusH, KSW, KSH - StatusH) inView:self.view contentSize:CGSizeMake(0, 0)];

    
    UIButton *closeBtn = [UIButton creatBtn:frame(KSW - 56, StatusH, 56, 44) inView:self.view bgImage:@"landing_icon_exit" action:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    UILabel *titleLabel = [UILabel creatLabel:frame(Mar, StatusH + 60, 250, 30) inView:scroll text:@"欢迎来到莱恩课堂" color:subColor boldSize:24 alignment:NSTextAlignmentLeft];
    UILabel *tip = [UILabel creatLabel:frame(Mar, titleLabel.bottom + 8, KSW, 12) inView:scroll text:@"未注册的手机号码通过验证码登录后将自动注册" color:grayTextColor size:12 alignment:NSTextAlignmentLeft];
    UIView *phoneView = [UIView creatView:frame(Mar, tip.bottom + 60, KSW - 2*Mar, 48) inView:scroll bgColor:rgb(247, 247, 247) radius:8];
    
    

    //======================================================================//
    //                               用户名
    //======================================================================//
    UILabel *accoutLab = [UILabel creatLabel:frame(8, 16, 35, 16) inView:phoneView text:@"+86" color:subColor boldSize:16 alignment:NSTextAlignmentLeft];

    
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(48, 16 ,  KSW - 90, 16)];
    self.phoneTF.delegate = self;
    self.phoneTF.font = [UIFont systemFontOfSize:16];
    self.phoneTF.placeholder = @"请输入11位手机号码";
    self.phoneTF.textColor = subColor;
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:self.phoneTF];

    UIView *verifyView = [UIView creatView:frame(Mar, phoneView.bottom + 8, KSW - 2*Mar, 48) inView:scroll bgColor:rgb(247, 247, 247) radius:8];

    self.verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(8, 16 ,  KSW - 90, 16)];
    self.verifyTF.maxLength(4);
    self.verifyTF.font = [UIFont systemFontOfSize:16];
    self.verifyTF.placeholder = @"请输入验证码";
    self.verifyTF.textColor = subColor;
    self.verifyTF.keyboardType = UIKeyboardTypeNumberPad;
    [verifyView addSubview:self.verifyTF];

    _countBtn = [[WLCaptcheButton alloc] initWithFrame:CGRectMake(KSW - 88 - Mar2,8, 80, 32)];
    [_countBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_countBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [_countBtn addTarget:self action:@selector(handlecountEvent:) forControlEvents:UIControlEventTouchUpInside];
    _countBtn.disabledTitleColor = grayTextColor;
    _countBtn.titleLabel.font = Font(14);
    [verifyView addSubview:_countBtn];
    
    UIButton *loginBtn = [UIButton creatBtn:frame(Mar, verifyView.bottom + 40, KSW - Mar2, 48) inView:scroll bgColor:mainColor title:@"登录"  titleColor:appWhiteColor font:16 radius:8 action:^{
        [self login];
    }];
    
    
    UIImageView *img = [UIImageView creatImgView:frame(1, verifyView.bottom + 33, KSW - 1, 78) inView:scroll image:@"landing_button_projection" radius:0];
    
    
    UILabel *tip2 = [UILabel creatLabel:frame(KSW/2 - 73, KSH - StatusH - SafeBotH - 54, 146, 40) inView:scroll text:@"登录即代表您阅读并同意用户协议 和 隐私政策" color:grayTextColor size:12 alignment:NSTextAlignmentCenter];
    tip2.numberOfLines = 0;
    
    id attStr = AttStr(tip2.text).match(@"用户协议").match(@"隐私政策").linkForLabel;
    tip2.str(attStr).multiline.lineGap(8).centerAlignment.onLink(^(NSString *text) {
        if (Equals(text, @"用户协议")) {
            MioUserAgreementVC *vc = [[MioUserAgreementVC alloc] init];
            vc.url = @"https://duoduo.apphw.com/policy.html";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MioUserAgreementVC *vc = [[MioUserAgreementVC alloc] init];
            vc.url = @"https://duoduo.apphw.com/policy.html";
            [self.navigationController pushViewController:vc animated:YES];
        }

    });
}

- (void)login{

    NSString *telNumber = [self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_phoneTF.text.length != 13) {
        [UIWindow showInfo:@"请输入正确手机号"];
        return;
    }
    if (_verifyTF.text.length != 4){
        [UIWindow showInfo:@"请输入验证码"];
        return;
    }
    if (_key.length < 10 ){
        [UIWindow showInfo:@"请获取验证码"];
        return;
    }

    NSDictionary *dic = @{
                          @"verification_key":_key,
                          @"verification_code":self.verifyTF.text,
                          };
    MioPostRequest *request = [[MioPostRequest alloc] initWithRequestUrl:api_login argument:dic];
    
    [request success:^(NSDictionary *result) {
        NSDictionary *data = [result objectForKey:@"data"];
        [UIWindow showSuccess:@"登录成功"];
        
        NSString * token = [data objectForKey:@"access_token"];
        MioUserInfo *user = [MioUserInfo mj_objectWithKeyValues:[data objectForKey:@"user"]];
        [userdefault setObject:token forKey:@"token"];
        [userdefault setObject:user.user_id forKey:@"user_id"];
        [userdefault setObject:user.nickname forKey:@"nickname"];
        [userdefault setObject:user.avatar forKey:@"avatar"];
        [userdefault setObject:[NSNumber numberWithInt:user.is_teacher] forKey:@"isTeacher"];
        [userdefault synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}

-(void)handlecountEvent:(WLCaptcheButton *)sender{
    
    if (_phoneTF.text.length != 13) {
        [UIWindow showInfo:@"请输入正确手机号"];
        return;
    }
    NSString *telNumber = [self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *dic = @{
        @"phone":telNumber,
    };
    MioPostRequest *request = [[MioPostRequest alloc] initWithRequestUrl:api_getVerifyCode argument:dic];

    [request success:^(NSDictionary *result) {
        NSDictionary *data = [result objectForKey:@"data"];
        [sender fire];
        [UIWindow showInfo:@"验证码发送成功"];
        _key = [data objectForKey:@"key"];
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}


-(void)agreeBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return [UITextField inputTextField:textField
         shouldChangeCharactersInRange:range
                     replacementString:string
                        blankLocations:@[@3,@8]
                            limitCount:11];
}


@end
