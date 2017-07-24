//
//  FLStringUtils.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/24.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLStringUtils.h"

@implementation FLStringUtils

+(NSString *)convertToHttpsWithUrl:(NSString *)url{
    if([url hasPrefix:@"http://"]){
        url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
    return url;
}

@end
