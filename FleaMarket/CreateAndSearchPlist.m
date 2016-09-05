//
//  CreateAndSearchPlist.m
//  FleaMarket
//
//  Created by Hou on 4/26/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "CreateAndSearchPlist.h"
#import "userInfoVO.h"

@implementation CreateAndSearchPlist


-(void)writeToPlist:(NSString *)plistName writeContent:(NSMutableDictionary *)dic
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *currentUserName = [userDefaults objectForKey:@"userName"];
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *path=[paths objectAtIndex:0];
//    //NSLog(@"path = %@",path);
//    NSString *filename=[path stringByAppendingPathComponent:plistName];
//    NSMutableDictionary *dicRead = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
//    if(dicRead == nil)
//    {
//        dicRead = [[NSMutableDictionary alloc] init];
//        NSFileManager* fm = [NSFileManager defaultManager];
//        [fm createFileAtPath:filename contents:nil attributes:nil];
//        [dicRead setObject:@"1" forKey:@"userCount"];
//        [dicRead setObject:dic forKey:@"user1"];
//    }
//    else
//    {
//        NSString *userNum = [self findUserNameFromPlist: plistName curUser:currentUserName];
//        if(userNum)
//        {
//            NSMutableDictionary *dicTemp = [dicRead objectForKey:userNum];
//            [dicTemp addEntriesFromDictionary: dic];
//            [dicRead setObject:dicTemp forKey:userNum];
//        }else{
//            int userCount = [[dicRead objectForKey:@"userCount"] intValue];
//            NSLog(@"userCount----%d", userCount);
//            NSString *userID = [NSString stringWithFormat:@"user%d", (userCount + 1)];
//            [dicRead setObject:dic forKey:userID];
//            NSString *userCounter = [NSString stringWithFormat:@"%d", userCount + 1];
//            [dicRead setObject:userCounter forKey:@"userCount"];
//        }
//    }
//    //plist 文件本身不支持修改功能（一般是直接覆盖），通过读取plist中的内容，添加内容，重新写入
//    [dicRead writeToFile:filename atomically:YES];
}
-(NSMutableDictionary *)readPlist:(NSString *)pListName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:pListName];
    NSMutableDictionary* dicRead = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    return dicRead;
}

//返回值
-(NSString *)findUserNameFromPlist:(NSString *)plistName curUser:(NSString *)curUserName
{
    NSMutableDictionary *dicRead = [self readPlist: plistName];
    int count = [[dicRead objectForKey:@"userCount"] intValue];
    for(int i = 1; i <= count; i++)
    {
        NSString *userNum = [NSString stringWithFormat:@"user%d", i];
        NSMutableDictionary *userInfo = [dicRead objectForKey: userNum];
        NSString *userName = [userInfo objectForKey:@"userName"];
        if([userName isEqualToString:curUserName])
        {
            return userNum;
        }
    }
    return nil;
}
@end
