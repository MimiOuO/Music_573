
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
#import "MioChooseFavoriteTagView.h"

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
    if (_verifyTF.text.length < 8){
        [UIWindow showInfo:@"请输入不少于8位密码"];
        return;
    }

    NSDictionary *dic = @{
                          @"phone":telNumber,
                          @"password":self.verifyTF.text,
                          };
    MioPostRequest *request = [[MioPostRequest alloc] initWithRequestUrl:api_passwordLogin argument:dic];
    
    [request success:^(NSDictionary *result) {
        NSDictionary *data = [result objectForKey:@"data"];
        [UIWindow showSuccess:@"登录成功"];
        
        NSString * token = [data objectForKey:@"access_token"];
        MioUserInfo *user = [MioUserInfo mj_objectWithKeyValues:[data objectForKey:@"user"]];
        [userdefault setObject:token forKey:@"token"];
        [userdefault setObject:user.user_id forKey:@"user_id"];
        [userdefault setObject:user.nickname forKey:@"nickname"];
        [userdefault setObject:user.avatar forKey:@"avatar"];
        [userdefault setObject:user.phone forKey:@"phone"];
        [userdefault synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
            //暂时先不弹喜好
//            if (user.favorite_tags.count == 0) {
//                MioChooseFavoriteTagView *view = [MioChooseFavoriteTagView new];
//                [view showFavoriteTagViewWithArr:user.favorite_tags];
//            }
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
