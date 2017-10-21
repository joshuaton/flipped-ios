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

-(void)loadData;



@end
