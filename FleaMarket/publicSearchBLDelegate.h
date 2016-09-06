//
//  publicSearchBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 8/8/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef publicSearchBLDelegate_h
#define publicSearchBLDelegate_h
@protocol publicSearchBLDelegate
@optional

-(void)publicSearchFinishedBL:(NSMutableDictionary *)mudicPS;

-(void)publicSearchFinishedNODataBL:(BOOL)val;

-(void)publicSearchFailedBL:(NSError *)error;

//leave message delegate
-(void)leaveMesFinishedBL:(NSString *)headURL;
-(void)leaveMesFailedBL:(NSError *)error;

//返回服务器的留言数据
-(void)returnLeaveMessageFinishedBL:(NSMutableArray *)muArrLM;

@end
#endif /* publicSearchBLDelegate
_h */
