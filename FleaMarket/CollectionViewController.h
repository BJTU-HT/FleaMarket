//
//  CollectionViewController.h
//  test123
//
//  Created by tom555cat on 16/5/25.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReloadAssetDelegate

//- (void)reloadAsset:(NSInteger)row;

- (void)reloadCollectionData:(NSMutableArray *)collectionData
        assetCollectionIndex:(NSInteger)assetCollectionIndex;

@end

@interface CollectionViewController : UIViewController

@property (nonatomic, weak) id <ReloadAssetDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *tableData;

//@property (nonatomic, strong) NSMutableArray *collectionData;
//@property (nonatomic, strong) NSMutableArray *ori

@end
