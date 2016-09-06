//
//  mySellDAO.h
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mySellDAODelegate.h"

@interface mySellDAO : NSObject

@property(nonatomic, strong) NSMutableArray *tempMuArr;
@property(nonatomic, strong) NSMutableArray *recMuArr;
@property(nonatomic, strong) NSMutableDictionary *recMudic;
@property (weak, nonatomic) id<mySellDAODelegate> delegate;

+(mySellDAO *)sharedManager;
-(void)getSellGoodsInfoDAO:(NSString *)userName;
@end
