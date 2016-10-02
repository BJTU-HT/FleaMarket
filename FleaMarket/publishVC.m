//
//  publishVC.m
//  FleaMarket
//
//  Created by Hou on 4/7/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Photos/Photos.h>
#import "publishVC.h"
#import "RXRotateButtonOverlayView.h"
#import "CollectionDataModel.h"
#import "ImagePickerVC.h"
#import "PublishSecondhandVC.h"
#import "UploadImageModel.h"

@interface publishVC () <RXRotateButtonOverlayViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) RXRotateButtonOverlayView *overlayView;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *collectionData;

@end

@implementation publishVC

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self.view addSubview:self.overlayView];
    [self.overlayView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.title = @"发布";
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


#pragma mark **************** RXRotateButtonOverlayViewDelegate *******************
- (void)didSelected:(NSUInteger)index
{
    NSLog(@"clicked %zd btn", index);
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if (index == 0) {
        // 0 就是选择相机拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //PublishDetailVC *publishDetailVC = [[PublishDetailVC alloc] init];
            //PublishSecondhandVC *publishDetailVC = [[PublishSecondhandVC alloc] init];
            imagePicker.delegate = self;
            imagePicker.showsCameraControls = YES;
            
            // 以模态的形式显示UIImagePickerController对象
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    } else {
        // 1 就是从相册中选择
        
        for (CollectionDataModel *model in _collectionData) {
            model.selected = NO;
        }
        
        ImagePickerVC *imgPickVC = [[ImagePickerVC alloc] init];
        imgPickVC.assetCollection = _tableData[0];
        imgPickVC.tableData  = [[NSMutableArray alloc] initWithArray:_tableData];
        imgPickVC.collectionData = [[NSMutableArray alloc] initWithArray:_collectionData];
        imgPickVC.hidesBottomBarWhenPushed = YES;     // 隐藏Bottom的Bar
        [self.navigationController pushViewController:imgPickVC animated:YES];
    }
    
}

#pragma mark --------------- UIImagePickerControllerDelegate ---------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [[UIImage alloc] init];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image) {
        // 保存图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
        }
        
        NSMutableArray *choosedImageArray = [[NSMutableArray alloc] init];
        UploadImageModel *uploadModel = [[UploadImageModel alloc] init];
        uploadModel.img = image;
        uploadModel.isUploaded = NO;
        [choosedImageArray addObject:uploadModel];
        
        [picker dismissViewControllerAnimated:NO completion:^{
            //[self.myCollectionView reloadData];
            PublishSecondhandVC *publishDetailVC = [[PublishSecondhandVC alloc] init];
            publishDetailVC.selectedImgArray = choosedImageArray;
            [self.navigationController pushViewController:publishDetailVC animated:YES];
        }];
    }
}


#pragma mark ---------------- action ----------------

#pragma mark ---------------- getter & setter -----------------------
- (RXRotateButtonOverlayView *)overlayView
{
    if (_overlayView == nil) {
        _overlayView = [[RXRotateButtonOverlayView alloc] init];
        [_overlayView setTitles:@[@"拍照", @"相册"]];
        //[_overlayView setTitles:@[@"相册"]];
        [_overlayView setTitleImages:@[@"ic_mine_want@2x.png", @"ic_mine_order@2x.png"]];
        //[_overlayView setTitleImages:@[@"ic_mine_order@2x.png"]];
        [_overlayView setDelegate:self];
        [_overlayView setFrame:self.view.bounds];
    }
    
    return _overlayView;
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
