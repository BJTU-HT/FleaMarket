//
//  ImagePickerVC.m
//  test123
//
//  Created by tom555cat on 16/5/23.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "ImagePickerVC.h"
#import "ImagePickerCollectionViewCell.h"
#import "YBImgPickerViewCell.h"
#import "PreViewController.h"
#import "CollectionViewController.h"
#import "PhotoCollectionViewFlow.h"
#import "ThumbnailCollectionViewCell.h"
#import "SelectedPhotoCollectionViewLayout.h"
#import "CollectionDataModel.h"
#import "PublishDetailVC.h"
#import "PublishSecondhandVC.h"
#import "UploadImageModel.h"
#import "NormalCollectionViewFlow.h"


#define empty_width 3
#define maxnum_of_one_line 3
#define itemHeight ( CGRectGetWidth([UIScreen mainScreen].bounds) - (maxnum_of_one_line + 1) * empty_width ) / maxnum_of_one_line
#define item_Size CGSizeMake(itemHeight , itemHeight)

#define WIDTH_PIC self.view.frame.size.width
#define HEIGHT_PIC    self.view.frame.size.height

// 最多上传9张照片
const NSInteger photoCounts = 9;

@interface ImagePickerVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ReloadAssetDelegate, SelectedArrayDelegate, DeleteSelectedImgDelegate>

@property (nonatomic, strong) NSMutableDictionary *isChoosenDic;

@property (nonatomic, strong) NSMutableArray *originImgData;

@property (nonatomic, strong) UICollectionView *myCollectionView;

// 当前选择的照片数量
@property (nonatomic, assign) NSInteger chooseCount;

// 已经选择的照片
@property (nonatomic, strong) NSMutableDictionary *choosenImgArray;

// 提交选择图片的按钮
@property (nonatomic, strong) UIButton *toolBarRightBtn;

// 预览选择图片的
@property (nonatomic, strong) UIButton *toolBarLeftBtn;

// 选中的缩略图
@property (nonatomic, strong) UICollectionView *thumbnailCollectionView;

@end

@implementation ImagePickerVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCollectionView];
    [self setupNavBar];
    [self setupToolBar];
}

#pragma mark --------------- private ---------------

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupCollectionView
{
    CGSize winSize = [UIScreen mainScreen].bounds.size;

    UICollectionView *myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height) collectionViewLayout:[[PhotoCollectionViewFlow alloc] init]];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [myCollectionView registerNib:[UINib nibWithNibName:@"YBImgPickerViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectioncell"];
    [self.view addSubview:myCollectionView];
    self.myCollectionView = myCollectionView;
}

- (void)setupNavBar
{
    UIBarButtonItem *assetCollectionsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showTableView)];
    UINavigationItem *item = self.navigationItem;
    item.rightBarButtonItem = assetCollectionsBtn;
    
}

- (void)setupToolBar
{
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    
    // 工具条主界面
    UIView *toolBarBGView = [[UIView alloc] initWithFrame:CGRectMake(0, winSize.height - 64, winSize.width, 64)];
    toolBarBGView.backgroundColor = [UIColor colorWithRed:0.97 green:0.98 blue:1 alpha:1];
    [self.view addSubview:toolBarBGView];
    
    // 工具条左按钮
    self.toolBarLeftBtn = [self createBtnWithTitle:@"预览" andBackIMG:nil andTitleColor:[UIColor colorWithRed:225/255.0 green:33/255.0 blue:64/255.0 alpha:1] andSelectedTitleColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] andTarget:@selector(toolBarLeftBtnClick) andFram:CGRectMake(5, 0, 80, 44)];
    self.toolBarLeftBtn.selected  = YES;
    [toolBarBGView addSubview:self.toolBarLeftBtn];
    
    SelectedPhotoCollectionViewLayout *collectionLayout = [[SelectedPhotoCollectionViewLayout alloc] init];
    UICollectionView *thumbnailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    thumbnailCollectionView.frame = CGRectMake(10, 0, winSize.width * 0.6f, 64);
    thumbnailCollectionView.delegate = self;
    thumbnailCollectionView.dataSource = self;
    [thumbnailCollectionView registerNib:[UINib nibWithNibName:@"ThumbnailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"thumbnailcollectioncell"];
    self.thumbnailCollectionView = thumbnailCollectionView;
    self.thumbnailCollectionView.backgroundColor = toolBarBGView.backgroundColor;
    [toolBarBGView addSubview:self.thumbnailCollectionView];
    
    // 工具条右按钮
    CGFloat btnH = 30;
    CGFloat btnW = 60;
    CGFloat btnX = WIDTH_PIC - 70;
    CGFloat btnY = toolBarBGView.frame.size.height / 2.0f - btnH / 2.0f;
    self.toolBarRightBtn = [self createBtnWithTitle:@"确定" andBackIMG:nil andTitleColor:[UIColor whiteColor] andSelectedTitleColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] andTarget:@selector(toolBarRightBtnClick) andFram:CGRectMake(btnX, btnY, btnW, btnH)];
    self.toolBarRightBtn.layer.cornerRadius     = 3;
    self.toolBarRightBtn.layer.masksToBounds    = YES;
    self.toolBarRightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.toolBarRightBtn.selected = YES;
    self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.94 alpha:1];
    [toolBarBGView addSubview:self.toolBarRightBtn];
    
    // 设置按钮文字
    if (self.selectedArray.count) {
        [self.toolBarRightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] forState:UIControlStateNormal];
    } else {
        [self.toolBarRightBtn setTitle:@"确定" forState:UIControlStateSelected];
    }
}

- (UIButton*)createBtnWithTitle:(NSString*)title andBackIMG:(NSString*)name andTitleColor:(UIColor*)color andSelectedTitleColor:(UIColor*)selectTitleColor andTarget:(SEL)clickAction andFram:(CGRect)rect{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn addTarget:self action:clickAction forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:selectTitleColor forState:UIControlStateSelected];
    
    return btn;
    
}

/*
- (void)getTableDate {
}

- (void)getCollectionData:(NSInteger)tag {
 
}
*/

//修正>2M的图片方向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark --------------- action -----------------
- (void)showTableView
{
    CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
    collectionVC.tableData = self.tableData;
    collectionVC.delegate = self;
    [self.navigationController pushViewController:collectionVC animated:YES];
    
    /*
    if ([self.myCollectionView.collectionViewLayout isKindOfClass:[PhotoCollectionViewFlow class]]) {
        self.collectionData = [self test];
        [self.myCollectionView reloadData];    // 一定要加上reloadData
        [self.myCollectionView setCollectionViewLayout:[[NormalCollectionViewFlow alloc] init] animated:YES];
    } else {
        PhotoCollectionViewFlow *layout1 = [[PhotoCollectionViewFlow alloc] init];
        [self.myCollectionView setCollectionViewLayout:layout1 animated:YES];
    }
     */
}

/*
- (NSMutableArray *)test
{
    // 传递回去的当前相册集的collectionData
    NSMutableArray *collectionData1 = [[NSMutableArray alloc] init];
    
    PHAssetCollection *assetCollection = self.tableData[1];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            [assets addObject:obj];
        }
    }];
    
    PHCachingImageManager *cachingManager = [[PHCachingImageManager alloc] init];
    [cachingManager startCachingImagesForAssets:assets targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil];
    
    for (PHAsset *asset in assets) {
        CollectionDataModel *dataModel = [[CollectionDataModel alloc] init];
        dataModel.asset = asset;
        dataModel.selected = NO;
        [collectionData1 addObject:dataModel];
    }
    
    return collectionData1;
}
 */

// 提交选择的图片
- (void)toolBarRightBtnClick
{
    if (self.delegate) {
        //[self.delegate addMoreImg:self.collectionData];
        [self.delegate addMoreImg:self.selectedArray];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 获取选中的图片
        NSMutableArray *choosedImageArray = [[NSMutableArray alloc] init];
        /*
        for (int i = 1; i < self.collectionData.count; i++) {                // 从1开始，因为第0张是个拍照图标
            CollectionDataModel *model = self.collectionData[i];
            if (model.selected == YES) {
                UploadImageModel *uploadModel = [[UploadImageModel alloc] init];
                // 获取照片资源
                PHImageManager *imageManager = [PHImageManager defaultManager];
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.synchronous = YES;
                [imageManager requestImageForAsset:model.asset
                                        targetSize:PHImageManagerMaximumSize
                                       contentMode:PHImageContentModeDefault
                                           options:options
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         uploadModel.img = result;
                                         uploadModel.isUploaded = NO;
                                         [choosedImageArray addObject:uploadModel];
                }];
            }
        }
         */
        for (NSInteger idx = 0; idx < self.selectedArray.count; idx++) {
            CollectionDataModel *model = self.selectedArray[idx];
            UploadImageModel *uploadModel = [[UploadImageModel alloc] init];
            if (model.asset) {
                // 获取照片资源
                PHImageManager *imageManager = [PHImageManager defaultManager];
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.synchronous = YES;
                [imageManager requestImageForAsset:model.asset
                                        targetSize:PHImageManagerMaximumSize
                                       contentMode:PHImageContentModeDefault
                                           options:options
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         uploadModel.img = result;
                                         uploadModel.isUploaded = NO;
                                         [choosedImageArray addObject:uploadModel];
                }];
            } else if (model.img) {
                uploadModel.img = model.img;
                uploadModel.isUploaded = NO;
                [choosedImageArray addObject:uploadModel];
            }
        }
        
        /*
        PublishDetailVC *publishDetailVC = [[PublishDetailVC alloc] init];
        publishDetailVC.selectedImgArray = choosedImageArray;
        publishDetailVC.delegate = self;
         */
        
        PublishSecondhandVC *publishDetailVC = [[PublishSecondhandVC alloc] init];
        publishDetailVC.selectedImgArray = choosedImageArray;
        publishDetailVC.delegate = self;
        
        [self.navigationController pushViewController:publishDetailVC animated:YES];
    }
}

// 预览选择的图片
- (void)toolBarLeftBtnClick
{

}

#pragma mark --------------- DeleteSelectedImgDelegate ---------------
// 当发布二手商品后或撤销二手商品发布，重置图片选中状态
- (void)deleteSelectedImgs
{
    for (long i = 0; i < self.collectionData.count; i++) {
        CollectionDataModel *model = self.collectionData[i];
        model.selected = NO;
    }
}

#pragma mark --------------- CollectionViewDelegate --------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.myCollectionView) {
        return 1;
    } else if (collectionView == self.thumbnailCollectionView){
        return 1;
    } else {
        return 0;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%ld", self.collectionData.count);
    //return self.collectionData.count;
    
    if (collectionView == self.myCollectionView) {
        return self.collectionData.count;
    } else if (collectionView == self.thumbnailCollectionView) {
        return self.selectedArray.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.myCollectionView) {
        YBImgPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
        
        CollectionDataModel *data = [self.collectionData objectAtIndex:indexPath.item];
        PHAsset *asset = data.asset;

        __weak ImagePickerVC *weakSelf = self;
        cell.selectedBlock = ^(BOOL select){
            if (select) {
                [weakSelf.selectedArray addObject:data];
                
                // 对应的collectionData的selected设置为true
                for (int i = 1; i < weakSelf.collectionData.count; i++) {
                    CollectionDataModel *model = weakSelf.collectionData[i];
                    if (model.asset == asset) {
                        model.selected = YES;
                        break;
                    }
                }
                
                NSLog(@"selected Array number is %ld", self.selectedArray.count);
                [weakSelf.thumbnailCollectionView reloadData];
                [weakSelf.thumbnailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.selectedArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
            } else {
                [weakSelf.selectedArray removeObject:data];
                
                for (int i = 1; i < weakSelf.collectionData.count; i++) {
                    CollectionDataModel *model = weakSelf.collectionData[i];
                    if (model.asset == asset) {
                        model.selected = NO;
                        break;
                    }
                }
                
                [weakSelf.thumbnailCollectionView reloadData];
            }
            if (weakSelf.selectedArray.count) {
                weakSelf.toolBarRightBtn.selected = NO;
                weakSelf.toolBarLeftBtn.selected = NO;
                [weakSelf.toolBarRightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] forState:UIControlStateNormal];
                weakSelf.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:225/255.0 green:33/255.0 blue:64/255.0 alpha:1];
            } else {
                weakSelf.toolBarRightBtn.selected = YES;
                weakSelf.toolBarLeftBtn.selected = YES;
                self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.94 alpha:1];
            }
        };
        
        // 设置cell的asset
        cell.asset = asset;
        //NSArray *isChoosenArray = [self.isChoosenDic objectForKey:[self.group valueForProperty:ALAssetsGroupPropertyName]];
        
        // 如果CollectionDataModel的image有内容，则它是一张拍照图片
        if (data.img) {
            cell.isChoosenBtnHidden = YES;
            cell.contentImg = data.img;
        } else {
            cell.isChoosenBtnHidden = NO;
    
            CollectionDataModel *model = [self.collectionData objectAtIndex:indexPath.item];
            if (model.selected) {
                cell.isChoosenBtnSelected = YES;
            } else {
                cell.isChoosenBtnSelected = NO;
            }
        }
        
        return cell;
        
    } else if (collectionView == self.thumbnailCollectionView) {
        ThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"thumbnailcollectioncell" forIndexPath:indexPath];
        __weak ImagePickerVC *weakSelf = self;
        __weak ThumbnailCollectionViewCell *weakCell = cell;
        CollectionDataModel *data = [self.selectedArray objectAtIndex:indexPath.item];
        //PHAsset *asset = [self.selectedArray objectAtIndex:indexPath.item];
        cell.model = data;
        
        cell.dropSelectedBlock = ^(void) {
            //PHAsset *asset = weakCell.asset;
            CollectionDataModel *data = weakCell.model;
            [weakSelf.selectedArray removeObject:data];
            
            // 将collectionData中对应图片的selected设置为NO
            /*
            for (int i = 1; i < self.collectionData.count; i++) {
                CollectionDataModel *data = self.collectionData[i];
                if (asset == data.asset) {
                    data.selected = NO;
                    break;
                }
            }
             */
            data.selected = NO;
            [weakSelf.myCollectionView reloadData];
            [weakSelf.thumbnailCollectionView reloadData];
        };
        
        if (weakSelf.selectedArray.count) {
            weakSelf.toolBarRightBtn.selected = NO;
            weakSelf.toolBarLeftBtn.selected = NO;
            [weakSelf.toolBarRightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] forState:UIControlStateNormal];
            weakSelf.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:225/255.0 green:33/255.0 blue:64/255.0 alpha:1];
        } else {
            weakSelf.toolBarRightBtn.selected = YES;
            weakSelf.toolBarLeftBtn.selected = YES;
            self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.94 alpha:1];
        }

        return cell;
        
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        // 相机
        if (self.chooseCount >= photoCounts) {
            return;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.showsCameraControls = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else {
        
        PreViewController *pre = [[PreViewController alloc] init];
        //pre.imgModelArray = self.collectionData;
        pre.delegate = self;
        pre.moreImgdelegate = self.delegate;
        pre.selectedArray = [NSMutableArray arrayWithArray:self.selectedArray];
        // 将_collectionData中除了第一张拍照，将剩下的数据传递给pre
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int i = 1; i < [self.collectionData count]; i++) {
            [tempArray addObject:self.collectionData[i]];
        }
        pre.collectionData = tempArray;
        pre.pageNum = indexPath.item;
        [self.navigationController pushViewController:pre animated:YES];
    }
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [[_collectionData objectAtIndex:indexPath.row] CGSizeValue];
    
    return size;
}
 */

#pragma mark --------------- SelectedArrayDelegate -----------------

// PreViewController中添加了选中图片，在本ViewController中需要更新
- (void)updateSelectedArray:(NSMutableArray *)array
{
    self.selectedArray = [NSMutableArray arrayWithArray:array];
    
    if (self.selectedArray.count) {
        self.toolBarRightBtn.selected = NO;
        self.toolBarLeftBtn.selected = NO;
        [self.toolBarRightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] forState:UIControlStateNormal];
        self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:225/255.0 green:33/255.0 blue:64/255.0 alpha:1];
    } else {
        self.toolBarRightBtn.selected = YES;
        self.toolBarLeftBtn.selected  = YES;
        self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.94 alpha:1];
    }
    
    [self.myCollectionView reloadData];
    [self.thumbnailCollectionView reloadData];
}


#pragma mark --------------- ReloadAssetDelegate ------------------

// 选择其他相册后，改变当前的collectionData
- (void)reloadCollectionData:(NSMutableArray *)collectionData assetCollectionIndex:(NSInteger)assetCollectionIndex
{
    self.collectionData = collectionData;
    [self.myCollectionView reloadData];
    
    if (assetCollectionIndex == 0) {
        // 如果是胶卷相册，使用胶卷相册的layout
        [self.myCollectionView setCollectionViewLayout:[[PhotoCollectionViewFlow alloc] init]];
    } else {
        // 如果是普通相册，则用normalLayout
        [self.myCollectionView setCollectionViewLayout:[[NormalCollectionViewFlow alloc] init]];
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
            [self.choosenImgArray setObject:[self fixOrientation:image] forKey:@"camare"];
        }
        
        CollectionDataModel *data = [[CollectionDataModel alloc] init];
        data.img = image;
        data.selected = YES;
        [self.selectedArray addObject:data];
        
        [picker dismissViewControllerAnimated:NO completion:^{
            //[self.myCollectionView reloadData];
            [self.thumbnailCollectionView reloadData];
        }];
    }
}

#pragma mark --------------- getter & setter -----------------

- (NSMutableArray *)originImgData
{
    if (!_originImgData) {
        _originImgData = [[NSMutableArray alloc] init];
    }
    
    return _originImgData;
}

- (NSMutableArray *)collectionData
{
    if (!_collectionData) {
        _collectionData = [[NSMutableArray alloc] init];
    }
    
    return _collectionData;
}

- (NSMutableDictionary *)isChoosenDic
{
    if (!_isChoosenDic) {
        _isChoosenDic = [[NSMutableDictionary alloc] init];
    }
    
    return _isChoosenDic;
}

/*
- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _assetsLibrary;
}
*/

- (NSMutableArray *)tableData
{
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] init];
    }
    
    return _tableData;
}

- (NSMutableDictionary *)chooseImgArray
{
    if (!_choosenImgArray) {
        _choosenImgArray = [[NSMutableDictionary alloc] init];
    }
    
    return _choosenImgArray;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    
    return _selectedArray;
}

- (NSMutableArray *)selectedModel
{
    if (!_selectedModel) {
        _selectedModel = [[NSMutableArray alloc] init];
    }
    
    return _selectedModel;
}

@end
