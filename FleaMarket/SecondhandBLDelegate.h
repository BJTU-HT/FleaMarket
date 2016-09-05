//
//  SecondhandBLDelegate.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

#ifndef SecondhandBLDelegate_h
#define SecondhandBLDelegate_h

@protocol SecondhandBLDelegate

@optional

// 创建二手商品
- (void)publishSecondhandFinished;
- (void)publishSecondhandFailed;

// 根据过滤条件进行查询
- (void)findSecondhandFinished:(NSMutableArray *)list;
- (void)findSecondhandFailed:(NSError *)error;

// 查询刷新数据
- (void)findNewCommingSecondhandFinished:(NSMutableArray *)list;
- (void)findNewCommingSecondhandFailed:(NSError *)error;

/*
 // 根据分类进行查询
 - (void)searchByCategoryFinished:(NSMutableArray *)list;
 - (void)searchByCategoryFailed;
 
 // 根据学校进行查询
 - (void)searchBySchoolFinished:(NSMutableArray *)list;
 - (void)searchBySchoolFailed;
 
 // 根据标题过滤查询
 - (void)searchByProductNameFinished:(NSMutableArray *)list;
 - (void)searchByProductNameFailed;
 
 // 查询UITableViewController所需要的数据
 - (void)findAllSecondhandFinished:(NSMutableArray *)list;
 - (void)findAllSecondhandFailed:(NSError *)error;
 
 // 根据过滤条件查询刷新数据
 - (void)findNewCommingSecondhandThroughFilterFinished:(NSMutableArray *)list;
 - (void)findNewCommingSecondhandTrhoughFilterFailed:(NSError *)error;
 */


@end


#endif /* SecondhandBLDelegate_h */
