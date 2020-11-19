
//
//  MioPasswordLoginVC.m
//  orrilan
//
//  Created by Mimio on 2019/8/19.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioPasswordLoginVC.h"
#import <SVGA.h>
#import "MioUserAgreementVC.h"
#import "UITextField+NumberFormat.h"
@interface MioPasswordLoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *agreeBtn;
@end

@implementation MioPasswordLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    self.navView.split.hidden = YES;    
    self.view.backgroundColor =appWhiteColor;
    [self creatUI];
    
}

-(void)creatUI{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavH, KSW, KSH - NavH)];
    [self.view addSubview:scroll];
    


    UILabel *titleLabel = [UILabel creatLabel:frame(19, IPHONE_X?60:30, 200, 30) inView:scroll text:@"密码登录" color:subColor size:30];
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    
    //======================================================================//
    //                               用户名
    //======================================================================//
    UILabel *accoutLab = [UILabel creatLabel:frame(19, titleLabel.bottom + 60, 35, 16) inView:scroll text:@"账号" color:subColor size:16 alignment:NSTextAlignmentLeft];
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(80, titleLabel.bottom + 59 ,  KSW - 46, 17)];
    self.userNameField.delegate = self;
    self.userNameField.font = [UIFont systemFontOfSize:16];
    self.userNameField.placeholder = @"请输入手机号";
    self.userNameField.textColor = subColor;
    
    [self.userNameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameField.keyboardType = UIKeyboardTypeNumberPad;
    [scroll addSubview:self.userNameField];
    
    UIView *split1 = [UIView creatView:frame(23, self.userNameField.bottom + 21, KSW - 46, 0.5) inView:scroll bgColor:botLineColor];
    
    //======================================================================//
    //                               密码
    //======================================================================//
    UILabel *paswLab = [UILabel creatLabel:frame(19, split1.bottom + 30, 35, 16) inView:scroll text:@"密码" color:subColor size:16 alignment:NSTextAlignmentLeft];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(80, split1.bottom + 30 ,  KSW - 46, 17)];
    self.passwordField.font = [UIFont systemFontOfSize:16];
    self.passwordField.placeholder = @"请输入登录密码";
    self.passwordField.textColor = subColor;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scroll addSubview:self.passwordField];
    
    UIView *split2 = [UIView creatView:frame(23, self.passwordField.bottom + 21, KSW - 46, 0.5) inView:scroll bgColor:botLineColor];
    
   SVGAPlayer *logoPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, KSH -  KSW*0.972 - NavH, KSW, KSW*0.972)];
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
    
    UIButton *btn = [UIButton creatBtn:frame(19, split2.bottom + 40, KSW - 38, 44) inView:scroll bgImage:@"button" WithTag:1 target:self action:@selector(handleLoginEvent:)];
    UILabel *btnlabel = [UILabel creatLabel:frame(19, split2.bottom + 40, KSW - 38, 44) inView:scroll text:@"登录" color:appWhiteColor size:14];
    btnlabel.textAlignment = NSTextAlignmentCenter;
    


}

- (void)handleLoginEvent:(id)sender {
    
    NSString *telNumber = [self.userNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (telNumber.length != 11) {
        //[svprogressHUD showErrorWithStatus:@"请输入正确的手机号！"];
        return;
    }
    
    
    if (self.passwordField.text.length < 6) {
        //[svprogressHUD showErrorWithStatus:@"请输入正确密码！"];
        return;
    }

    
    //[svprogressHUD show];
    NSDictionary *dic = @{
                          @"phone":telNumber,
                          @"password":self.passwordField.text,
                          };
    MioPostRequest *request = [[MioPostRequest alloc] initWithRequestUrl:api_passwordLogin argument:dic];
    
    
    [request success:^(NSDictionary *result) {
        NSDictionary *data = [result objectForKey:@"data"];
        NSString * token = [data objectForKey:@"access_token"];
        MioUserInfo *user = [MioUserInfo mj_objectWithKeyValues:[data objectForKey:@"user"]];
        [userdefault setObject:token forKey:@"token"];
        [userdefault setObject:user.user_id forKey:@"user_id"];
        [userdefault setObject:user.nickname forKey:@"nickname"];
        [userdefault setObject:user.avatar forKey:@"avatar"];
        [userdefault setObject:[[data objectForKey:@"shop"] objectForKey:@"shop_status"] forKey:@"shop_status"];
        [userdefault synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];

        
        if (user.gender == 2) {

        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        

    } failure:^(NSString *errorInfo) {
        //[svprogressHUD showErrorWithStatus:errorInfo ];
        
    }];
}



-(void)xieyi{
    MioUserAgreementVC *vc = [[MioUserAgreementVC alloc] init];
    vc.url = @"https://duoduo.apphw.com/policy.html";
    [self.navigationController pushViewController:vc animated:YES];
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
