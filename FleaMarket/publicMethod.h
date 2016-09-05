//
//  publicMethod.h
//  TestDemo1
//
//  Created by Hou on 2/25/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface publicMethod : NSObject

-(UIImage *)circleImage:(UIImage *) image withParam:(CGFloat) inset;
-(CGFloat)calculateFontForButtonOrLabel:(CGFloat)width high:(CGFloat)height;
//图片高斯模糊处理
-(UIImage *)blurredPicture:(UIImage *)image;
@end
