//
//  MioChooseFavoriteTagView.m
//  573music
//
//  Created by Mimio on 2021/2/3.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioChooseFavoriteTagView.h"
#import "CustomCell.h"
@implementation MioChooseFavoriteTagView

-(void)showFavoriteTagViewWithArr:(NSArray *)oldArr{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
   
    UIView *bgView = [UIView creatView:frame(0, 0, KSW, KSH) inView:window bgColor:rgba(0, 0, 0, 0.3) radius:0];
    MioView *view = [MioView creatView:frame(40, 0, KSW - 80, KSH) inView:bgView bgColorName:name_hud radius:8];
    
    MioLabel *titleLab = [MioLabel creatLabel:frame(0, 0, KSW -  80, 50) inView:view text:@"我想听~" colorName:name_text_one boldSize:16 alignment:NSTextAlignmentCenter];
    MioView *split = [MioView creatView:frame(0, 49.5, KSW - 80, 0.5) inView:view bgColorName:name_split radius:0];
    UIScrollView *tagScroll = [UIScrollView creatScroll:frame(0, 50, view.width, 210) inView:view contentSize:CGSizeMake(KSW - 80, 0)];
    
    NSArray *arr = [userdefault objectForKey:@"category"];
    NSMutableArray *tagArr = [[NSMutableArray alloc] init];
    for (int i = 0;i < arr.count; i++) {
        [tagArr addObjectsFromArray:arr[i][@"tags"]];
    }
    
    tagScroll.contentSize = CGSizeMake(KSW - 80, ceil(tagArr.count/3.0)*36) ;
    
    for (int i = 0;i < tagArr.count; i++) {

        __block UIButton *btn = [UIButton creatBtn:frame(Mar + ((tagScroll.width - Mar2 - 8) / 3 + 4)  * (i%3), Mar + 36 * (i/3), (tagScroll.width - Mar2 - 8) / 3, 28) inView:tagScroll bgColor:color_sup_one title:tagArr[i] titleColor:color_text_one font:12 radius:14 action:^{
            btn.selected = !btn.selected;
        }];
        [btn setBackgroundColor:color_main forState:UIControlStateSelected];
        [btn setTitleColor:appWhiteColor forState:UIControlStateSelected];
        btn.tag = 100 + i;
        if ([oldArr containsObject:tagArr[i]]) {
            btn.selected = YES;
        }
    }
    

    UIButton *knowBtn = [UIButton creatBtn:frame(20, 260 + 20, view.width - 40, 38) inView:view bgColor:color_main title:@"选好了" titleColor:appWhiteColor font:14 radius:6 action:^{
        NSMutableArray *selectArr = [[NSMutableArray alloc] init];
        for (int i = 0;i < tagArr.count; i++) {
            UIButton *btn = [tagScroll viewWithTag:100 + i];
            if (btn.selected == YES) {
                [selectArr addObject:tagArr[i]];
            }
        }
        
        [MioPostReq(api_favoriteTag, @{@"tags":selectArr}) success:^(NSDictionary *result){
            NSDictionary *data = [result objectForKey:@"data"];
            
        } failure:^(NSString *errorInfo) {}];
        if ([self.delegate respondsToSelector:@selector(chooseFavorite:)]) {
                [self.delegate chooseFavorite:selectArr];
            }
        
        [UIView animateWithDuration:0.3 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    }];
    
   
    view.height = 260 + 60 +  16;
    view.centerY = KSH/2;
    knowBtn.top = 260 + 20;
    
    UIButton *closeBtn = [UIButton creatBtn:frame(KSW2 - 12, view.bottom + 16, 24, 24) inView:bgView bgImage:@"tc_gb" action:^{
        [UIView animateWithDuration:0.3 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    }];
}
@end
