//
//  findBooKInfoDAO.h
//  FleaMarket
//
//  Created by Hou on 8/1/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "findBookInfoDAODelegate.h"

@interface findBooKInfoDAO : NSObject

@property(nonatomic, strong)id<findBookInfoDAODelegate> delegate;

//分页查询时的偏移量
@property(nonatomic, assign) NSInteger bookOffset;
//下拉刷新偏移量
@property(nonatomic, assign) NSInteger bookOffsetUp;

//记录获取的最后一条记录时间
@property (nonatomic, strong) NSDate *bookLastestTime;

//添加访客
-(void)updateVisitorDataDAO:(NSMutableDictionary *)dic;

//根据书名检索图书
-(void)getBookDataAccordBookNameFromBmobDAO:(NSDictionary *)dic;

+(findBooKInfoDAO *)sharedManager;

-(void)getBookDataFromBmobDAO:(NSDictionary *)dic;
-(void)downDragGetDataFromDAO:(NSDictionary *)dic;
@end
