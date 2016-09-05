
//
//  SendAndReceiveMessageDelegate.h
//  FleaMarket
//
//  Created by Hou on 5/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobIMSDK/BmobIMMessage.h>

@protocol SendAndReceiveMessageDelegateDAO <NSObject>

-(void)SendAndReceiveMessageDeliverDAO:(BmobIMMessage *)message;

//loadMessage 数据回传到VC
-(void)loadMessageDeliverFinishedDAO:(NSArray *)array;
-(void)loadMessageDeliverFailedDAO:(NSString *)error;
//loadMoreRecords 数据回传到VC
-(void)loadMoreRecordsFinishedDAO:(NSArray *)array;
-(void)loadMoreRecordsFailedDAO:(NSString *)error;
@end
