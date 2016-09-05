//
//  SendAndReceiveMessageBL.h
//  FleaMarket
//
//  Created by Hou on 5/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendAndRecMesDelegateBL.h"
#import "SendAndReceiveMessageDAO.h"
#import "SendAndReceiveMessageDelegateDAO.h"
#import <BmobIMSDK/BmobIMConversation.h>

@interface SendAndReceiveMessageBL : NSObject<SendAndReceiveMessageDelegateDAO>

@property (nonatomic,weak) id<SendAndRecMesDelegateBL> delegate;

//BL 接收会话信息
-(void)receiveMessageBL:(NSNotification *)noti conversation:(BmobIMConversation *)conversation;

//loadRecords
-(void)loadMessageDeliverBL:(BmobIMConversation *)conversation;

//loadMoreRecords
-(void)loadMoreRecordsBL:(BmobIMConversation *)conversation messageArr:(NSMutableArray *)messageArr;

@end
