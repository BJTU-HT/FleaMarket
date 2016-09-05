//
//  SendAndRecMesDelegateBL.h
//  FleaMarket
//
//  Created by Hou on 5/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <BmobIMSDK/BmobIMMessage.h>

@protocol SendAndRecMesDelegateBL <NSObject>

-(void)SendAndReceiveMessageDeliverBL:(BmobIMMessage *)message;

//loadMessage 数据回传到VC
-(void)loadMessageDeliverFinishedBL:(NSArray *)array;
-(void)loadMessageDeliverFailedBL:(NSString *)error;
//loadMoreRecords 数据回传到VC
-(void)loadMoreRecordsFinishedBL:(NSArray *)array;
-(void)loadMoreRecordsFailedBL:(NSString *)error;
@end