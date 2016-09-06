//
//  bookPubUpLoadInfoBL.m
//  FleaMarket
//
//  Created by Hou on 7/27/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "bookPubUpLoadInfoBL.h"

@implementation bookPubUpLoadInfoBL
static bookPubUpLoadInfoBL *sharedManager = nil;

+(bookPubUpLoadInfoBL *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//上传图书信息逻辑层
-(void)uploadInfoBL:(NSMutableDictionary *)mutDic{
    bookPubUpLoadInfoDAO *bookPubDAO = [bookPubUpLoadInfoDAO sharedManager];
    bookPubDAO.delegateBookPub = self;
    [bookPubDAO uploadInfoDAO:mutDic];
}

//上传图片失败
-(void)uploadPicFailDAO:(NSError *)error{
    [self.delegateBookPubBL uploadPicFailBL:error];
}

//上传图书信息成功 失败
-(void)uploadBookInfoFinishedDAO:(BOOL)isSuccessful{
    [self.delegateBookPubBL uploadBookInfoFinishedBL:isSuccessful];
}
-(void)uploadBookInfoFailedDAO:(NSError *)error{
    [self.delegateBookPubBL uploadBookInfoFailedBL:error];
}

@end