
//
//  concernBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 9/6/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef concernBLDelegate_h
#define concernBLDelegate_h
@protocol concernBLDelegate
@optional

-(void)concernedUserUploadFailedBL:(NSError *)error;
-(void)concernedUserUploadFinishedBL:(BOOL)value;

//从用户表获取用户所关注的人
-(void)concernedDataRequestFinishedBL:(NSArray *)arr;
-(void)concernedDataRequestFailedBL:(NSError *)error;
-(void)cocnernedDataRequestNODataBL:(BOOL)value;
@end

#endif /* concernBLDelegate_h */
