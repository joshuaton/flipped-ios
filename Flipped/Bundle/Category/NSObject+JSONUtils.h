//
//  NSObject+JSONUtils.h
//  CPFoundation
//
//  Created by enqingchen on 16/6/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSONUtils)

/**
 *  objc -> json data
 *
 */
- (NSData *)cp_toJSONData;
/**
 *  objc -> json string
 *
 */
- (NSString *)cp_toJSONString;
/**
 *  json data or json string -> objc
 *
 */
- (id)cp_toJSONObject;

@end
