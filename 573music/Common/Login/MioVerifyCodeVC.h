//
//  MioVerifyCodeVC.h
//  orrilan
//
//  Created by Mimio on 2019/8/16.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MioVerifyCodeVC : MioViewController
@property (nonatomic,copy) NSString * phoneNumber;
@property (nonatomic,copy) NSString * verification_key;
@property (nonatomic, strong) NSString *wx;
@end

NS_ASSUME_NONNULL_END
