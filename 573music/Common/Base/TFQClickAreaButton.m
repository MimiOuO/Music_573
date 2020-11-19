//
//  TFQClickAreaButton.m
//  TFQTabelView
//
//  Created by 王立志 on 2019/9/25.
//  Copyright © 2019 Thread_Fight_Queue. All rights reserved.
//

#import "TFQClickAreaButton.h"

@implementation TFQClickAreaButton

- (instancetype)init{
    if(self == [super init]){
        self.backgroundColor = [UIColor redColor];
        self.alpha = 0.5;
    }
    return self;
}

//所有点击到视图上的事件都扔给底部的button响应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return [self.undersideBtn hitTest:point withEvent:event];
}

@end
