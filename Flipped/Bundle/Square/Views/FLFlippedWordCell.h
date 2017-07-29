//
//  FLFlippedWordCell.h
//  Flipped
//
//  Created by ShaoJun on 2017/7/9.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLFlippedWord.h"

@interface FLFlippedWordCell : UITableViewCell

@property (nonatomic, assign) NSInteger type;

-(void)refreshWithData:(FLFlippedWord *)data;

@end
