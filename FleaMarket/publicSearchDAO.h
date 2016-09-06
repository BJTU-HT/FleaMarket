//
//  publicSearchDAO.h
//  FleaMarket
//
//  Created by Hou on 8/8/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "publicSearchDelegate.h"

@interface publicSearchDAO : NSObject

@property(nonatomic, weak) id<publicSearchDelegate> delegatePS;

+(publicSearchDAO *)sharedManager;
//查询用户名下的头像URL
-(void)getUserTableInfoDAO:(NSString *)userPara;

//leave message
-(void)leaveMessageRequestDAO:(NSDictionary *)dic;

//请求留言数据
-(void)getLeaveMessageFromServerDAO:(NSString *)objectId;
@end
