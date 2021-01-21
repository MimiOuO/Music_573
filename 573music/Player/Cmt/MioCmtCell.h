//
//  MioCmtCell.h
//  573music
//
//  Created by Mimio on 2021/1/4.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioViewController.h"
#import "MioCmtModel.h"
NS_ASSUME_NONNULL_BEGIN
@class MioCmtCell;
typedef void (^cmtBlock) (MioCmtCell *);
typedef void (^replyBlock) (MioCmtCell *);
typedef void (^likeBlock) (MioCmtCell *);
@interface MioCmtCell : UITableViewCell
@property (nonatomic, strong) MioCmtModel *cmtModel;
@property (nonatomic, copy) cmtBlock cmtBlock;
@property (nonatomic, copy) replyBlock replyBlock;
@property (nonatomic, copy) likeBlock likeBlock;
@end

NS_ASSUME_NONNULL_END
