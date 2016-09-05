//
//  SecondhandMessageBL.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/13.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandMessageBL.h"

@implementation SecondhandMessageBL

- (void)findSecondhandMessage:(NSString *)productID
{
    SecondhandMessageDAO *secondhandMessageDAO = [SecondhandMessageDAO sharedManager];
    secondhandMessageDAO.delegate = self;
    [secondhandMessageDAO findSecondhandMessage:productID];
}

- (void)createComment:(SecondhandMessageVO *)model
{
    SecondhandMessageDAO *secondhandMessageDAO = [SecondhandMessageDAO sharedManager];
    secondhandMessageDAO.delegate = self;
    [secondhandMessageDAO createMessage:model];
}

- (void)reset
{
    SecondhandMessageDAO *secondhandMessageDAO = [SecondhandMessageDAO sharedManager];
    secondhandMessageDAO.readSkip = 0;
}

#pragma --mark --------------SecondhandMessageDAODelegate委托方法------------------
- (void)findSecondhandMessageFinished:(NSMutableArray *)list
{
    [self.delegate findSecondhandMessageFinished:list];
}

- (void)findSecondhandMessageFailed:(NSError *)error
{
    [self.delegate findSecondhandMessageFailed:error];
}

- (void)createMessageFinished:(SecondhandMessageVO *)model
{
    [self.delegate insertCommentFinished:model];
}

- (void)createMessageFailed:(NSError *)error
{
    [self.delegate insertCommentFailed:error];
}

@end
