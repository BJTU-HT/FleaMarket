//
//  publishVC.m
//  FleaMarket
//
//  Created by Hou on 4/7/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <BmobSDK/BmobUser.h>
#import "publishVC.h"
#import "RXRotateButtonOverlayView.h"
#import "CollectionDataModel.h"
#import "ImagePickerVC.h"
#import "PublishSecondhandVC.h"
#import "UploadImageModel.h"
#import "UserInfoSingleton.h"
#import "logInViewController.h"

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
    
    // 首次打开相册，触发相册授权，trick，111123444
    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    UserMO *userMO = [UserInfoSingleton sharedManager].userMO;
    if(userMO == nil){
        logInViewController *logIn = [[logInViewController alloc] init];
        [self.navigationController pushViewController:logIn animated:NO];
        /*
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论必须登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
         */
    }

    //2016 1107 10:02 add by hou
    /*
    BmobUser *curUser = [BmobUser getCurrentUser];
    if(!curUser){
        logInViewController *logIn = [[logInViewController alloc] init];
        [self.navigationController pushViewController:logIn animated:NO];
    }
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.title = @"发布";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------- 检查相册和相机是否可用 ------------------
/**
 *  调用系统相机
 */
- (void)callCamera
{
    //判断是否已授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusRestricted) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置->隐私->相机授权应用拍照权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *aa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:aa];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:ac animated:YES completion:nil];
            });
        }
    }
}

/**
 *  调用系统相册
 */
- (void)callPhoto
{
    //判断是否已授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus == AVAuthorizationStatusDenied) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置->隐私->相册授权应用访问相册权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *aa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:aa];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:ac animated:YES completion:nil];
            });
        }
        
    }
}

#pragma mark ---------------- private ----------------------

// 获取所有的相册
- (void)getPhotoAssetCollections
{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus != PHAuthorizationStatusAuthorized) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置->隐私->相册授权应用访问相册权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *aa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:aa];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:ac animated:YES completion:nil];
        });
    } else {
        // 获得相机胶卷
        PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        [self.tableData addObject:assetCollection];
        
        // 遍历所有的自定义相簿
        PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        for (PHAssetCollection *assetCollection in assetCollections) {
            [self.tableData addObject:assetCollection];
        }
        
        if ([self.tableData count]) {
            [self getCollectionData:0];
        }
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
            imagePicker.delegate = self;
            imagePicker.showsCameraControls = YES;
            
            // 以模态的形式显示UIImagePickerController对象
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    } else {
        // 1 就是从相册中选择
        [self getPhotoAssetCollections];
        
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
