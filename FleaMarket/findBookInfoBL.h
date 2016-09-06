//
//  findBookInfoBL.h
//  FleaMarket
//
//  Created by Hou on 8/1/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "findBookInfoBLDelegate.h"
#import "findBooKInfoDAO.h"

@interface findBookInfoBL : NSObject<findBookInfoDAODelegate>

@property(nonatomic, weak)id<findBookInfoBLDelegate> delegate;

+(findBookInfoBL *)sharedManager;

-(void)getBookDataFromBmobBL:(NSDictionary *)dic;
-(void)getBookDataDownDragFromBmobBL:(NSDictionary *)dic;
-(void)resetOffset;
-(void)resetOffsetDownDrag;
// add vistor
-(void)updateVisitorDataBL:(NSMutableDictionary *)dic;

//通过书名检索数据
-(void)getBookDataAccordBookNameFromBmobBL:(NSDictionary *)dic;
@end
