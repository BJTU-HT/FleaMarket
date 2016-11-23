//
//  myAgreementBL.h
//  FleaMarket
//
//  Created by Hou on 17/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myAgreementDAODelegate.h"
#import "myAgreementBLDelegate.h"

@interface myAgreementBL : NSObject<myAgreementDAODelegate>

@property(nonatomic, strong)id<myAgreementBLDelegate> delegate;

+(myAgreementBL *)sharedManager;

-(void)requestAgreementFromSeverBL;
@end
