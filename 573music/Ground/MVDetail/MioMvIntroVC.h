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


@protocol ChangeMVDelegate <NSObject>
@optional
- (void)changeMV:(NSString *)mvId;
@end

@interface MioMvIntroVC : MioViewController
@property (nonatomic, strong) MioMvModel *mv;
@property (nonatomic, strong) NSArray<MioMvModel *> *relatedMVArr;
@property (nonatomic, weak)id <ChangeMVDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
