//
//  CreateAndSearchPlist.h
//  FleaMarket
//
//  Created by Hou on 4/26/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateAndSearchPlist : NSObject

//向plist文件写入数据
-(void)writeToPlist:(NSString *)name writeContent:(NSMutableDictionary *)dic;

//从plist文件读取数据
-(NSMutableDictionary *)readPlist:(NSString *)name;

//从plist文件中获取和当前用户名匹配的userID
-(NSString *)findUserNameFromPlist:(NSString *)plistName curUser:(NSString *)curUserName;
@end
