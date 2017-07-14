//
//  FLContent.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/8.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "JSONModel.h"

@protocol FLContent;

@interface FLContent : JSONModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString<Optional> *link;
@property (nonatomic, copy) NSString<Optional> *cover;
@property (nonatomic, strong) NSNumber<Optional> *duration;

@end
