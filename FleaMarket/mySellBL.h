//
//  mySellBL.h
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mySellBLDelegate.h"
#import "mySellDAODelegate.h"

@interface mySellBL : NSObject<mySellDAODelegate>

@property (nonatomic, weak)id<mySellBLDelegate> delegate;

-(void)getSellGoodsInfoBL:(NSString *)userName;
+(mySellBL *)sharedManager;
@end
