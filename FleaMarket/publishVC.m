//
//  publishVC.m
//  FleaMarket
//
//  Created by Hou on 4/7/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "publishVC.h"
#import "RXRotateButtonOverlayView.h"
#import "PublishDetailVC.h"
#import "CollectionDataModel.h"
#import "ImagePickerVC.h"

@interface publishVC () <RXRotateButtonOverlayViewDelegate>

@property (nonatomic, strong) RXRotateButtonOverlayView *overlayView;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic , strong) ALAssetsGroup * group;

@property (nonatomic, strong) NSMutableArray *tableData;

@property (nonatomic, strong) NSMutableArray *collectionData;

@end

@implementation publishVC

- (void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:self.overlayView];
    [self.overlayView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self getPhotoAssetCollections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark ---------------- private ----------------------

// 获取所有的相册
- (void)getPhotoAssetCollections
{
    // 获得相机胶卷
    PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self.tableData addObject:assetCollection];
    
    // 遍历所有的自定义相簿
    PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self.tableData addObject:assetCollection];
    }

    //[self enumerateAssetsInAssetCollection:assetCollection2 original:YES];
    
    if ([self.tableData count]) {
        [self getCollectionData:0];
    }
}

// 获取胶卷相册的所有图片
- (void)getCollectionData:(NSInteger)tag
{
    if (self.collectionData.count) {
        [self.collectionData removeAllObjects];
    }
    
    // 将“拍照”照片添加入collectionData
    CollectionDataModel *dataModel = [[CollectionDataModel alloc] init];
    dataModel.img = [UIImage imageNamed:@"takePicture.png"];
    [self.collectionData addObject:dataModel];
    
    // 将相机胶卷assetCollection的内容加入到collectionData中
    [self enumerateAssetsInAssetCollection:self.tableData[tag] original:YES];
}

- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection
                                original:(BOOL)original
{
    NSLog(@"相册名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    // 获得某个相册薄中的所有PHAsset对象
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            [assets addObject:obj];
        }
    }];
    
    /*
    PHCachingImageManager *cachingManager = [[PHCachingImageManager alloc] init];
    [cachingManager startCachingImagesForAssets:assets targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil];
     */
    
    for (PHAsset *asset in assets) {
        CollectionDataModel *dataModel = [[CollectionDataModel alloc] init];
        dataModel.asset = asset;
        dataModel.selected = NO;
        [self.collectionData addObject:dataModel];
    }
}


/*
- (void)getTableDate {
    
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        if(assetsGroup) {
            [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            NSMutableArray * isChoosenArray = [[NSMutableArray alloc]init];
            if(assetsGroup.numberOfAssets > 0) {
                [self.tableData addObject:assetsGroup];
                for (int i = 0; i<assetsGroup.numberOfAssets; i++) {
                    [isChoosenArray addObject:[NSNumber numberWithBool:NO]];
                }
                //[self.isChoosenDic setObject:isChoosenArray forKey:[assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
                //[self setTableViewHeight];
            }
            NSLog(@"block is called!");
        }
        //[myTableView reloadData];
        [self getCollectionData:0];
        //[myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    };
    
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    // Enumerate Camera Roll
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Photo Stream
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Album
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Event
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Faces
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
}
 */

/*
- (void)getCollectionData:(NSInteger)tag {
    if (self.collectionData.count) {
        [self.collectionData removeAllObjects];
    }
    
    CollectionDataModel *dataModel = [[CollectionDataModel alloc] init];
    dataModel.img = [UIImage imageNamed:@"takePicture.png"];
    [self.collectionData addObject:dataModel];
    if (self.tableData.count) {
        self.group = [self.tableData objectAtIndex:tag];
        [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                NSString *type=[result valueForProperty:ALAssetPropertyType];
                if ([type isEqualToString:ALAssetTypePhoto]) {
                    CollectionDataModel *dataModel = [[CollectionDataModel alloc] init];
                    dataModel.img = [UIImage imageWithCGImage:[result aspectRatioThumbnail]];
                    dataModel.selected = NO;
                    [self.collectionData addObject:dataModel];
                    //[self.originImgData addObject:result];
                }
                //[self.myCollectionView reloadData];
            }
        }];
    }
}
*/

#pragma mark **************** RXRotateButtonOverlayViewDelegate *******************
- (void)didSelected:(NSUInteger)index
{
    NSLog(@"clicked %zd btn", index);
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (index == 0) {
        // 0 就是选择相机拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            PublishDetailVC *publishDetailVC = [[PublishDetailVC alloc] init];
            imagePicker.delegate = publishDetailVC;
            
            // 以模态的形式显示UIImagePickerController对象
            [self presentViewController:imagePicker animated:YES completion:^{
                [self.navigationController pushViewController:publishDetailVC animated:YES];
            }];
        }
        
    } else {
        // 1 就是从相册中选择
        ImagePickerVC *imgPickVC = [[ImagePickerVC alloc] init];
        imgPickVC.assetCollection = _tableData[0];
        imgPickVC.tableData  = [[NSMutableArray alloc] initWithArray:_tableData];
        imgPickVC.collectionData = [[NSMutableArray alloc] initWithArray:_collectionData];
        imgPickVC.hidesBottomBarWhenPushed = YES;     // 隐藏Bottom的Bar
        [self.navigationController pushViewController:imgPickVC animated:YES];
    }
}


#pragma mark ---------------- action ----------------

#pragma mark ---------------- getter & setter -----------------------
- (RXRotateButtonOverlayView *)overlayView
{
    if (_overlayView == nil) {
        _overlayView = [[RXRotateButtonOverlayView alloc] init];
        [_overlayView setTitles:@[@"拍照", @"相册"]];
        [_overlayView setTitleImages:@[@"ic_mine_want@2x.png", @"ic_mine_order@2x.png"]];
        [_overlayView setDelegate:self];
        [_overlayView setFrame:self.view.bounds];
    }
    
    return _overlayView;
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _assetsLibrary;
}

- (NSMutableArray *)tableData
{
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] init];
    }
    
    return _tableData;
}

- (NSMutableArray *)collectionData
{
    if (!_collectionData) {
        _collectionData = [[NSMutableArray alloc] init];
    }
    
    return _collectionData;
}

@end
