
//
//  mySellDAODelegate.h
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef mySellDAODelegate_h
#define mySellDAODelegate_h
@protocol mySellDAODelegate
@optional

-(void)sellGoodsInfoSearchFinishedDAO:(NSMutableArray *)arr;

-(void)sellGoodsInfoSearchFailedDAO:(NSError *)error;

-(void)sellGoodsInfoSearchFinishedNoDataDAO:(BOOL)value;
@end

#endif /* mySellDAODelegate_h */
