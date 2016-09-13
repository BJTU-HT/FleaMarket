
//
//  concernDAODelegate.h
//  FleaMarket
//
//  Created by Hou on 9/6/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef concernDAODelegate_h
#define concernDAODelegate_h
@protocol concernDAODelegate
@optional

-(void)concernedUserUploadFailedDAO:(NSError *)error;
-(void)concernedUserUploadFinishedDAO:(BOOL)value;

-(void)concernedDataRequestFinishedDAO:(NSArray *)arr;
-(void)concernedDataRequestFailedDAO:(NSError *)error;
-(void)cocnernedDataRequestNODataDAO:(BOOL)value;
@end

#endif /* concernDAODelegate_h */
