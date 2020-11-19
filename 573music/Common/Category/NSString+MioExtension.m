//
//  NSString+MioExtension.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/12/23.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "NSString+MioExtension.h"
#import "NerdyUI.h"
@implementation NSString (MioExtension)

+ (NSString *)JoinedWithSubStrings:(id)firstStr,...NS_REQUIRES_NIL_TERMINATION{
    
    NSMutableArray *array = [NSMutableArray new];
    
    va_list args;
    
    if(firstStr){
        
        [array addObject:firstStr];
        
        va_start(args, firstStr);
        
        id obj;
        
        while ((obj = va_arg(args, NSString* ))) {
            [array addObject:obj];
        }
        
        va_end(args);
    }
    
    
    return [array componentsJoinedByString:@""];
    
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(MAXFLOAT, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

+(BOOL)equalsValue:(NSString *)one with:(NSString *)two{
    
    if ([Str(one) isEqualToString:Str(two)]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)equalsIntValue:(int)one with:(NSString *)two{
    if ([Str(one) isEqualToString:Str(two)]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)equalsValue:(NSString *)one withInt:(int)two{
    if ([Str(one) isEqualToString:Str(two)]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)equalsIntValue:(int)one withInt:(int)two{
    if ([Str(one) isEqualToString:Str(two)]) {
        return YES;
    }else{
        return NO;
    }
}

@end
