//
//  MioBoundPhoneVC.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/10/28.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioBoundPhoneVC.h"
#import "UITextField+NumberFormat.h"
#import "MioVerifyCodeVC.h"
@interface MioBoundPhoneVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *userNameField;
@end

@implementation MioBoundPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = appWhiteColor;
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavH, KSW, KSH - NavH)];
    [self.view addSubview:scroll];
    UILabel *titleLabel = [UILabel creatLabel:frame(23,  94, 200, 25) inView:scroll text:@"请先绑定手机号" color:subColor size:18];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(23, titleLabel.bottom + 54 ,  KSW - 46, 17)];
    self.userNameField.delegate = self;
    self.userNameField.font = [UIFont systemFontOfSize:16];
    self.userNameField.placeholder = @"请输入手机号";
    self.userNameField.textColor = subColor;
    
    [self.userNameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameField.keyboardType = UIKeyboardTypeNumberPad;
    [scroll addSubview:self.userNameField];
    
    UIView *split1 = [UIView creatView:frame(23, self.userNameField.bottom + Mar, KSW - 46, 0.5) inView:scroll bgColor:botLineColor];
    
    UIButton *btn = [UIButton creatBtn:frame(23, self.userNameField.bottom + 28, KSW - 46, 40) inView:scroll bgImage:@"denglu-anniu" WithTag:1 target:self action:@selector(handleLoginEvent:)];
    UILabel *btnlabel = [UILabel creatLabel:frame(23, self.userNameField.bottom + 28, KSW - 46, 40) inView:scroll text:@"获取验证码" color:appWhiteColor size:16];
    btnlabel.textAlignment = NSTextAlignmentCenter;
}

//禁用滑动返回
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return [UITextField inputTextField:textField
         shouldChangeCharactersInRange:range
                     replacementString:string
                        blankLocations:@[@3,@8]
                            limitCount:11];

}

- (void)handleLoginEvent:(id)sender {

    NSString *telNumber = [self.userNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (telNumber.length != 11) {
        //[svprogressHUD showErrorWithStatus:@"请输入正确的手机号！"];
        return;
    }

    
    
    //[svprogressHUD show];
    NSDictionary *dic = @{
                          @"phone":telNumber,
                          };
    MioPostRequest *request = [[MioPostRequest alloc] initWithRequestUrl:api_getVerifyCode argument:dic];
    
    [request success:^(NSDictionary *result) {
        NSDictionary *data = [result objectForKey:@"data"];
        
        //[svprogressHUD dismiss];
        MioVerifyCodeVC *vc = [[MioVerifyCodeVC alloc] init];
        vc.phoneNumber = self.userNameField.text;
        vc.verification_key = [data objectForKey:@"key"];
        vc.wx = @"wx";
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSString *errorInfo) {
        //[svprogressHUD showErrorWithStatus:errorInfo ];
        
    }];
}

@end
