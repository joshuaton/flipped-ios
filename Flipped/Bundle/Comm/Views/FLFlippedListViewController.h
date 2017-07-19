//
//  FLFlippedListViewController.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseViewController.h"
#import "FLFlippedWord.h"

typedef NS_ENUM(NSUInteger, FLFlippedListType) {
    FLFlippedListTypeSquare = 0,
    FLFlippedListTypeSend,
    FLFlippedListTypeReceive
};

@interface FLFlippedListViewController : FLBaseViewController

@property (nonatomic, assign) NSInteger listType;
@property (nonatomic, assign) BOOL isLoaded; //是否加载过数据

-(void)loadData;



@end
