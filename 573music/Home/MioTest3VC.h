//
//  MioTest3VC.h
//  573music
//
//  Created by Mimio on 2020/11/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AudioPlayerViewDelegate<NSObject>
@end

@interface MioTest3VC : MioViewController

@property (nonatomic, strong) STKAudioPlayer* audioPlayer;
@property (nonatomic, weak) id<AudioPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
