//
//  STPickerDouble.h
//  orrilan
//
//  Created by Mimio on 2019/8/29.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class STPickerDouble;
@protocol  STPickerDoubleDelegate<NSObject>
- (void)pickerSingle:(STPickerDouble *)pickerSingle selectedTitle:(NSArray *)selectedTitleArr selectIndex:(NSString *)index;
@end

@interface STPickerDouble : STPickerView

/** 1.设置字符串数据数组 */
@property (nonatomic, strong)NSMutableArray<NSString *> *arrayData;
/** 2.设置单位标题 */
@property (nonatomic, strong)NSString *titleUnit;
/** 3.中间选择框的高度，default is 44*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
/** 4.中间选择框的宽度，default is 32*/
@property (nonatomic, assign)CGFloat widthPickerComponent;
@property(nonatomic, weak)id <STPickerDoubleDelegate>delegate;

@end
NS_ASSUME_NONNULL_END
