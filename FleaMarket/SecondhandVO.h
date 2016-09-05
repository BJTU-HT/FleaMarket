//
//  SecondhandVO.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecondhandVO : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIconImage;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *sex;

@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic) float nowPrice;
@property (nonatomic) float originalPrice;
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic) int skimTimes;
@property (nonatomic) NSInteger praiseTimes;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSString *buyerID;

@property (nonatomic, strong) NSString *mainCategory;
@property (nonatomic, strong) NSString *viceCategory;
@property (nonatomic, strong) NSMutableArray *visitorURLArray;

// 下载到的图片组
@property (nonatomic, strong) NSMutableArray *downLoadPicArray;

// 从plist读取数据
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
