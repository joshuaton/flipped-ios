//
//  FLCommentCell.h
//  Flipped
//
//  Created by ShaoJun on 2017/8/1.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLComment.h"

@interface FLCommentCell : UITableViewCell

-(void)refreshWithData:(FLComment *)data;

@end
