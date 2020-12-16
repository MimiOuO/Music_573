//
//  MioTest2VC.m
//  573music
//
//  Created by Mimio on 2020/11/23.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioTest2VC.h"
#import <SSZipArchive.h>
@interface MioTest2VC ()

@end

@implementation MioTest2VC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
//    [self.navView.centerButton setTitle:@"解压" forState:UIControlStateNormal];
    


    // Unzip

    
    UIButton *sdfsd = [UIButton creatBtn:frame(100, 100, 100, 100) inView:self.view bgColor:mainColor title:@"111" titleColor:appWhiteColor font:14 radius:5 action:^{
        [self unzipPressed:sdfsd];
    }];
}

-(void)unzipPressed:(id)sender {
    
    NSString *zipPath =
    [NSString stringWithFormat:@"%@/Skin/bai.zip",
                     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];

    NSString *unzipPath = [NSString stringWithFormat:@"%@/Skin",
                           NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
   
    NSLog(@"Unzip path: %@", unzipPath);
    if (!unzipPath) {
        return;
    }
    
    BOOL success = [SSZipArchive unzipFileAtPath:zipPath
                                   toDestination:unzipPath
                              preserveAttributes:YES
                                       overwrite:YES
                                  nestedZipLevel:0
                                        password:nil
                                           error:nil
                                        delegate:nil
                                 progressHandler:nil
                               completionHandler:nil];
    if (success) {
        NSLog(@"Success unzip");
        
    } else {
        NSLog(@"No success unzip");
        
        return;
    }
    NSError *error = nil;
    NSMutableArray<NSString *> *items = [[[NSFileManager defaultManager]
                                          contentsOfDirectoryAtPath:unzipPath
                                          error:&error] mutableCopy];
    if (error) {
        return;
    }
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0: {
//                self.file1.text = obj;
                break;
            }
            case 1: {
//                self.file2.text = obj;
                break;
            }
            case 2: {
//                self.file3.text = obj;
                break;
            }
            default: {
                NSLog(@"Went beyond index of assumed files");
                break;
            }
        }
    }];
//    _unzipButton.enabled = NO;
}

@end
