
//
//  myConcernedDAODelegate.h
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef myConcernedDAODelegate_h
#define myConcernedDAODelegate_h

@protocol myConcernedDAODelegate
@optional

-(void)myConcernedDataRequestFinishedDAO:(NSArray *)arr;
-(void)myConcernedDataRequestFailedDAO:(NSError *)error;
-(void)myCocnernedDataRequestNODataDAO:(BOOL)value;
@end

#endif /* myConcernedDAODelegate_h */
