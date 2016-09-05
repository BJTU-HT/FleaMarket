//
//  AddContactsDAODelegate.h
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef AddContactsDAODelegate_h
#define AddContactsDAODelegate_h
@class AddContactsDAO;

@protocol AddContactsDAODelegate <NSObject>

#pragma 添加好友部分

-(void)addContactsLoadAllUsersInfoFinishedDAO:(NSMutableArray *)arr;
-(void)addContactsLoadAllUsersInfoFailedDAO:(NSString *)error;

#pragma 添加好友部分 end
@end

#endif /* AddContactsDAODelegate_h */
