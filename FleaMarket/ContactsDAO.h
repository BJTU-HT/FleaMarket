//
//  ContactsDAO.h
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatDAODelegate.h"

@interface ContactsDAO : NSObject

@property (nonatomic, weak) id<ChatDAODelegate> delegate;

+(ContactsDAO *)sharedManager;

////更新当前用户好友
//-(void)updateFriendUsersDataDAO:(NSArray *)array;
//
////获取当前用户的好友
//-(void)getCurUserFriendUsersDataDAO;

@end
