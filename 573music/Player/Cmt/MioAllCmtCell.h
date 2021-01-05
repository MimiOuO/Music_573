//
//  MioAllCmtCell.h
//  DuoDuoPeiwan
//
//  Created by Mimio on 2020/6/16.
//  Copyright © 2020 Brance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MioCmtModel.h"
NS_ASSUME_NONNULL_BEGIN
@class MioAllCmtCell;
typedef void (^cmtBlock) (MioAllCmtCell *);
typedef void (^replyBlock) (MioAllCmtCell *);
//typedef void (^avatarBlock) (MioAllCmtCell *);
typedef void (^tapReplyPraiseBlock) (MioAllCmtCell *);
@interface MioAllCmtCell : UITableViewCell
@property (nonatomic, strong) MioCmtModel *replyModel;
@property (nonatomic, copy) cmtBlock tapReplyPraiseBlock;
@property (nonatomic, copy) cmtBlock cmtBlock;
@property (nonatomic, copy) replyBlock replyBlock;
//@property (nonatomic, copy) avatarBlock avatarBlock;
@end

NS_ASSUME_NONNULL_END
