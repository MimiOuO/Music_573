//
//  MioFeedBackVC.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/9/5.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioFeedBackVC.h"

@interface MioFeedBackVC ()<UITextViewDelegate>
//背景
@property(nonatomic,strong) UIView *noteTextBackgroudView;

//备注
@property(nonatomic,strong) UITextView *noteTextView;

//文字个数提示label
@property(nonatomic,strong) UILabel *textNumberLabel;

@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *postArr;
@end

@implementation MioFeedBackVC

- (void)viewDidLoad {
    WEAKSELF;
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"反馈" forState:UIControlStateNormal];
    [self.navView.rightButton  setTitle:@"提交" forState:UIControlStateNormal];
    [self.navView.rightButton setTitleColor:color_main forState:UIControlStateNormal];
    self.navView.rightButtonBlock = ^{
        [weakSelf submit];
    };
    
    
    UILabel *title1 = [UILabel creatLabel:frame(Mar, NavH + 24, 100, 16) inView:self.view text:@"请选择分类" color:color_text_one boldSize:16 alignment:NSTextAlignmentLeft];

    
    
    _dataArr = @[@"功能建议",@"内容建议",@"BUG反馈",@"其他"];
    
    for (int i = 0; i < _dataArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(Mar + (i % 3) * ((KSW - 20 - Mar2 )/3 +10), NavH + 40 +Mar + (i / 3) * 50, (KSW - 20 - Mar2)/3, 30)];
        ViewRadius(btn, 5);
        [btn setBackgroundColor:color_main forState:UIControlStateSelected];
        [btn setBackgroundColor:color_card forState:UIControlStateNormal];
        [btn setTitleColor:color_main forState:UIControlStateNormal];
        [btn setTitleColor:appWhiteColor forState:UIControlStateSelected];
        [btn setTitle:_dataArr[i]  forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 100;
//        NSNumber * nums = btn.tag;


        [self.view addSubview:btn];
    }

    UILabel *title2 = [UILabel creatLabel:frame(Mar, NavH + 152, 100, 16) inView:self.view text:@"反馈内容" color:color_text_one boldSize:16 alignment:NSTextAlignmentLeft];

    

    _noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.backgroundColor = color_card;
    ViewRadius(_noteTextBackgroudView, 8);
    
    //文本输入框
    _noteTextView = [[UITextView alloc]init];
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    
    [_noteTextView setTextColor:color_text_one];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont systemFontOfSize:14];
    _noteTextView.backgroundColor = appClearColor;

    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont systemFontOfSize:12];
    _textNumberLabel.textColor = color_text_two;
    _textNumberLabel.backgroundColor = appClearColor;
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",200];
    
    _noteTextBackgroudView.frame = CGRectMake(Mar, NavH + 176, KSW_Mar2 , 220);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(Mar + 12, NavH + 183 , KSW_Mar2 - 20, 176);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(Mar, _noteTextView.frame.origin.y + _noteTextView.frame.size.height +5, KSW_Mar2-10, 15);
    
    [self.view addSubview:_noteTextBackgroudView];
    [self.view addSubview:_noteTextView];
    [self.view addSubview:_textNumberLabel];
    
    _placeholder = [UILabel creatLabel:frame(22 + Mar, NavH + 188, KSW_Mar2 , 22) inView:self.view text:@"详细描述你的问题或建议，我们将及时跟进解决。" color:color_text_two size:14];
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.text.length>0) {
        _placeholder.hidden = YES;
    }else{
        _placeholder.hidden = NO;
    }
    
    NSLog(@"当前输入框文字个数:%ld",_noteTextView.text.length);
    //
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,200];
    if (_noteTextView.text.length > 200) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = color_text_two;
    }
//    [self textChanged];
    

}

-(void)dateClick:(UIButton *)btn{
    for (int i = 0; i < _dataArr.count; i++) {
        UIButton *allbtn = (UIButton *)[self.view viewWithTag:i + 100];
        allbtn.selected = NO;
    }
    [_postArr removeAllObjects];
    btn.selected = YES;
    [_postArr addObject:[NSNumber numberWithInteger:(btn.tag - 99)]];
}


-(void)submit{
    if (_noteTextView.text.length == 0) {
        return;
    }
    
    NSDictionary *dic = @{
                          @"content":_noteTextView.text,
                          };
    MioPostRequest *request = [[MioPostRequest alloc] initWithRequestUrl:api_base argument:dic];
    
    [request success:^(NSDictionary *result) {
        NSDictionary *data = [result objectForKey:@"data"];
        //[svprogressHUD showSuccessWithStatus:@"提交成功"];
        
    } failure:^(NSString *errorInfo) {
        
        
    }];
}

@end
