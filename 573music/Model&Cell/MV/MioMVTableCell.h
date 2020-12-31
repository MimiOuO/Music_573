//
//  MioMVTableCell.h
//  573music
//
//  Created by Mimio on 2020/12/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MioMvModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MioMVTableCell : UITableViewCell
@property (nonatomic, strong) MioMvModel *model;
@end

NS_ASSUME_NONNULL_END
