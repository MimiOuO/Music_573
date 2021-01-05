//
//  MioCmtModel.m
//  573music
//
//  Created by Mimio on 2021/1/4.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioCmtModel.h"

@implementation MioCmtModel

//- (void)setIsBendi:(NSString *)isBendi{
//    _isBendi = isBendi;
//}

- (NSString *)isBendi{
    if (Equals(_isBendi, @"1") ) {
        return @"1";
    }else{
        return @"0";
    }
}

@end
