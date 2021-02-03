//
//  MioChooseFavoriteTagView.h
//  573music
//
//  Created by Mimio on 2021/2/3.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol favoriteDelegate <NSObject>
@optional
- (void)chooseFavorite:(NSArray *)tagArr;
@end

@interface MioChooseFavoriteTagView : UIView
@property(nonatomic, weak)id <favoriteDelegate>delegate;
-(void)showFavoriteTagViewWithArr:(NSArray *)oldArr;
@end

NS_ASSUME_NONNULL_END
