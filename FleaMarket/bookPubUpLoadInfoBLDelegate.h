
//
//  bookPubUpLoadInfoBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 7/27/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef bookPubUpLoadInfoBLDelegate_h
#define bookPubUpLoadInfoBLDelegate_h
@protocol bookPubUpLoadInfoBLDelegate
@optional

//上传图片失败
-(void)uploadPicFailBL:(NSError *)error;

//上传图书信息成功 失败
-(void)uploadBookInfoFinishedBL:(BOOL)isSuccessful;
-(void)uploadBookInfoFailedBL:(NSError *)error;

@end


#endif /* bookPubUpLoadInfoBLDelegate_h */
