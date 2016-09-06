//
//  publicSearchDAO.m
//  FleaMarket
//
//  Created by Hou on 8/8/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "publicSearchDAO.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/Bmob.h>

@implementation publicSearchDAO
static publicSearchDAO *sharedManager;

+(publicSearchDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//获取_user用户表下的用户信息
-(void)getUserTableInfoDAO:(NSString *)userPara{
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:userPara];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            [self.delegatePS publicSearchFailedDAO:error];
        }else{
            if(array.count == 0){
                [self.delegatePS publicSearchFinishedNODataDAO:array.count];
            }else{
                NSMutableDictionary *mudicPS = [[NSMutableDictionary alloc] init];
                [mudicPS setObject:[array[0] objectForKey:@"avatar"] forKey:@"avatar"];
                [self.delegatePS publicSearchFinishedDAO:mudicPS];
            }
        }
    }];
}

//留言数据上传
-(void)leaveMessageRequestDAO:(NSDictionary *)dic{
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[dic objectForKey: @"userName"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            [self.delegatePS publicSearchFailedDAO:error];
        }else{
            if(array.count == 0){
                [self.delegatePS publicSearchFinishedNODataDAO:array.count];
            }else{
                BmobObject *obj = [BmobObject objectWithClassName:@"bookComment"];
                if([array[0] objectForKey:@"avatar"])
                    [obj setObject:[array[0] objectForKey:@"avatar"] forKey:@"avatarLM"];
                if([dic objectForKey:@"product_id"]){
                    [obj setObject:[dic objectForKey:@"product_id"] forKey:@"product_id"];
                }
                if([dic objectForKey:@"content"]){
                    [obj setObject:[dic objectForKey: @"content"] forKey:@"content"];
                }
                if([dic objectForKey:@"userName"]){
                    [obj setObject:[dic objectForKey:@"userName"] forKey:@"userName"];
                }
                if([dic objectForKey:@"to_userName"]){
                    [obj setObject:[dic objectForKey:@"to_userName"] forKey:@"to_userName"];
                }
                if([dic objectForKey:@"publishTime"]){
                    [obj setObject:[dic objectForKey:@"publishTime"] forKey:@"publishTime"];
                }
                [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if(isSuccessful){
                        [self.delegatePS leaveMesFinishedDAO:[array[0] objectForKey:@"avatar"]];
                    }else{
                        [self.delegatePS leaveMesFailedDAO:error];
                    }
                }];
                //[self.delegatePS publicSearchFinishedDAO:mudicPS];
            }
        }
    }];
}

//请求留言数据
-(void)getLeaveMessageFromServerDAO:(NSString *)objectId{
    NSMutableArray *muArrLM = [[NSMutableArray alloc] init];
    BmobQuery *query = [BmobQuery queryWithClassName:@"bookComment"];
    [query whereKey:@"product_id" equalTo:objectId];
    [query orderByAscending:@"publishTime"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            
        }else{
            if(array.count == 0){
                //没有留言数据
            }else{
                for(int i = 0; i < array.count; i++){
                    BmobObject *object = [array objectAtIndex:i];
                    [muArrLM addObject:[self objToMuArr:object]];
                }
                [self.delegatePS returnLeaveMessageFinishedDAO:muArrLM];
            }
        }
    }];
}

-(NSMutableDictionary *)objToMuArr:(BmobObject *)obj{
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
    if([obj objectForKey:@"publishTime"]){
        [muDic setObject:[obj objectForKey:@"publishTime"] forKey:@"publishTime"];
    }
    if([obj objectForKey:@"userName"]){
        [muDic setObject:[obj objectForKey:@"userName"] forKey:@"userName"];
    }
    if([obj objectForKey:@"to_userName"]){
        [muDic setObject:[obj objectForKey:@"to_userName"] forKey:@"to_userName"];
    }
    if([obj objectForKey:@"content"]){
        [muDic setObject:[obj objectForKey:@"content"] forKey:@"content"];
    }
    if([obj objectForKey:@"avatarLM"]){
        [muDic setObject:[obj objectForKey:@"avatarLM"] forKey:@"avatarLM"];
    }
    return muDic;
}

@end
