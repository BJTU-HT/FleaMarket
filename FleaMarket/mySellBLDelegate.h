
//
//  mySellBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef mySellBLDelegate_h
#define mySellBLDelegate_h
@protocol mySellBLDelegate
@optional

-(void)sellGoodsInfoSearchFinishedBL:(NSMutableArray *)arr;

-(void)sellGoodsInfoSearchFailedBL:(NSError *)error;

-(void)sellGoodsInfoSearchFinishedNoDataBL:(BOOL)value;
@end
#endif /* mySellBLDelegate_h */
