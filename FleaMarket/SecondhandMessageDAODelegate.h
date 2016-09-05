//
//  SecondhandMessageDAODelegate.h
//  FleaMarket
//
//  Created by tom555cat on 16/4/12.
//  Copyright © 2016年 H-T. All rights reserved.
//

@class SecondhandMessageVO;

@protocol SecondhandMessageDAODelegate

@optional

- (void)findSecondhandMessageFinished:(NSMutableArray *)list;
- (void)findSecondhandMessageFailed:(NSError *)error;

- (void)createMessageFinished:(SecondhandMessageVO *)model;
- (void)createMessageFailed:(NSError *)error;

@end
