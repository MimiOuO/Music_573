//
//  MioMoreFuncView.h
//  573music
//
//  Created by Mimio on 2021/1/15.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MioLrcView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MioMoreFuncView : UIView
@property (nonatomic, strong) MioMusicModel *model;
@property (nonatomic, strong) UIViewController *fatherVC;
@property (nonatomic, strong) MioLrcView *lrcView;
-(void)show;

@end

NS_ASSUME_NONNULL_END
