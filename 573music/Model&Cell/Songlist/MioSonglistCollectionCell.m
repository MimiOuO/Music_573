//
//  MioSonglistCollectionCell.m
//  573music
//
//  Created by Mimio on 2020/12/21.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSonglistCollectionCell.h"

@interface MioSonglistCollectionCell()

@end

@implementation MioSonglistCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = appClearColor;
        NSLog(@"%f",self.contentView.width);
    }
    return self;
}

- (void)setModel:(MioSongListModel *)model{

}
@end
