//
//  NSObject+JSONUtils.m
//  CPFoundation
//
//  Created by enqingchen on 16/6/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "NSObject+JSONUtils.h"

@implementation NSObject (JSONUtils)
- (NSData *)cp_toJSONData{
    if(![self isKindOfClass:[NSDictionary class]] && ![self isKindOfClass:[NSArray class]]) return nil;
    
    @try {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if ([jsonData length] > 0 && error == nil){
            return jsonData;
        }else{
            return nil;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    
}
- (NSString *)cp_toJSONString{
    NSData* data = [self cp_toJSONData];
    if(!data) return nil;
    @try {
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    @catch (NSException *exception) {
        return nil;
    }
}
- (id)cp_toJSONObject{
    @try {
        NSData* data = nil;
        if([self isKindOfClass:[NSData class]]){
            data = (NSData*)self;
        }
        else if([self isKindOfClass:[NSString class]]){
            data = [(NSString*)self dataUsingEncoding:NSUTF8StringEncoding];
        }
        NSError* error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error != nil) return nil;
        return result;
    }
    @catch (NSException *exception) {
        return nil;
    }
}
@end
