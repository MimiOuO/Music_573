//
//  MioMusicModel.h
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioMusicModel : NSObject

@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * path;
@property (nonatomic,copy) NSString * audiourl;


@end

NS_ASSUME_NONNULL_END
