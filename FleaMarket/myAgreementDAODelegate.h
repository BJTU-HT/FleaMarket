
//
//  myAgreementDAODelegate.h
//  FleaMarket
//
//  Created by Hou on 17/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef myAgreementDAODelegate_h
#define myAgreementDAODelegate_h
@protocol myAgreementDAODelegate
@optional

-(void)myAgreementDataRequestFinishedDAO:(NSMutableDictionary *)mudic;
-(void)myAgreementDataRequestFailedDAO:(NSError *)error;
-(void)myAgreementDataRequestNODataDAO:(BOOL)value;

@end


#endif /* myAgreementDAODelegate_h */
