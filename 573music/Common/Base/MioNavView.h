//
//  ZMNavView.h
//  
//
//  Created by Brance on 17/11/24.
//  Copyright © 2019年 Mimio. All rights reserved.
//  自定义导航
@class MioImageView;

@interface MioNavView : UIView

@property (nonatomic, strong) UIView    *mainView;
@property (nonatomic, strong) MioImageView *bgImg;
@property (nonatomic, strong) UIView    *split;
@property (nonatomic, strong) UIButton  *leftButton;
@property (nonatomic, strong) UIButton  *leftTwoButton;
@property (nonatomic, strong) UIButton  *rightButton;
@property (nonatomic, strong) UIButton  *centerButton;
@property (nonatomic, strong) UILabel   *rightLabel;
@property (nonatomic, assign) BOOL      showBottomLabel;
/** 中间按钮文字 */
@property (nonatomic, strong) UILabel   *centerLabel;
//@property (nonatomic, strong) UIColor *navViewColor;


@property (nonatomic, copy) void (^ leftButtonBlock)();
@property (nonatomic, copy) void (^ cenTerButtonBlock)();
@property (nonatomic, copy) void (^ rightButtonBlock)();
- (void)setShowBottomLabel:(BOOL)showBottomLabel;
@end
