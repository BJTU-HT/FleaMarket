//
//  SendAndReceiveMessageBL.m
//  FleaMarket
//
//  Created by Hou on 5/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "SendAndReceiveMessageBL.h"

@implementation SendAndReceiveMessageBL

//接收服务器传回对方信息
-(void)receiveMessageBL:(NSNotification *)noti conversation:(BmobIMConversation *)conversation{
    SendAndReceiveMessageDAO *receive = [[SendAndReceiveMessageDAO alloc] init];
    receive.delegate = self;
    [receive receiveMessageDAO:noti conversation:conversation];
}

//获取双方聊天记录 loadRecords
-(void)loadMessageDeliverBL:(BmobIMConversation *)conversation{
    SendAndReceiveMessageDAO *loadMes = [[SendAndReceiveMessageDAO alloc] init];
    loadMes.delegate = self;
    [loadMes loadMessageRecordsDAO:conversation];
}

//loadMoreRecords
-(void)loadMoreRecordsBL:(BmobIMConversation *)conversation messageArr:(NSMutableArray *)messageArr{
    SendAndReceiveMessageDAO *loadMore = [[SendAndReceiveMessageDAO alloc] init];
    loadMore.delegate = self;
    [loadMore loadMoreRecordsDAO:conversation messageArr:messageArr];
}
#pragma 代理方法实现 DAO
//实现会话信息DAO层的代理方法
-(void)SendAndReceiveMessageDeliverDAO:(BmobIMMessage *)message{
    [self.delegate SendAndReceiveMessageDeliverBL:message];
}

//获取双方聊天记录 DAO代理方法实现 loadRecords
-(void)loadMessageDeliverFinishedDAO:(NSArray *)array{
    [self.delegate loadMessageDeliverFinishedBL:array];
}
-(void)loadMessageDeliverFailedDAO:(NSString *)error{
    [self.delegate loadMessageDeliverFailedBL:error];
}

//loadMoreRecords 数据回传到VC
-(void)loadMoreRecordsFinishedDAO:(NSArray *)array{
    [self.delegate loadMoreRecordsFinishedBL:array];
}
-(void)loadMoreRecordsFailedDAO:(NSString *)error{
    [self.delegate loadMoreRecordsFailedBL:error];
}

#pragma 代理方法实现 DAO end
@end
