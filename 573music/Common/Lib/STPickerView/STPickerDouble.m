//
//  STPickerDouble.m
//  orrilan
//
//  Created by Mimio on 2019/8/29.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "STPickerDouble.h"

@interface STPickerDouble()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.选中的字符串 */
@property (nonatomic, strong, nullable)NSString *selectedTitle;
@property (nonatomic, strong) NSMutableArray *selectTitleArr;
@property (nonatomic, strong) NSString *selectIndex;
@end

@implementation STPickerDouble

#pragma mark - --- init 视图初始化 ---
- (void)setupUI
{
    [super setupUI];
    
    _titleUnit = @"";
    _arrayData = @[].mutableCopy;
    _heightPickerComponent = 44;
    _widthPickerComponent = 50;
    _selectTitleArr = @[@"00:00",@"00:00"].mutableCopy;
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        return self.arrayData.count;
    }else {
        return self.arrayData.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    if (component == 0) {
        return (self.st_width-self.widthPickerComponent)/2;
    }else {
        return (self.st_width-self.widthPickerComponent)/2;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        [self.selectTitleArr replaceObjectAtIndex:0 withObject:[(NSDictionary *)(self.arrayData[row]) objectForKey:@"category_name"]];
    }
    if (component == 1) {
        [self.selectTitleArr replaceObjectAtIndex:1 withObject:self.arrayData[row]];
    }
    
    self.selectIndex = [NSString stringWithFormat:@"%ld",(long)row + 1];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    NSDictionary *dic = (NSDictionary *)(self.arrayData[row]);
    if (component == 0) {
        UILabel *label = [[UILabel alloc]init];
        [label setText:[dic objectForKey:@"category_name"]];
        [label setTextAlignment:NSTextAlignmentCenter];
        return label;
    }
    else {
        UILabel *label = [[UILabel alloc]init];
//        [label setText:(NSArray *)([dic objectForKey:@"item"])];
        NSDictionary *item = (NSArray *)([dic objectForKey:@"items"])[row];
        label.text = [item objectForKey:@"category_name"];
        [label setTextAlignment:NSTextAlignmentCenter];
        return label;
    }
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if ([self.delegate respondsToSelector:@selector(pickerSingle:selectedTitle:selectIndex:)]) {
        [self.delegate pickerSingle:self selectedTitle:self.selectTitleArr selectIndex:self.selectIndex];
    }
    
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- setters 属性 ---

- (void)setArrayData:(NSMutableArray<NSString *> *)arrayData
{
    _arrayData = arrayData;
    _selectedTitle = arrayData.firstObject;
    _selectIndex = @"1";
    [self.pickerView reloadAllComponents];
}

- (void)setTitleUnit:(NSString *)titleUnit
{
    _titleUnit = titleUnit;
    [self.pickerView reloadAllComponents];
}

#pragma mark - --- getters 属性 ---
@end
