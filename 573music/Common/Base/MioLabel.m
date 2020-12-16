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
        RecieveChangeSkin;
    }
    return self;
}

-(void)changeSkin{
    self.textColor = mainColor;
}

@end
