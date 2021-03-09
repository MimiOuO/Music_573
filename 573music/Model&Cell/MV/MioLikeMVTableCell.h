//
//  MioLikeMVTableCell.h
//  573music
//
//  Created by Mimio on 2021/3/9.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MioMvModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MioLikeMVTableCell : UITableViewCell
@property (nonatomic, strong) MioMvModel *model;
@end

NS_ASSUME_NONNULL_END
