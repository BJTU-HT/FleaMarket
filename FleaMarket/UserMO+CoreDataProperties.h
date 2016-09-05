//
//  UserMO+CoreDataProperties.h
//  FleaMarket
//
//  Created by tom555cat on 16/7/22.
//  Copyright © 2016年 H-T. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *user_name;
@property (nullable, nonatomic, retain) NSString *phone_number;
@property (nullable, nonatomic, retain) NSString *live_city;
@property (nullable, nonatomic, retain) NSString *school;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *head_image_url;
@property (nullable, nonatomic, retain) NSString *background_image_url;

@end

NS_ASSUME_NONNULL_END
