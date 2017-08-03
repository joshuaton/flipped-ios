//
//  FLFlippedWord.h
//  Flipped
//
//  Created by junshao on 2017/7/5.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"
#import "FLContent.h"
#import "FLLink.h"

@protocol FLFlippedWord;

@interface FLFlippedWord : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *sendto;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, assign) NSNumber<Optional> *status;
@property (nonatomic, assign) NSInteger ctime;
@property (nonatomic, strong) NSNumber<Optional> *distance;
@property (nonatomic, strong) NSArray<FLContent> *contents;
@property (nonatomic, strong) NSArray<FLLink> *links;
@property (nonatomic, assign) NSInteger commentnum;


@end
