
//
//  myAgreementBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 17/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef myAgreementBLDelegate_h
#define myAgreementBLDelegate_h
@protocol myAgreementBLDelegate
@optional

-(void)myAgreementDataRequestFinishedBL:(NSMutableDictionary *)mudic;
-(void)myAgreementDataRequestFailedBL:(NSError *)error;
-(void)myAgreementDataRequestNODataBL:(BOOL)value;

@end

#endif /* myAgreementBLDelegate_h */
