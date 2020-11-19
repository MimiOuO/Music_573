//
//  STPickTime.m
//  orrilan
//
//  Created by Mimio on 2019/8/29.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "STPickTime.h"
#import "NSCalendar+STPicker.h"

typedef NS_OPTIONS(NSUInteger, STCalendarUnit) {
    STCalendarUnitYear  = (1UL << 0),
    STCalendarUnitMonth = (1UL << 1),
    STCalendarUnitDay   = (1UL << 2),
    STCalendarUnitHour  = (1UL << 3),
    STCalendarUnitMinute= (1UL << 4),
};

@interface STPickerTime()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.年 */
@property (nonatomic, assign)NSInteger year;
/** 2.月 */
@property (nonatomic, assign)NSInteger month;
/** 3.日 */
@property (nonatomic, assign)NSInteger day;
@property (nonatomic,copy) NSString * whichDay;
@property (nonatomic,copy) NSString * showString;
@end

@implementation STPickerTime

#pragma mark - --- init 视图初始化 ---

- (void)setupUI {
    
    self.title = @"请选择服务时间";
    _yearLeast = 1900;
    _yearSum   = 200;
    _heightPickerComponent = 28;
    self.contentView.backgroundColor = appBgColor;
    self.pickerView.backgroundColor = appBgColor;
    _year  = [NSCalendar currentYear];
    _month = [NSCalendar currentHour];
    _day   = 0;
    _whichDay = @"今天";
    _showString = @"";
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 3;
            break;
        case 1:
            return 24;
            break;
        default:
            return 4;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSArray *component1Arr = @[@"今天",@"明天",@"后天"];

    NSArray *component3Arr = @[@"00",@"15",@"30",@"45"];
    switch (component) {
        case 0:{
            _whichDay = component1Arr[row];
//            self.year = component1Arr[row];
//            [pickerView reloadComponent:2];
        }break;
        case 1:{
            self.month = row;
//            [pickerView reloadComponent:2];
        }break;
        case 2:{
            self.day = [component3Arr[row] integerValue];
        }break;
    }
    
//    if ([self.delegate respondsToSelector:@selector(pickerDate:year:month:day:)]) {
//        NSInteger day = [self.pickerView selectedRowInComponent:2] + 1;
//
//        [self.delegate pickerTime:self year:_year month:_month day:day];
//    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    //设置分割线的颜色
//    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.frame.size.height <=1) {
//            obj.backgroundColor = self.borderButtonColor;
//        }
//    }];
    
    NSArray *component1Arr = @[@"今天",@"明天",@"后天"];
    NSArray *component3Arr = @[@"00",@"15",@"30",@"45"];
    NSString *text;
    if (component == 0) {
        text =  component1Arr[row];
    }else if (component == 1){
        text =  [NSString stringWithFormat:@"%zd", row];
    }else{
        text = component3Arr[row];
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = appBlackColor;
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if ([self.delegate respondsToSelector:@selector(pickerTime:time:showString:)]) {
        NSString *time = @"";
        NSString *temp = [NSString stringWithFormat:@"%@ %02ld:%02ld:00",[self getCurrentTime],self.month,self.day];
        _showString = [NSString stringWithFormat:@"%@ %02ld:%02ld",_whichDay,self.month,self.day];
        if ([_whichDay isEqualToString:@"今天"]) {
//            NSDate *date =[self dateFromString:temp];
            time = temp;
        }
        if ([_whichDay isEqualToString:@"明天"]) {
            NSDate *date =[self dateFromString:temp];
            time = [self GetTomorrowDay:date];
        }
        if ([_whichDay isEqualToString:@"后天"]) {
            NSDate *date =[self dateFromString:temp];
            time = [self GetHoutianDay:date];
        }
        
        
        [self.delegate pickerTime:self time:time showString:_showString];
    }
    
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- setters 属性 ---

- (void)setYearLeast:(NSInteger)yearLeast
{
    if (yearLeast<=0) {
        return;
    }
    
    _yearLeast = yearLeast;
    [self.pickerView selectRow:(0) inComponent:0 animated:NO];
    [self.pickerView selectRow:(_month ) inComponent:1 animated:NO];
    [self.pickerView selectRow:(0) inComponent:2 animated:NO];
    [self.pickerView reloadAllComponents];
}

- (void)setYearSum:(NSInteger)yearSum{
    if (yearSum<=0) {
        return;
    }
    
    _yearSum = yearSum;
    [self.pickerView reloadAllComponents];
}

- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//将字符串转成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
//传入今天的时间，返回今天的时间
- (NSString *)GetTodayDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:aDate];
    [components setDay:([components day])];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateday stringFromDate:beginningOfWeek];
}
//传入今天的时间，返回明天的时间
- (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateday stringFromDate:beginningOfWeek];
}

//传入今天的时间，返回后天的时间
- (NSString *)GetHoutianDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:aDate];
    [components setDay:([components day]+2)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateday stringFromDate:beginningOfWeek];
}
#pragma mark - --- getters 属性 ---


@end

