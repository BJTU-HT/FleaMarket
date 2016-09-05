//
//  SendAndReceiveMessage.h
//  FleaMarket
//
//  Created by Hou on 5/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobIMSDK/BmobIMMessage.h>
#import <BmobIMSDK/BmobIMConversation.h>
#import <BmobIMSDK/BmobIMImageMessage.h>
#import <BmobIMSDK/BmobIMAudioMessage.h>
#import "BmobIMMessage+SubClass.h"
#import "SendAndReceiveMessageDelegateDAO.h"

@interface SendAndReceiveMessageDAO : NSObject

@property(nonatomic, weak)id<SendAndReceiveMessageDelegateDAO> delegate;

//传递会话信息
-(void)receiveMessageDAO:(NSNotification *)noti conversation:(BmobIMConversation *)conversation;

//load 双方聊天记录
-(void)loadMessageRecordsDAO:(BmobIMConversation *)conversation;

//loadMoreRecords
-(void)loadMoreRecordsDAO:(BmobIMConversation *)conversation messageArr:(NSMutableArray *)messageArr;
@end
