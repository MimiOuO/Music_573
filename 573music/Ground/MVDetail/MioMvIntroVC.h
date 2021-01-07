//
//  MioCourseIntroVC.h
//  jgsschool
//
//  Created by Mimio on 2020/9/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioViewController.h"
#import "MioMvModel.h"
NS_ASSUME_NONNULL_BEGIN


@protocol ChangeCollectionDelegate <NSObject>
@optional
- (void)changeCollection:(int)index;
@end

@interface MioMvIntroVC : MioViewController
@property (nonatomic, strong) MioMvModel *mv;
@property (nonatomic, weak)id <ChangeCollectionDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
