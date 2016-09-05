//
//  SecondhandDAODelegate.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

@class SecondhandVO;

@protocol SecondhandDAODelegate

@optional

- (void)findSecondhandFinished:(NSMutableArray *)list;
- (void)findSecondhandFailed:(NSError *)error;

- (void)findNewCommingFinished:(NSMutableArray *)list;
- (void)findNewCommingFailed:(NSError *)error;

- (void)createSecondhandFinished;
- (void)createSecondhandFailed;

/*
 - (void)searchByProductNameFinished:(NSMutableArray *)list;
 - (void)searchByProductNameFailed;
 
 - (void)searchByCategoryFinished:(NSMutableArray *)list;
 - (void)searchByCategoryFailed;
 
 - (void)searchBySchoolFinished:(NSMutableArray *)list;
 - (void)searchBySchoolFailed;
 
 - (void)findAllFinished:(NSMutableArray *)list;
 - (void)findAllFailed:(NSError *)error;
 
 - (void)findNewCommingThroughFilterFinished:(NSMutableArray *)list;
 - (void)findNewCommingThroughFilterFailed:(NSError *)error;
 */

@end
