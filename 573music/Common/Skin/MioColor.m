//
//  MioColorConfig.m
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioColor.h"

@implementation MioColor

+(UIColor *)colorWithName:(NSString *)colorName{
    NSArray *nameArr = @[@"main",
                         
                         @"sup_one",
                         @"sup_two",
                         @"sup_three",
                         @"sup_four",
                         
                         @"text_white",
                         @"color_text_two",
                         @"text_two",
                         @"text_three",
                         
                         @"icon_white",
                         @"color_icon_one",
                         @"icon_two",
                         @"color_icon_three",
                         
                         @"search",
                         @"card",
                         @"hud",
                         @"split",
                         @"input_bg",
                         @"input_line",
                         @"input_icon",

                         ];
    NSArray *colorArr = @[color_main,
                          
                          color_sup_one,
                          color_sup_two,
                          color_sup_three,
                          color_sup_four,
                          
                          color_text_white,
                          color_text_one,
                          color_text_two,
                          color_text_three,
                          
                          color_icon_white,
                          color_icon_one,
                          color_icon_two,
                          color_icon_three,
                          
                          color_search,
                          color_card,
                          color_hud,
                          color_split,
                          
                          color_input_bg,
                          color_input_line,
                          color_input_icon,
                          
                          ];
    return colorArr[[nameArr indexOfObject:colorName]];
}

@end
