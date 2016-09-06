
//
//  bookPubUpLoadInfoDAODelegate.h
//  FleaMarket
//
//  Created by Hou on 7/27/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef bookPubUpLoadInfoDAODelegate_h
#define bookPubUpLoadInfoDAODelegate_h
@protocol bookPubUpLoadInfoDAODelegate
@optional

//上传图片失败
-(void)uploadPicFailDAO:(NSError *)error;

//上传图书信息成功 失败
-(void)uploadBookInfoFinishedDAO:(BOOL)isSuccessful;
-(void)uploadBookInfoFailedDAO:(NSError*)error;

@end

#endif /* bookPubUpLoadInfoDAODelegate_h */
