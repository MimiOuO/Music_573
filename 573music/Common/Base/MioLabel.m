//
//  MioLabel.m
//  573music
//
//  Created by Mimio on 2020/11/23.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioLabel.h"

@implementation MioLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"changeSkin" object:nil];
    }
    return self;
}

-(void)refresh{
    self.textColor = mainColor;
}

@end
