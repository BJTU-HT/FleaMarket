//
//  publicSearchBL.h
//  FleaMarket
//
//  Created by Hou on 8/8/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "publicSearchBLDelegate.h"
#import "publicSearchDelegate.h"

@interface publicSearchBL : NSObject<publicSearchDelegate>

@property(nonatomic, weak) id<publicSearchBLDelegate> delegatePSBL;

+(publicSearchBL *)sharedManager;

-(void)getUserTableInfoBL:(NSString *)userPara;

//leave message
-(void)leaveMessageRequestBL:(NSDictionary *)dic;

//请求留言数据
-(void)getLeaveMessageFromServerBL:(NSString *)objectId;
@end
