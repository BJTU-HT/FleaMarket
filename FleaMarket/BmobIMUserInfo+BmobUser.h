//
//  BmobIMUserInfo+BmobUser.h
//  FleaMarket
//
//  Created by Hou on 5/13/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <BmobIMSDK/BmobIMSDK.h>
#import <BmobSDK/Bmob.h>

@interface BmobIMUserInfo (BmobUser)

+(instancetype)userInfoWithBmobUser:(BmobUser *)user;

@end
