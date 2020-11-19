//
//  MioEmpty.m
//  orrilan
//
//  Created by Mimio on 2019/8/9.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioEmpty.h"

@implementation MioEmpty


+ (instancetype)noDataEmpty{
    MioEmpty *emptyView =[MioEmpty emptyViewWithImageStr:@"empty" titleStr:@"" detailStr:@""];
    emptyView.contentViewOffset = -50;
    emptyView.titleLabFont = [UIFont systemFontOfSize:12.f];
    emptyView.titleLabTextColor = rgb(138, 206, 255);
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
    return emptyView;
}

+ (instancetype)noNetworkEmptyWithTarget:(id)target action:(SEL)action{
    
    MioEmpty *diy = [MioEmpty emptyActionViewWithImageStr:@"noData"
                                                     titleStr:@"暂无数据"
                                                    detailStr:@""
                                                  btnTitleStr:@"重新加载"
                                                       target:target
                                                       action:action];
    diy.autoShowEmptyView = NO;
    
    diy.imageSize = CGSizeMake(150, 150);
    
    return diy;
}

+ (instancetype)customEmptyViewWithTarget:(id)target action:(SEL)action{
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"暂无数据，请稍后再试！";
    [customView addSubview:titleLab];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"重试" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(120, 50, 80, 30)];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"加载" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [button2 addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button2];
    
    MioEmpty *diy = [MioEmpty emptyViewWithCustomView:customView];
    return diy;
}

- (void)prepare{
    [super prepare];
    
    self.subViewMargin = 20.f;
    
    self.titleLabFont = [UIFont systemFontOfSize:25];
    self.titleLabTextColor = rgb(90, 180, 160);
    
    self.detailLabFont = [UIFont systemFontOfSize:17];
    self.detailLabTextColor = rgb(180, 120, 90);
    self.detailLabMaxLines = 5;
    
    self.actionBtnBackGroundColor = rgb(90, 180, 160);
    self.actionBtnTitleColor = [UIColor whiteColor];
}

@end

