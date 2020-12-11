//
//  SliderView.h
//  QQMusic
//
//  Created by iMac on 16/4/14.
//  Copyright © 2016年 suger. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SliderViewDelegate <NSObject>
@optional

@end

@interface SliderView : UIView
@property (nonatomic, weak) id <SliderViewDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval time;

@end
