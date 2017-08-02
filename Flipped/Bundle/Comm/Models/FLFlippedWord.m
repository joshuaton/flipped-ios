//
//  FLFlippedWord.m
//  Flipped
//
//  Created by junshao on 2017/7/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedWord.h"

@implementation FLFlippedWord

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"links"])
        return YES;
    
    return NO;
}

@end
