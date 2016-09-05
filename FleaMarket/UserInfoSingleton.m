//
//  UserInfoSingleton.m
//  FleaMarket
//
//  Created by tom555cat on 16/7/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfoSingleton.h"

@interface UserInfoSingleton ()

@property (nonatomic) AppDelegate *appDelegate;

@end

@implementation UserInfoSingleton

static UserInfoSingleton *sharedManager = nil;

+ (UserInfoSingleton *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        sharedManager.appDelegate = [[UIApplication sharedApplication] delegate];
        [sharedManager searchUserInfo];
    });
    
    return sharedManager;
}

- (void)searchUserInfo
{
    NSManagedObjectContext *moc = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching Pseron objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    if (results.count == 1) {
        self.userMO = results[0];
    }
}

- (void)updateUserMO:(NSDictionary *)userInfo
{
    NSManagedObjectContext *moc = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching User object: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    // 删除已有数据
    for (UserMO *userMO in results) {
        [moc deleteObject:userMO];
    }
    
    // 存入新数据
    self.userMO = [self.appDelegate createUserMO];
    self.userMO.user_id = userInfo[@"userID"];
    self.userMO.user_name = userInfo[@"userName"];
    self.userMO.phone_number = userInfo[@"phoneNumber"];
    self.userMO.live_city = userInfo[@"liveCity"];
    self.userMO.gender = userInfo[@"gender"];
    self.userMO.head_image_url = userInfo[@"avatar"];
    self.userMO.background_image_url = userInfo[@"backgroundImageURL"];
    
    NSLog(@"%@", self.userMO);
    
    [self.appDelegate saveContext];
}

@end
