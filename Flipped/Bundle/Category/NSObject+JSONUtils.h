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
 *  @return
 */
- (NSData *)cp_toJSONData;
/**
 *  objc -> json string
 *
 *  @return
 */
- (NSString *)cp_toJSONString;
/**
 *  json data or json string -> objc
 *
 *  @return
 */
- (id)cp_toJSONObject;

@end
