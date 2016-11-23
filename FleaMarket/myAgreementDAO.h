//
//  myAgreementDAO.h
//  FleaMarket
//
//  Created by Hou on 17/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myAgreementDAODelegate.h"

@interface myAgreementDAO : NSObject

@property(nonatomic, strong)id<myAgreementDAODelegate> delegate;

+(myAgreementDAO *)sharedManager;

-(void)requestAgreementFromSeverDAO;
@end
