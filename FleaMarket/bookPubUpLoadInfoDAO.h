//
//  bookPubUpLoadInfo.h
//  FleaMarket
//
//  Created by Hou on 7/27/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bookPubUpLoadInfoDAODelegate.h"

@interface bookPubUpLoadInfoDAO : NSObject

@property (nonatomic, weak) id<bookPubUpLoadInfoDAODelegate> delegateBookPub;
@property (strong, nonatomic) NSString *requestStatus;
@property (strong, nonatomic) NSString *pubBookImageURL;
+(bookPubUpLoadInfoDAO *)sharedManager;
//发布图书信息
-(void)uploadInfoDAO:(NSMutableDictionary *)mutDic;

@end
