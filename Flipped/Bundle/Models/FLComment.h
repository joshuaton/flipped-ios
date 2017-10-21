//
//  FLComment.h
//  Flipped
//
//  Created by ShaoJun on 2017/8/1.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "JSONModel.h"
#import "FLContent.h"
#import "FLLink.h"

@protocol FLComment;

@interface FLComment : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) NSInteger ctime;
@property (nonatomic, strong) NSArray<FLContent> *contents;
@property (nonatomic, assign) NSInteger floor;
@property (nonatomic, strong) NSArray<FLLink> *links;

@end
