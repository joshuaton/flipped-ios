//
//  FLComment.m
//  Flipped
//
//  Created by ShaoJun on 2017/8/1.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLComment.h"

@implementation FLComment

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"links"])
        return YES;
    
    return NO;
}

@end
