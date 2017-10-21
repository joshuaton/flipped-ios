//
//  FLLink.h
//  Flipped
//
//  Created by ShaoJun on 2017/8/1.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "JSONModel.h"

@protocol FLLink;

@interface FLLink : JSONModel

@property (nonatomic, copy) NSString *rel;
@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) NSString *method;

@end
