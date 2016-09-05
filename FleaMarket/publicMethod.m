//
//  publicMethod.m
//  TestDemo1
//
//  Created by Hou on 2/25/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import "publicMethod.h"
#import "pinyin.h"
#import "ChineseString.h"

@implementation publicMethod

-(CGFloat)calculateFontForButtonOrLabel:(CGFloat)width high:(CGFloat)height
{
    CGFloat temp;
    if(width < height)
    {
        temp = (width / 96) * 72;
        temp -= 2;//根据实际测试，在label中的字号要比计算的小2pt才能正常显示
    }
    else
    {
        temp = (height / 96) * 72;
        temp -= 2;
    }
    return temp;
}

//图片圆形裁剪
-(UIImage *)circleImage:(UIImage *) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,0); //边框线
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

//图片高斯模糊处理
-(UIImage *)blurredPicture:(UIImage *)image
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *imageProduct = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return imageProduct;
}

//获取拼音首字母
-(NSMutableArray *)getChineseStringArr:( NSMutableArray *)arrToSort sectionHeadKeys:(NSMutableArray *)_sectionHeadsKeys
{
    // 创建一个临时的变动数组
    NSMutableArray *chineseStringsArray = [ NSMutableArray array ];
    for ( int i = 0 ; i < [arrToSort count ]; i++)
    {
        // 创建一个临时的数据模型对象
        ChineseString *chineseString=[[ChineseString alloc] init];
        // 给模型赋值
        chineseString.string = [ NSString stringWithString :[arrToSort objectAtIndex :i]];
        if (chineseString.string == nil )
        {
            chineseString.string = @"";
        }
        if (![chineseString. string isEqualToString : @"" ])
        {
            //join( 链接 ) the pinYin (letter 字母 )  链接到首字母
            NSString *pinYinResult = [ NSString string ];
            // 按照数据模型中 row 的个数循
            for ( int j = 0 ;j < chineseString. string . length ; j++)
            {
                NSString *singlePinyinLetter = [[ NSString stringWithFormat : @"%c" ,
                                                 pinyinFirstLetter ([chineseString.string characterAtIndex :j])] uppercaseString ];
                pinYinResult = [pinYinResult stringByAppendingString :singlePinyinLetter];
            }
            chineseString. pinYin = pinYinResult;
        }
        else
        {
            chineseString. pinYin = @"" ;
        }
        [chineseStringsArray addObject :chineseString];
    }
    //sort( 排序 ) the ChineseStringArr by pinYin( 首字母 )
    NSArray *sortDescriptors = [ NSArray arrayWithObject :[ NSSortDescriptor sortDescriptorWithKey : @"pinYin" ascending : YES ]];
    [chineseStringsArray sortUsingDescriptors :sortDescriptors];
    NSMutableArray *arrayForArrays = [ NSMutableArray array ];
    BOOL checkValueAtIndex= NO ;  //flag to check
    NSMutableArray *TempArrForGrouping = nil ;
    for ( int index = 0 ; index < [chineseStringsArray count ]; index++)
    {
        ChineseString *chineseStr = ( ChineseString *)[chineseStringsArray objectAtIndex :index];
        NSMutableString *strchar= [ NSMutableString stringWithString :chineseStr. pinYin ];
        NSString *sr= [strchar substringToIndex : 1 ];
        //sr containing here the first character of each string  ( 这里包含的每个字符串的第一个字符 )
        //NSLog ( @"%@" ,sr);
        //here I'm checking whether the character already in the selection header keys or not  ( 检查字符是否已经选择头键 )
        if (![ _sectionHeadsKeys containsObject :[sr uppercaseString ]])
        {
            [ _sectionHeadsKeys addObject :[sr uppercaseString ]];
            TempArrForGrouping = [[ NSMutableArray alloc ] init];
            checkValueAtIndex = NO;
        }
        if ([ _sectionHeadsKeys containsObject :[sr uppercaseString ]])
        {
            [TempArrForGrouping addObject :[chineseStringsArray objectAtIndex :index]];
            if (checkValueAtIndex == NO )
            {
                [arrayForArrays addObject :TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

@end
