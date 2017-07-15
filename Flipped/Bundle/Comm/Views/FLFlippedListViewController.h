//
//  FLFlippedListViewController.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLBaseViewController.h"
#import "FLFlippedWord.h"

@interface FLFlippedListViewController : FLBaseViewController

-(void)refreshWithFlippedWords:(NSMutableArray *)filppedWords;

@end
