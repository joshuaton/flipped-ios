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

@interface FLFlippedWord : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *sendto;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger ctime;
@property (nonatomic, strong) NSArray<FLContent> *contents;


@end
