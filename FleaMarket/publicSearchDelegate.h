
//
//  publishSearchDelegate.h
//  FleaMarket
//
//  Created by Hou on 8/8/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef publicSearchDelegate_h
#define publicSearchDelegate_h
@protocol publicSearchDelegate
@optional

-(void)publicSearchFinishedDAO:(NSMutableDictionary *)mudicPS;
-(void)publicSearchFinishedNODataDAO:(BOOL)val;
-(void)publicSearchFailedDAO:(NSError *)error;

//leave message delegate
-(void)leaveMesFinishedDAO:(NSString *)headURL;
-(void)leaveMesFailedDAO:(NSError *)error;

//返回服务器中的留言数据
-(void)returnLeaveMessageFinishedDAO:(NSMutableArray *)muArrLM;
@end
#endif /* publishSearchDelegate_h */
