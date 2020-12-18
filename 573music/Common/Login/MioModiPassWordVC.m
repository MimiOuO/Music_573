//
//  MioModiPassWordViewController.m
//  shunyishangjia
//
//  Created by Mimio on 2019/6/3.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioModiPassWordVC.h"
#import "WLCaptcheButton.h"
#import "MioUserAgreementVC.h"
#import "MioLargeButton.h"
#import "UITextField+NumberFormat.h"

@interface MioModiPassWordVC ()
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *passwordTF2;
@property (nonatomic, strong) UITextField *verifyTF;
@property (nonatomic, strong) MioLargeButton *agreeBtn;
@property (nonatomic, strong) WLCaptcheButton *countBtn;
@property (nonatomic,copy) NSString * key;
@property (nonatomic, strong) MioLargeButton *friendshipBtn1;
@property (nonatomic, strong) UILabel *password;
@property (nonatomic, strong) UILabel *forgetPassword;
@end

@implementation MioModiPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = appWhiteColor;

    self.navView.split.hidden = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self creatUI];
}

-(void)creatUI{

    UIScrollView *scroll = [UIScrollView creatScroll:frame(0, StatusH, KSW, KSH - StatusH) inView:self.view contentSize:CGSizeMake(0, 0)];

    
    UIButton *closeBtn = [UIButton creatBtn:frame(0, StatusH, 56, 44) inView:self.view bgImage:@"backArrow" bgTintColor:color_icon_one action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];

    UILabel *titleLabel = [UILabel creatLabel:frame(Mar, StatusH + 60, 250, 30) inView:scroll text:@"修改密码" color:color_text_one boldSize:26 alignment:NSTextAlignmentLeft];
    UILabel *tip = [UILabel creatLabel:frame(Mar, titleLabel.bottom + 8, KSW, 12) inView:scroll text:@"" color:color_text_two size:12 alignment:NSTextAlignmentLeft];
    UIView *phoneView = [UIView creatView:frame(Mar, tip.bottom + 60, KSW - 2*Mar, 48) inView:scroll bgColor:color_search radius:8];
    UIView *passwordView = [UIView creatView:frame(Mar, phoneView.bottom + 8, KSW - 2*Mar, 48) inView:scroll bgColor:color_search radius:8];
    UIView *passwordView2 = [UIView creatView:frame(Mar, passwordView.bottom + 8, KSW - 2*Mar, 48) inView:scroll bgColor:color_search radius:8];
    

    //======================================================================//
    //                               用户名
    //======================================================================//

    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(8, 16 ,  KSW - 48, 16)];
    self.phoneTF.delegate = self;
    self.phoneTF.font = [UIFont systemFontOfSize:16];
    self.phoneTF.placeholder = @"请输入11位手机号码";
    self.phoneTF.textColor = color_text_one;
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:self.phoneTF];

    
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(8, 16 ,  KSW - 48, 16)];
    self.passwordTF.delegate = self;
    self.passwordTF.font = [UIFont systemFontOfSize:16];
    self.passwordTF.placeholder = @"请输入密码";
    self.passwordTF.textColor = color_text_one;
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.keyboardType = UIKeyboardTypeNumberPad;
    [passwordView addSubview:self.passwordTF];
    
    self.passwordTF2 = [[UITextField alloc] initWithFrame:CGRectMake(8, 16 ,  KSW - 48, 16)];
    self.passwordTF2.delegate = self;
    self.passwordTF2.font = [UIFont systemFontOfSize:16];
    self.passwordTF2.placeholder = @"请再输入一遍";
    self.passwordTF2.textColor = color_text_one;
    self.passwordTF2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF2.keyboardType = UIKeyboardTypeNumberPad;
    [passwordView2 addSubview:self.passwordTF2];

    UIView *verifyView = [UIView creatView:frame(Mar, passwordView2.bottom + 8, KSW - 2*Mar, 48) inView:scroll bgColor:color_search radius:8];

    self.verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(8, 16 ,  KSW - 90, 16)];
    self.verifyTF.maxLength(4);
    self.verifyTF.font = [UIFont systemFontOfSize:16];
    self.verifyTF.placeholder = @"请输入验证码";
    self.verifyTF.textColor = color_text_one;
    self.verifyTF.keyboardType = UIKeyboardTypeNumberPad;
    [verifyView addSubview:self.verifyTF];

    _countBtn = [[WLCaptcheButton alloc] initWithFrame:CGRectMake(KSW - 88 - Mar2,8, 80, 32)];
    [_countBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_countBtn setTitleColor:color_main forState:UIControlStateNormal];
    [_countBtn addTarget:self action:@selector(handlecountEvent:) forControlEvents:UIControlEventTouchUpInside];
    _countBtn.titleLabel.font = Font(14);
    [verifyView addSubview:_countBtn];

    
    
    UIButton *loginBtn = [UIButton creatBtn:frame(Mar, verifyView.bottom + 40, KSW - Mar2, 48) inView:scroll bgColor:color_main title:@"修改密码" titleColor:appWhiteColor font:16 radius:8 action:^{
        [self login];
    }];
    


}

- (void)login{

    NSString *telNumber = [self.passwordTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_passwordTF.text.length != 13) {
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
        [userdefault synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}

-(void)handlecountEvent:(WLCaptcheButton *)sender{
    if (_passwordTF.text.length != 13) {
        [UIWindow showInfo:@"请输入正确手机号"];
        return;
    }
    NSString *telNumber = [self.passwordTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return [UITextField inputTextField:textField
         shouldChangeCharactersInRange:range
                     replacementString:string
                        blankLocations:@[@3,@8]
                            limitCount:11];
}


@end
