//
//  AddContactsDAO.m
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "AddContactsDAO.h"

@implementation AddContactsDAO

-(void)loadUsersDAO{
    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    [UserService loadUsersWithDate:[NSDate date] completion:^(NSArray *array, NSError *error) {
        if (error) {
            [self.delegate addContactsLoadAllUsersInfoFailedDAO:GET_USER_DATA_FROM_SERVER_FAILED];
        }else{
            if (array && array.count > 0) {
                [userArray setArray:array];
                [self.delegate addContactsLoadAllUsersInfoFinishedDAO:userArray];
            }else{
                [self.delegate addContactsLoadAllUsersInfoFailedDAO:GET_USER_DATA_FROM_SERVER_FAILED];
            }
        }
    }];
}
@end
