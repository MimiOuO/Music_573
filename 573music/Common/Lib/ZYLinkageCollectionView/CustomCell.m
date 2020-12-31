//
//  CustomCell.m
//  ZYLinkageDemo
//
//  Created by 雨张 on 2018/5/29.
//  Copyright © 2018年 雨张. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _textLabel = [UILabel new];
        _textLabel.font = Font(12);
        _textLabel.textColor = color_text_one;
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_textLabel];
        self.backgroundColor = color_sup_one;
        ViewRadius(self, 16);
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height);
}
@end
