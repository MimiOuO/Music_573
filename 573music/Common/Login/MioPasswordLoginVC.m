
//
//  MioPasswordLoginVC.m
//  orrilan
//
//  Created by Mimio on 2019/8/19.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioPasswordLoginVC.h"
#import "WLCaptcheButton.h"
#import "MioUserAgreementVC.h"
#import "UITextField+NumberFormat.h"
#import "MioLargeButton.h"
#import "MioModiPassWordVC.h"
@interface MioPasswordLoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *verifyTF;
@property (nonatomic, strong) MioLargeButton *agreeBtn;
@property (nonatomic, strong) WLCaptcheButton *countBtn;
@property (nonatomic,copy) NSString * key;
@property (nonatomic, strong) MioLargeButton *friendshipBtn1;
@property (nonatomic, strong) UILabel *password;
@property (nonatomic, strong) UILabel *forgetPassword;
@end

@implementation MioPasswordLoginVC

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

    UILabel *titleLabel = [UILabel creatLabel:frame(Mar, StatusH + 60, 250, 30) inView:scroll text:@"欢迎来到573音乐" color:color_text_one boldSize:26 alignment:NSTextAlignmentLeft];
    UILabel *tip = [UILabel creatLabel:frame(Mar, titleLabel.bottom + 8, KSW, 12) inView:scroll text:@"未注册的手机号码通过验证码登录后将自动注册" color:color_text_two size:12 alignment:NSTextAlignmentLeft];
    UIView *phoneView = [UIView creatView:frame(Mar, tip.bottom + 60, KSW - 2*Mar, 48) inView:scroll bgColor:color_search radius:8];
    
    

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

    UIView *verifyView = [UIView creatView:frame(Mar, phoneView.bottom + 8, KSW - 2*Mar, 48) inView:scroll bgColor:color_search radius:8];

    self.verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(8, 16 ,  KSW - 48, 16)];
    self.verifyTF.maxLength(30);
    self.verifyTF.font = [UIFont systemFontOfSize:16];
    self.verifyTF.placeholder = @"请输入密码";
    self.verifyTF.textColor = color_text_one;
    self.verifyTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyTF.secureTextEntry = YES;
    self.verifyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [verifyView addSubview:self.verifyTF];

    
    
    UIButton *loginBtn = [UIButton creatBtn:frame(Mar, verifyView.bottom + 40, KSW - Mar2, 48) inView:scroll bgColor:color_main title:@"密码登录" titleColor:appWhiteColor font:16 radius:8 action:^{
        [self login];
    }];
    

    _password = [UILabel creatLabel:frame(Mar, loginBtn.bottom + 16, 80, 20) inView:scroll text:@"验证码登录" color:color_text_two size:14 alignment:NSTextAlignmentLeft];
    [_password whenTapped:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];

    
    _forgetPassword = [UILabel creatLabel:frame(KSW - Mar - 80, loginBtn.bottom + 16, 80, 20) inView:scroll text:@"忘记密码" color:color_text_two size:14 alignment:NSTextAlignmentRight];
    [_forgetPassword whenTapped:^{
        MioModiPassWordVC *vc = [[MioModiPassWordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
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
    if (_verifyTF.text.length < 6){
        [UIWindow showInfo:@"请输入不少于6位密码"];
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
//
//@property (nonatomic, strong) UITextField *userNameField;
//@property (nonatomic, strong) UITextField *passwordField;
//@property (nonatomic, strong) UIButton *agreeBtn;
//@end
//
//@implementation MioPasswordLoginVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
//    self.navView.mainView.backgroundColor = appClearColor;
//    self.navView.split.hidden = YES;
//    [self creatUI];
//
//}
//
//-(void)creatUI{
//    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavH, KSW, KSH - NavH)];
//    [self.view addSubview:scroll];
//
//
//
//    UILabel *titleLabel = [UILabel creatLabel:frame(19, IPHONE_X?60:30, 200, 30) inView:scroll text:@"密码登录" color:subColor size:30];
//    titleLabel.font = [UIFont boldSystemFontOfSize:30];
//
//    //======================================================================//
//    //                               用户名
//    //======================================================================//
//    UILabel *accoutLab = [UILabel creatLabel:frame(19, titleLabel.bottom + 60, 35, 16) inView:scroll text:@"账号" color:subColor size:16 alignment:NSTextAlignmentLeft];
//
//    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(80, titleLabel.bottom + 59 ,  KSW - 46, 17)];
//    self.userNameField.delegate = self;
//    self.userNameField.font = [UIFont systemFontOfSize:16];
//    self.userNameField.placeholder = @"请输入手机号";
//    self.userNameField.textColor = subColor;
//
//    [self.userNameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    self.userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.userNameField.keyboardType = UIKeyboardTypeNumberPad;
//    [scroll addSubview:self.userNameField];
//
//    UIView *split1 = [UIView creatView:frame(23, self.userNameField.bottom + 21, KSW - 46, 0.5) inView:scroll bgColor:botLineColor];
//
//    //======================================================================//
//    //                               密码
//    //======================================================================//
//    UILabel *paswLab = [UILabel creatLabel:frame(19, split1.bottom + 30, 35, 16) inView:scroll text:@"密码" color:subColor size:16 alignment:NSTextAlignmentLeft];
//
//    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(80, split1.bottom + 30 ,  KSW - 46, 17)];
//    self.passwordField.font = [UIFont systemFontOfSize:16];
//    self.passwordField.placeholder = @"请输入登录密码";
//    self.passwordField.textColor = subColor;
//    self.passwordField.secureTextEntry = YES;
//    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [scroll addSubview:self.passwordField];
//
//    UIView *split2 = [UIView creatView:frame(23, self.passwordField.bottom + 21, KSW - 46, 0.5) inView:scroll bgColor:botLineColor];
//
//   SVGAPlayer *logoPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, KSH -  KSW*0.972 - NavH, KSW, KSW*0.972)];
//   [scroll addSubview:logoPlayer];
//   SVGAParser *parser = [[SVGAParser alloc] init];
//   [parser parseWithNamed:@"login" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
//           if (videoItem != nil) {
//               NSLog(@"请求完毕");
//               logoPlayer.videoItem = videoItem;
//               [logoPlayer startAnimation];
//
//
//
//       }
//   } failureBlock:^(NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//
//
//   UILabel *tip = [UILabel creatLabel:frame(KSW/2 - 120, KSH - NavH - SafeBotH - 34, 100, 17) inView:scroll text:@"登录即代表您同意" color:subColor size:12];
//   UIButton *agreeMentBtn = [UIButton creatBtn:frame(tip.right, tip.top, 140, 17) inView:scroll bgColor:appClearColor title:@"《用户协议与隐私政策》" WithTag:1 target:self action:@selector(xieyi)];
//         agreeMentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//         [agreeMentBtn setTitleColor:rgb(113, 140, 255) forState:UIControlStateNormal];
//
//    UIButton *btn = [UIButton creatBtn:frame(19, split2.bottom + 40, KSW - 38, 44) inView:scroll bgImage:@"button" WithTag:1 target:self action:@selector(handleLoginEvent:)];
//    UILabel *btnlabel = [UILabel creatLabel:frame(19, split2.bottom + 40, KSW - 38, 44) inView:scroll text:@"登录" color:appWhiteColor size:14];
//    btnlabel.textAlignment = NSTextAlignmentCenter;
//
//
//
//}
//
//- (void)handleLoginEvent:(id)sender {
//
//    NSString *telNumber = [self.userNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    if (telNumber.length != 11) {
//        //[svprogressHUD showErrorWithStatus:@"请输入正确的手机号！"];
//        return;
//    }
//
//
//    if (self.passwordField.text.length < 6) {
//        //[svprogressHUD showErrorWithStatus:@"请输入正确密码！"];
//        return;
//    }
//
//
//    //[svprogressHUD show];
//    NSDictionary *dic = @{
//                          @"phone":telNumber,
//                          @"password":self.passwordField.text,
//                          };
//    MioPostRequest *request = [[MioPostRequest alloc] initWithRequestUrl:api_passwordLogin argument:dic];
//
//
//    [request success:^(NSDictionary *result) {
//        NSDictionary *data = [result objectForKey:@"data"];
//        NSString * token = [data objectForKey:@"access_token"];
//        MioUserInfo *user = [MioUserInfo mj_objectWithKeyValues:[data objectForKey:@"user"]];
//        [userdefault setObject:token forKey:@"token"];
//        [userdefault setObject:user.user_id forKey:@"user_id"];
//        [userdefault setObject:user.nickname forKey:@"nickname"];
//        [userdefault setObject:user.avatar forKey:@"avatar"];
//        [userdefault setObject:[[data objectForKey:@"shop"] objectForKey:@"shop_status"] forKey:@"shop_status"];
//        [userdefault synchronize];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
//
//
//        if (user.gender == 2) {
//
//        }else{
//            [self dismissViewControllerAnimated:YES completion:^{
//
//            }];
//        }
//
//
//    } failure:^(NSString *errorInfo) {
//        //[svprogressHUD showErrorWithStatus:errorInfo ];
//
//    }];
//}
//
//
//
//-(void)xieyi{
//    MioUserAgreementVC *vc = [[MioUserAgreementVC alloc] init];
//    vc.url = @"https://duoduo.apphw.com/policy.html";
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//-(void)agreeBtnClick:(UIButton *)btn{
//    btn.selected = !btn.selected;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//    return [UITextField inputTextField:textField
//         shouldChangeCharactersInRange:range
//                     replacementString:string
//                        blankLocations:@[@3,@8]
//                            limitCount:11];
//
//}
//
//@end
