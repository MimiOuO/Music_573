//
//  MioChooseQuantityView.h
//  573music
//
//  Created by Mimio on 2021/1/15.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChangeQuailtyDelegate <NSObject>
@optional
-(void)changeQuailty;
@end

@interface MioChooseQuantityView : UIView
@property (nonatomic, strong) MioMusicModel *model;
-(void)show;
@property (nonatomic,weak) id<ChangeQuailtyDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
