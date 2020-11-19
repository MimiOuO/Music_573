//
//  STPickTime.h
//  orrilan
//
//  Created by Mimio on 2019/8/29.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class STPickerTime;
@protocol  STPickerTimeDelegate<NSObject>
- (void)pickerTime:(STPickerTime *)pickerTime time:(NSString *)time showString:(NSString *)showString;

@end
@interface STPickerTime : STPickerView

/** 1.最小的年份，default is 1900 */
@property (nonatomic, assign)NSInteger yearLeast;
/** 2.显示年份数量，default is 200 */
@property (nonatomic, assign)NSInteger yearSum;
/** 3.中间选择框的高度，default is 28*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <STPickerTimeDelegate>delegate ;

@end
NS_ASSUME_NONNULL_END
