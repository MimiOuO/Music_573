//
//  MioChooseDefaultQuailtyView.h
//  573music
//
//  Created by Mimio on 2021/1/18.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol defaultQuailtyDelegate <NSObject>
@optional
-(void)changeDefaultQuailty;
@end

@interface MioChooseDefaultQuailtyView : UIView
-(void)show;
@property (nonatomic,weak) id<defaultQuailtyDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
