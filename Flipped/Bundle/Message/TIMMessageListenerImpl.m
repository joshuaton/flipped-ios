//
//  TIMMessageListenerImpl.m
//  Flipped
//
//  Created by ShaoJun on 2017/10/1.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "TIMMessageListenerImpl.h"

@implementation TIMMessageListenerImpl

- (void)onNewMessage:(NSArray*) msgs {
    NSLog(@"NewMessages: %@", msgs);
}

@end
