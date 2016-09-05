//
//  BmobIMUserInfo+BmobUser.m
//  FleaMarket
//
//  Created by Hou on 5/13/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "BmobIMUserInfo+BmobUser.h"

@implementation BmobIMUserInfo(BmobUser)

+(instancetype)userInfoWithBmobUser:(BmobUser *)user{
    BmobIMUserInfo *info  = [[BmobIMUserInfo alloc] init];
    info.userId = user.objectId;
    info.name = user.username;
    info.avatar = [user objectForKey:@"avatar"];
    //info.avatar = [user objectForKey:@"headImageURL"];
    return info;
}

@end
