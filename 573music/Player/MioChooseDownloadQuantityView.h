//
//  MioChooseDownloadQuantityView.h
//  573music
//
//  Created by Mimio on 2021/2/18.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol chooseDownloadDelegate <NSObject>
@optional
-(void)chooseDownloadQuailtyDone;
@end

@interface MioChooseDownloadQuantityView : UIView
@property (nonatomic, strong) NSArray<MioMusicModel *> *musicArr;
-(void)show;
@property (nonatomic,weak) id<chooseDownloadDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
