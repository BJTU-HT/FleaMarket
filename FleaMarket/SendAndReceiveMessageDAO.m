//
//  SendAndReceiveMessage.m
//  FleaMarket
//
//  Created by Hou on 5/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "SendAndReceiveMessageDAO.h"


@implementation SendAndReceiveMessageDAO

-(void)receiveMessageDAO:(NSNotification *)noti conversation:(BmobIMConversation *)conversation{
    BmobIMMessage *message = noti.object;
    NSLog(@"%@",message.extra);
    
    if (message.extra[KEY_IS_TRANSIENT] && [message.extra[KEY_IS_TRANSIENT] boolValue]) {
        return;
    }
    if ([message.fromId isEqualToString:conversation.conversationId]) {
        
        BmobIMMessage *tmpMessage = nil;
        if ([message.msgType isEqualToString:kMessageTypeSound]) {
            tmpMessage = [[BmobIMAudioMessage alloc] initWithMessage:message];
        }else if([message.msgType isEqualToString:kMessageTypeImage]){
            tmpMessage = [[BmobIMImageMessage alloc] initWithMessage:message];
        }else{
            tmpMessage =  message;
        }
        [self.delegate SendAndReceiveMessageDeliverDAO:tmpMessage];
    }
    
}

//获取当前conversation聊天记录
-(void)loadMessageRecordsDAO:(BmobIMConversation *)conversation{
    NSArray *array = [conversation queryMessagesWithMessage:nil limit:10];
    if (array && array.count > 0) {
        NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(BmobIMMessage *obj1, BmobIMMessage *obj2) {
            if (obj1.updatedTime > obj2.updatedTime) {
                return NSOrderedDescending;
            }else if(obj1.updatedTime <  obj2.updatedTime) {
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
        }];
        [self.delegate loadMessageDeliverFinishedDAO:result];
    }else{
        [self.delegate loadMessageDeliverFailedDAO:NO_HISTORY_RECORDS];
    }
}

//获取更多当前Conversation聊天记录
-(void)loadMoreRecordsDAO:(BmobIMConversation *)conversation messageArr:(NSMutableArray *)messageArr{
    BmobIMMessage *msg = [messageArr firstObject];
    NSArray *array = [conversation queryMessagesWithMessage:msg limit:10];
    if (array && array.count > 0) {
        NSMutableArray *messages = [NSMutableArray arrayWithArray:messageArr];
        [messages addObjectsFromArray:array];
            NSArray *result = [messages sortedArrayUsingComparator:^NSComparisonResult(BmobIMMessage *obj1, BmobIMMessage *obj2) {
                if (obj1.updatedTime > obj2.updatedTime) {
                    return NSOrderedDescending;
                }else if(obj1.updatedTime <  obj2.updatedTime) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedSame;
                }
        }];
        [self.delegate loadMoreRecordsFinishedDAO:result];
    }else{
        [self.delegate loadMoreRecordsFailedDAO:NO_MORE_HISTORY_RECORDS];
    }
}


@end
