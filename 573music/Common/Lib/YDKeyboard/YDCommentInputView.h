//
//  YDCommentInputView.h
//  yxtk
//
//  Created by Aren on 16/3/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDCommentInputView;

@protocol YDCommentInputViewDelegate<NSObject>
@optional
- (void)commentInputView:(YDCommentInputView *)anInputView onSendText:(NSString *)aText;
- (void)didInputAtFromCommentInputView:(YDCommentInputView *)anInputView;
- (void)didHideCommentInputView:(YDCommentInputView *)anInputView;
@end

@interface YDCommentInputView : UIView
<UITextFieldDelegate>
@property (weak, nonatomic) id<YDCommentInputViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *emjoyBtn;
@property (weak, nonatomic) IBOutlet UITextField *commentInputTextField;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *inputBar;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputviewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputviewBottomConstraint;
@property (assign, nonatomic) CGFloat inputBottomViewHeight;
@property (strong, nonatomic) NSArray *emojiDataSource;
- (void)showInputView;
- (void)hideInputView;

//自定义字段
@property (nonatomic,copy) NSString * reply_user_id;
@property (nonatomic,copy) NSString * pid;
@end
