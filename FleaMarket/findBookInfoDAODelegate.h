
//
//  findBookInfoDAODelegate.h
//  FleaMarket
//
//  Created by Hou on 8/1/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef findBookInfoDAODelegate_h
#define findBookInfoDAODelegate_h

@protocol findBookInfoDAODelegate
@optional

-(void)searchBookInfoFailedDAO:(NSError *)error;
-(void)searchBookInfoFinishedDAO:(NSMutableArray *)arr;
-(void)searchBookInfoFinishedNODataDAO:(NSString *)str;

-(void)searchBookInfoFromSearchDAO:(NSMutableArray *)arr;
////上传图片失败
//-(void)uploadPicFailDAO:(NSError *)error;
//
////上传图书信息成功 失败
//-(void)uploadBookInfoFinishedDAO:(BOOL)isSuccessful;
//-(void)uploadBookInfoFailedDAO:(NSError*)error;

@end
#endif /* findBookInfoDAODelegate_h */
