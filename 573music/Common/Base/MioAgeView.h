//
//  MioAgeView.h
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/12/23.
//  Copyright © 2019 Brance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioAgeView : UIView

+ (UIView *)creatAgeView:(CGRect)frame inView:(UIView *)view Age:(NSString *)age gender:(NSInteger)gender;
- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)view;
-(void)setAge:(NSString *)age gender:(NSInteger)gender;
@end

NS_ASSUME_NONNULL_END
