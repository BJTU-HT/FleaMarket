//
//  bookPubUpLoadInfoBL.h
//  FleaMarket
//
//  Created by Hou on 7/27/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bookPubUpLoadInfoDAO.h"
#import "bookPubUpLoadInfoBLDelegate.h"

@interface bookPubUpLoadInfoBL : NSObject <bookPubUpLoadInfoDAODelegate>

@property (nonatomic, weak)id<bookPubUpLoadInfoBLDelegate> delegateBookPubBL;

+(bookPubUpLoadInfoBL *)sharedManager;
//发布图书逻辑层
-(void)uploadInfoBL:(NSMutableDictionary *)mutDic;
@end
