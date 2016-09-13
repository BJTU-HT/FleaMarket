
//
//  myConcernedBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef myConcernedBLDelegate_h
#define myConcernedBLDelegate_h
@protocol myConcernedBLDelegate
@optional

-(void)myConcernedDataRequestFinishedBL:(NSArray *)arr;
-(void)myConcernedDataRequestFailedBL:(NSError *)error;
-(void)myCocnernedDataRequestNODataBL:(BOOL)value;
@end

#endif /* myConcernedBLDelegate_h */
