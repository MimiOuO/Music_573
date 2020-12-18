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
    NSString *path = [NSString stringWithFormat:@"%@/Skin/%@/%@",
                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],skin,image];
    imgView.image = [UIImage imageWithContentsOfFile:path];
    
//    imgView.image = [UIImage imageNamed:image];
    
    imgView.layer.cornerRadius = radius;
    imgView.layer.masksToBounds = YES;
    
    imgView.imageName = image;
    
    return imgView;
}

+(MioImageView *)creatImgView:(CGRect)frame inView:(UIView *)view image:(NSString *)image bgTintColorName:(NSString *)colorName radius:(CGFloat)radius{
    MioImageView *imgView = [[MioImageView alloc] initWithFrame:frame];
    imgView.colorName = colorName;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imgView];
    UIImage * tempImage = [UIImage imageNamed:image];
    tempImage = [tempImage imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    imgView.image = tempImage;
    imgView.tintColor = [MioColor colorWithName:colorName];
    
    
        imgView.layer.cornerRadius = radius;
        imgView.layer.masksToBounds = YES;
    
    
    return imgView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        RecieveChangeSkin
    }
    return self;
}

-(void)changeSkin{
    
    if (self.imageName.length > 0) {
        NSString *path = [NSString stringWithFormat:@"%@/Skin/%@/%@",
                         NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],SkinName,self.imageName];
        self.image = [UIImage imageWithContentsOfFile:path];
    }
    if (self.colorName.length > 0) {
        self.tintColor = [MioColor colorWithName:self.colorName];
    }

}
@end
