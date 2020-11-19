//
//  MioModiPassWordViewController.m
//  shunyishangjia
//
//  Created by Mimio on 2019/6/3.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioModiPassWordVC.h"

@interface MioModiPassWordVC ()
@property (nonatomic, strong) UITextField *oldTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *repeatTextField;
@end

@implementation MioModiPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"设置新密码" forState:UIControlStateNormal];
    WEAKSELF;
    [self.navView.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    self.navView.rightButtonBlock = ^{
        [weakSelf xiugai];
    };
    
    self.view.backgroundColor = appBgColor;
    [self creatUI];
}

-(void)creatUI{
    UILabel *oldLabel = [UILabel creatLabel:frame(Mar, Mar + NavH, 100, 14) inView:self.view text:@"原密码" color:subColor size:14];

    _oldTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, Mar + oldLabel.bottom, KSW, 44)];
    _oldTextField.backgroundColor = appWhiteColor;
    _oldTextField.font = [UIFont systemFontOfSize:14];
    _oldTextField.secureTextEntry = YES;
    _oldTextField.placeholder = @"输入原密码";
    _oldTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,15,44)];
    _oldTextField.leftViewMode =UITextFieldViewModeAlways;

    [self.view addSubview:_oldTextField];
    
    if (!_isHavePassword) {
        oldLabel.frame = frame(Mar,  NavH, 100, 0);
        _oldTextField.frame = frame(Mar,  NavH, 100, 0);
    }
    
    
    UILabel *passwordLabel = [UILabel creatLabel:frame(Mar, Mar + _oldTextField.bottom, 100, 14) inView:self.view text:@"新密码" color:subColor size:14];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, Mar + passwordLabel.bottom, KSW, 44)];
    _passwordTextField.backgroundColor = appWhiteColor;
    _passwordTextField.font = [UIFont systemFontOfSize:14];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"输入新的密码";
    _passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,15,44)];
    _passwordTextField.leftViewMode =UITextFieldViewModeAlways;
    [self.view addSubview:_passwordTextField];
    
    UIView *split = [UIView creatView:frame(Mar, _passwordTextField.bottom - 0.5, KSW - Mar, 0.5) inView:self.view bgColor:botLineColor];
    
    _repeatTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,_passwordTextField.bottom, KSW, 44)];
    _repeatTextField.backgroundColor = appWhiteColor;
    _repeatTextField.font = [UIFont systemFontOfSize:14];
    _repeatTextField.secureTextEntry = YES;
    _repeatTextField.placeholder = @"再次输入密码";
    _repeatTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,15,44)];
    _repeatTextField.leftViewMode =UITextFieldViewModeAlways;
    [self.view addSubview:_repeatTextField];
    
    UILabel *tipLab = [UILabel creatLabel:frame(Mar, _repeatTextField.bottom + Mar, 100, 12) inView:self.view text:@"6~20位密码" color:grayTextColor size:12];


}

-(void)xiugai{
   if (_isHavePassword) {//有原密码
       if (_oldTextField.text.length<6 || _oldTextField.text.length>20) {
           //[svprogressHUD showErrorWithStatus:@"请输入正确的原密码"];
           return;
       }
//       if (_oldTextField.text.length != _passwordTextField.text.length) {
//           //[svprogressHUD showErrorWithStatus:@"新密码不能与原密码相同"];
//           return;
//       }
   }

    if (_passwordTextField.text.length<6 || _passwordTextField.text.length>20) {
        //[svprogressHUD showErrorWithStatus:@"请输入正确的新密码"];
        return;
    }
    if (_repeatTextField.text.length<6 || _repeatTextField.text.length>20) {
        //[svprogressHUD showErrorWithStatus:@"请再次输入密码"];
        return;
    }
    if (_passwordTextField.text.length != _repeatTextField.text.length) {
        //[svprogressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    NSDictionary *dic;
    if (_isHavePassword){
        dic = @{
              @"old_password":_oldTextField.text,
              @"password":_passwordTextField.text,
              @"repeat_password":_repeatTextField.text,
              };
    }else{
        dic = @{
              @"password":_passwordTextField.text,
              @"repeat_password":_repeatTextField.text,
              };
    }
    

    MioPutRequest *request = [[MioPutRequest alloc] initWithRequestUrl:api_base argument:dic];
    
    [request success:^(NSDictionary *result) {
        NSDictionary *data = [result objectForKey:@"data"];
        
        //[svprogressHUD showSuccessWithStatus:@"密码修改成功"];
    
        
    } failure:^(NSString *errorInfo) {
        //[svprogressHUD showErrorWithStatus:@"密码修改失败"];
        
    }];
    
}

@end
