
//
//  findBookInfoBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 8/1/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef findBookInfoBLDelegate_h
#define findBookInfoBLDelegate_h

@protocol findBookInfoBLDelegate
@optional

-(void)searchBookInfoFailedBL:(NSError *)error;
-(void)searchBookInfoFinishedBL:(NSMutableArray *)arr;
-(void)searchBookInfoFinishedNODataBL:(NSString *)str;
//search book from serch bar
-(void)searchBookInfoFromSearchBL:(NSMutableArray *)arr;
@end

#endif /* findBookInfoBLDelegate_h */
