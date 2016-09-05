//
//  AddContactsDAO.h
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserService.h"
#import "AddContactsDAODelegate.h"

@interface AddContactsDAO : NSObject

@property (strong, nonatomic) id<AddContactsDAODelegate> delegate;

-(void)loadUsersDAO;
@end
