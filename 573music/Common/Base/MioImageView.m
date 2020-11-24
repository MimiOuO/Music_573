//
//  MioImageView.m
//  573music
//
//  Created by Mimio on 2020/11/23.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioImageView.h"

@implementation MioImageView

+(MioImageView *)creatImgView:(CGRect)frame inView:(UIView *)view skin:(NSString *)skin image:(NSString *)image radius:(CGFloat)radius{
    MioImageView *imgView = [[MioImageView alloc] init];
    imgView.frame = frame;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imgView];
    NSString *path = [NSString stringWithFormat:@"%@/Skin/%@/icon_bai.jpg",
                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],skin];
    imgView.image = [UIImage imageWithContentsOfFile:path];
    
//    imgView.image = [UIImage imageNamed:image];
    
    imgView.layer.cornerRadius = radius;
    imgView.layer.masksToBounds = YES;
    
    imgView.imageName = image;
    
    return imgView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"changeSkin" object:nil];
    }
    return self;
}

-(void)refresh{
    
    NSString *path = [NSString stringWithFormat:@"%@/Skin/%@/%@.jpg",
                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],SkinName,self.imageName];
    self.image = [UIImage imageWithContentsOfFile:path];
}
@end
