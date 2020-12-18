//
//  ZMNavView.m
//
//
//  Created by Brance on 17/11/24.
//  Copyright © 2016年 Brance. All rights reserved.
//

#import "MioNavView.h"

@interface MioNavView ()

@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation MioNavView

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor = appWhiteColor;

        MioImageView *bgimg = [MioImageView creatImgView:frame(0, 0, KSW, NavH) inView:_mainView skin:SkinName image:@"icon_bai.jpg" radius:0];
        
        [self addSubview:_mainView];
		_mainView.frame = CGRectMake(0, 0, KSW, NavH);
        
        [_mainView.superview layoutIfNeeded];
    }
    return _mainView;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, StatusH, 56, 44)];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftButton.adjustsImageWhenHighlighted = NO;
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftButton setTitleColor:appBlackColor forState:UIControlStateNormal];
        [self.mainView addSubview:_leftButton];
        [_leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(UIButton *)centerButton{
    if (!_centerButton) {
        //中间按钮
		UIButton * centerButton = [[UIButton alloc] initWithFrame:CGRectMake(40, self.leftButton.top, KSW - 38 * 2, self.leftButton.height)];
        centerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [centerButton setTitleColor:appBlackColor forState:UIControlStateNormal];
        centerButton.adjustsImageWhenHighlighted = NO;
        [self.mainView addSubview:centerButton];
        self.centerButton = centerButton;
        [_centerButton addTarget:self action:@selector(clickCenterButton) forControlEvents:UIControlEventTouchUpInside];
        [self.centerButton.superview layoutIfNeeded];
        
    }
    return _centerButton;
}

-(UIButton *)rightButton{
	if (!_rightButton) {
		//右边按钮
		UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(KSW - 56, StatusH, 56, 44)];
		rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        rightButton.adjustsImageWhenHighlighted = NO;
		[rightButton setTitleColor:appBlackColor forState:UIControlStateNormal];
		[self.mainView addSubview:rightButton];
		self.rightButton = rightButton;
		[_rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];

		[self.rightButton.superview layoutIfNeeded];
	}
	return _rightButton;
}



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = appWhiteColor;
        [self setupUI];
    }
    return self;
}

/**
 *  UI 界面
 */
- (void)setupUI{
    
    [self lineLabel];
}

- (void)setShowBottomLabel:(BOOL)showBottomLabel{
    self.lineLabel.hidden = !showBottomLabel;
}

#pragma mark - private
- (void)clickLeftButton{

    if (self.leftButtonBlock) {
        self.leftButtonBlock();
    }
	[self.viewController.navigationController popViewControllerAnimated:YES];
}

- (void)clickCenterButton{
    if (self.cenTerButtonBlock) {
        self.cenTerButtonBlock();
    }
}

- (void)clickRightButton{
	
	if (self.rightButtonBlock) {
		self.rightButtonBlock();
	}
}

@end
