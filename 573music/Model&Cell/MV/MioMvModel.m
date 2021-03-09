//
//  MioMVModel.m
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMvModel.h"

@implementation MioMvModel

- (void)setSavetype:(NSString *)savetype{
    _savetype = savetype;
}

- (NSString *)hits_all{
    if ([_hits_all intValue] > 10000) {
        return [NSString stringWithFormat:@"%.1fw",[_hits_all intValue]/10000.0];
    }else if ([_hits_all intValue] > 1000) {
        return [NSString stringWithFormat:@"%.1fk",[_hits_all intValue]/1000.0];
    }else{
        return _hits_all;
    }
}

@end
