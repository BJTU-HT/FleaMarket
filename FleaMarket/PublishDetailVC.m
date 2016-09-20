//
//  PublishDetailVC.m
//  FleaMarket
//
//  Created by tom555cat on 16/5/21.
//  Copyright © 2016年 H-T. All rights reserved.
//

#define empty_width 3
#define maxnum_of_one_line 3
#define itemHeight ( CGRectGetWidth([UIScreen mainScreen].bounds) - (maxnum_of_one_line + 1) * empty_width ) / maxnum_of_one_line
#define item_Size CGSizeMake(itemHeight , itemHeight)

#import <BmobSDK/Bmob.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UITextField+RYNumberKeyboard.h"
#import "PublishDetailVC.h"
#import "UploadImageCell.h"
#import "SecondhandBL.h"
#import "SecondhandBLDelegate.h"
#import "SecondhandVO.h"
#import "PriceView.h"
#import "ItemCategoryViewController.h"
#import "ItemCategoryViewController.h"
#import "ChooseLocationView.h"
#import "LocationViewController.h"
#import "UploadImageModel.h"
#import "WLCircleProgressView.h"
#import "PlaceholderTextView.h"
#import "ImagePickerVC.h"
#import "CollectionDataModel.h"
#import "UserInfoSingleton.h"
#import <BmobSDK/BmobUser.h> //20160718

@interface PublishDetailVC () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, SecondhandBLDelegate, ChooseCategoryDelegate, ChooseLocationDelegate, AddMoreImgDelegate>

// 二手商品信息的View
@property (nonatomic, strong) UIView *itemInfoView;
@property (nonatomic, strong) UIScrollView *publishScrollView;
@property (nonatomic, strong) UITextField *titleInputView;
@property (nonatomic, strong) UIView *barView1;
@property (nonatomic, strong) PlaceholderTextView *descriptionInputView;
@property (nonatomic, strong) UICollectionView *uploadImagesCollectionView;
@property (nonatomic, strong) ChooseLocationView *locationView;

// 价格和分类View
@property (nonatomic, strong) UIView *priceAndCategoryView;
@property (nonatomic, strong) UIView *barView2;
@property (nonatomic, strong) PriceView *priceView;
@property (nonatomic, strong) UIView *barView3;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, strong) UIView *barView4;
@property (nonatomic, strong) UIButton *submitBtn;

// 业务
@property (nonatomic, strong) SecondhandBL *bl;

// 当前二手物品的分类
@property (nonatomic, strong) NSString *itemCategory;
@property (nonatomic, strong) NSString *viceCategory;

// 保存上传照片后返回的URL array
@property (nonatomic, strong) NSMutableArray *imagesURLArray;

// ActivityIndicator
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PublishDetailVC

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self createSubviews];
        
        [self setLeftItemBtn];
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self relayoutSubviews];
    
    // 触摸其他位置，收回键盘
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGR.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGR];
}

#pragma mark ------------------- private ---------------------
- (void)createSubviews
{
    UIScrollView *publishScrollView = [[UIScrollView alloc] init];
    self.publishScrollView = publishScrollView;
    self.publishScrollView.backgroundColor = grayColorPCH;
    
    // 物品信息的一个view
    UIView *itemInfoView = [[UIView alloc] init];
    self.itemInfoView = itemInfoView;
    
    UITextField *titleInputView = [[UITextField alloc] init];
    self.titleInputView = titleInputView;
    
    UIView *barView1 = [[UIView alloc] init];
    self.barView1 = barView1;
    
    PlaceholderTextView *descriptionInputView = [[PlaceholderTextView alloc] initWithFrame:CGRectZero];
    self.descriptionInputView = descriptionInputView;
    
    ChooseLocationView *locationView = [[ChooseLocationView alloc] init];
    self.locationView = locationView;
    //self.locationLabel.backgroundColor = [UIColor grayColor];
    
    
    // 价格和分类的一个view
    UIView *priceAndCategoryView = [[UIView alloc] init];
    self.priceAndCategoryView = priceAndCategoryView;
    
    UIView *barView2 = [[UIView alloc] init];
    self.barView2 = barView2;
    
    PriceView *priceView = [[PriceView alloc] init];
    self.priceView = priceView;
    //self.priceView.backgroundColor = [UIColor grayColor];
    
    UIView *barView3 = [[UIView alloc] init];
    self.barView3 = barView3;
    
    UILabel *categoryLabel = [[UILabel alloc] init];
    self.categoryLabel = categoryLabel;
    //self.categoryLabel.backgroundColor = [UIColor grayColor];
    
    UIButton *categoryButton = [[UIButton alloc] init];
    self.categoryButton = categoryButton;
    
    UIView *barView4 = [[UIView alloc] init];
    self.barView4 = barView4;
    
    UIButton *submitBtn = [[UIButton alloc] init];
    self.submitBtn = submitBtn;
    self.submitBtn.backgroundColor = [UIColor redColor];
}

- (void)relayoutSubviews
{
    CGFloat margin = 10.0f;
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    //201607181458 cut by hou becauser it is unused in this project
    //CGFloat navigationBarH = self.navigationController.navigationBar.frame.size.height;
    //CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    //UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, 64)];
    //navigationView.backgroundColor = [UIColor blueColor];
    //[self.view addSubview:navigationView];
    
    // 整个滚动页面
    self.publishScrollView.frame = CGRectMake(0, 0, winSize.width, winSize.height - 64);
    self.publishScrollView.contentSize = CGSizeMake(0, winSize.height);
    [self.view addSubview:self.publishScrollView];
    
    // 二手商品信息UIView
    CGFloat infoViewX = 0;
    CGFloat infoViewY = 0;
    CGFloat infoW = winSize.width;
    CGFloat infoH = 0;
    self.itemInfoView.frame = CGRectMake(infoViewX, infoViewY, infoW, infoH);
    self.itemInfoView.backgroundColor = [UIColor whiteColor];
    [self.publishScrollView addSubview:self.itemInfoView];
    
    CGFloat titleInputX = margin;
    CGFloat titleInputY = margin;
    CGFloat titleInputWidth = winSize.width - 2 * margin;
    CGFloat titleInputHeight = 30;
    self.titleInputView.frame = CGRectMake(titleInputX, titleInputY, titleInputWidth, titleInputHeight);
    [self.titleInputView setFont:FontSize14];
    self.titleInputView.placeholder = @"输入商品标题";
    [self.itemInfoView addSubview:self.titleInputView];
    
    CGFloat bar1X = margin;
    CGFloat bar1Y = CGRectGetMaxY(self.titleInputView.frame) + margin / 2.0f;
    CGFloat bar1W = winSize.width - 2 * margin;
    CGFloat bar1H = 0.5f;
    self.barView1.frame = CGRectMake(bar1X, bar1Y, bar1W, bar1H);
    self.barView1.backgroundColor = [UIColor grayColor];
    [self.itemInfoView addSubview:self.barView1];
    
    CGFloat descriptionX = margin;
    CGFloat descriptionY = CGRectGetMaxY(self.barView1.frame) + margin / 2.0f;
    CGFloat descriptionW = winSize.width - 2 * margin;
    CGFloat descriptionH = 120;
    self.descriptionInputView.frame = CGRectMake(descriptionX, descriptionY, descriptionW, descriptionH);
    [self.descriptionInputView setFont:FontSize14];
    self.descriptionInputView.myPlaceholder = @"请输入描述文字...";
    self.descriptionInputView.myPlaceholderColor = [UIColor lightGrayColor];
    [self.itemInfoView addSubview:self.descriptionInputView];
    
    // 选择上传的图片
    [self.itemInfoView addSubview:self.uploadImagesCollectionView];
    [self.uploadImagesCollectionView registerClass:[UploadImageCell class] forCellWithReuseIdentifier:@"uploadcollectioncell"];
    
    CGFloat locationX = margin;
    CGFloat locationY = CGRectGetMaxY(self.uploadImagesCollectionView.frame) + margin / 2.0f;
    CGFloat locationW = 80;
    CGFloat locationH = 35;
    self.locationView.frame = CGRectMake(locationX, locationY, locationW, locationH);
    [self.itemInfoView addSubview:self.locationView];
    UITapGestureRecognizer *locationGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseLocation)];
    [self.locationView addGestureRecognizer:locationGR];
    
    // 重新调整二手商品View的高度
    infoH = CGRectGetMaxY(self.locationView.frame) + margin;
    self.itemInfoView.frame = CGRectMake(infoViewX, infoViewY, infoW, infoH);
    
    
    // 价格和分类view
    CGFloat priceAndCategoryX = 0;
    CGFloat priceAndCategoryY = CGRectGetMaxY(self.itemInfoView.frame) + margin * 2.0f;
    CGFloat priceAndCategoryW = winSize.width;
    CGFloat priceAndCategoryH = 0;
    self.priceAndCategoryView.backgroundColor = [UIColor whiteColor];
    self.priceAndCategoryView.frame = CGRectMake(priceAndCategoryX, priceAndCategoryY, priceAndCategoryW, priceAndCategoryH);
    [self.publishScrollView addSubview:self.priceAndCategoryView];
    
    CGFloat priceViewX = margin;
    CGFloat priceViewY = margin;
    CGFloat priceViewW = winSize.width - margin * 2.0f;
    CGFloat priceViewH = 40;
    self.priceView.frame = CGRectMake(priceViewX, priceViewY, priceViewW, priceViewH);
    [self.priceAndCategoryView addSubview:self.priceView];
    
    CGFloat bar3X = margin;
    CGFloat bar3Y = CGRectGetMaxY(self.priceView.frame) + margin / 2.0f;
    CGFloat bar3W = winSize.width - 2 * margin;
    CGFloat bar3H = 0.5f;
    self.barView3.frame = CGRectMake(bar3X, bar3Y, bar3W, bar3H);
    self.barView3.backgroundColor = [UIColor lightGrayColor];
    [self.priceAndCategoryView addSubview:self.barView3];
    
    // 分类标签
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *labelAttributeString = [[NSMutableAttributedString alloc] initWithString:@"分类:" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontSize14,NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGFloat categoryX = margin;
    CGFloat categoryY = CGRectGetMaxY(self.barView3.frame) + margin / 2.0f;
    CGFloat categoryW = (winSize.width - margin * 2.0f - 0.5f) / 4.0f;
    CGFloat categoryH = 40;
    self.categoryLabel.frame = CGRectMake(categoryX, categoryY, categoryW, categoryH);
    self.categoryLabel.attributedText = labelAttributeString;
    //self.categoryLabel.backgroundColor = [UIColor grayColor];
    [self.priceAndCategoryView addSubview:self.categoryLabel];
    
    CGFloat categoryBtnX = CGRectGetMaxX(self.categoryLabel.frame);
    CGFloat categoryBtnY = CGRectGetMaxY(self.barView3.frame) + margin / 2.0f;
    CGFloat categoryBtnW = (winSize.width - margin * 2.0f - 0.5f) * 3.0f / 4.0f;
    CGFloat categoryBtnH = 40;
    self.categoryButton.frame = CGRectMake(categoryBtnX, categoryBtnY, categoryBtnW, categoryBtnH);
    //self.categoryButton.backgroundColor = [UIColor redColor];
    self.itemCategory = [NSString stringWithFormat:@"请选择分类             >"];
    [self.categoryButton addTarget:self action:@selector(chooseCategoryBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.priceAndCategoryView addSubview:self.categoryButton];
    
    // 调整价格和分类view的高度
    priceAndCategoryH = CGRectGetMaxY(self.categoryLabel.frame) + margin;
    self.priceAndCategoryView.frame = CGRectMake(priceAndCategoryX, priceAndCategoryY, priceAndCategoryW, priceAndCategoryH);
    
    
    // 提交按钮
    CGFloat submitW = winSize.width;
    CGFloat submitH = 64;
    CGFloat submitX = 0;
    CGFloat submitY = winSize.height - submitH;
    self.submitBtn.frame = CGRectMake(submitX, submitY, submitW, submitH);
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *btnAttributeString = [[NSMutableAttributedString alloc] initWithString:@"发布" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Verdana-Bold" size:23],NSParagraphStyleAttributeName:paragraphStyle}];
    [self.submitBtn setAttributedTitle:btnAttributeString forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(publishSecondhand) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBtn];
}

- (void)setLeftItemBtn
{
    UINavigationItem *navItem = self.navigationItem;
    
    UIBarButtonItem *quitBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePublish)];
    navItem.leftBarButtonItem = quitBtn;
}

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

#pragma mark ------------------- AddMoreImgDelegate --------------------

- (void)addMoreImg:(NSMutableArray *)selectedArray
{
    if ([selectedArray count] == 0) {
        return;
    }
    
    for (NSInteger idx = 0; idx < selectedArray.count; idx++) {
        CollectionDataModel *model = selectedArray[idx];
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
                                     [self.selectedImgArray addObject:uploadModel];
            }];
        } else if (model.img) {
            uploadModel.img = model.img;
            uploadModel.isUploaded = NO;
            [self.selectedImgArray addObject:uploadModel];
        }
    }
    
    [self.uploadImagesCollectionView reloadData];
}

// 选中增加更多图片的按钮时，当选了更多的图片时，更新当前的collectionData
/*
- (void)addMoreImg:(NSMutableArray *)collectionData
{
    // 如果参数collectionData和当前的collectionData的数目一致，那么是从ImagePickerVC返回的
    // collectionData数据，需要从1开始，避开相机图片；
    // 否则是从PreViewController返回的,collectionData数据，没有相机图片，需要从1开始。
    
    if ([collectionData count] == 0) {
        return;
    }
    
    CollectionDataModel *model = collectionData[0];
    // 如果第一张图片是个“拍照”图标，则不需要上传
    int i = (model.img == nil) ? 0 : 1;
    for ( ; i < collectionData.count; i++) {
        CollectionDataModel *model = collectionData[i];
        if (model.selected) {
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
                                     [self.selectedImgArray addObject:uploadModel];
                                 }];
            //uploadModel.img = model.img;
            //uploadModel.isUploaded = NO;
            //[self.selectedImgArray addObject:uploadModel];
        }
    }
    [self.uploadImagesCollectionView reloadData];
}
*/

#pragma mark ------------------- collectionView delegate --------------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CGFloat margin = 10.0f;
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGFloat itemW = (winSize.width - margin * 2.0f) / 4.0f;
    CGFloat itemH = itemW;
    
    CGFloat collectionX = margin;
    CGFloat collectionY = CGRectGetMaxY(self.descriptionInputView.frame) + margin / 2.0f;
    CGFloat collectionW = winSize.width - margin * 2.0f;
    
    if ((self.selectedImgArray.count + 1 >= 1) && (self.selectedImgArray.count + 1 <= 4) ) {
        self.uploadImagesCollectionView.frame = CGRectMake(collectionX, collectionY, collectionW, itemH);
    } else if ((self.selectedImgArray.count + 1 > 4) && (self.selectedImgArray.count + 1 <=8 ) ) {
        self.uploadImagesCollectionView.frame = CGRectMake(collectionX, collectionY, collectionW, 2 * itemH);
    }
    
    [self relayoutSubviews];
    return self.selectedImgArray.count + 1;
}

/*
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 CGSize imgSize = {self.};
 }
 */

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UploadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"uploadcollectioncell" forIndexPath:indexPath];
    
    // 最后一个, 是新添加相片的一个按钮
    NSLog(@"indexPath item: %ld", indexPath.item);
    if (indexPath.item == self.selectedImgArray.count) {
        cell.contentImg = [UIImage imageNamed:@"square_add"];
        [cell.dropImageBtn setHidden:YES];
        [cell.circleProgress setHidden:YES];
        //[cell.circleProgress removeFromSuperview];
        
        UITapGestureRecognizer *addMoreImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMoreImgTapAction)];
        [cell addGestureRecognizer:addMoreImgTap];
        
    } else {
        UploadImageModel *model = self.selectedImgArray[indexPath.item];
        
        __weak UploadImageCell *weakCell = cell;
        __weak PublishDetailVC *weakSelf = self;
        cell.contentImg = model.img;
        [cell.dropImageBtn setHidden:NO];
        cell.dropCurrentChooseImg = ^(){
            [weakSelf.selectedImgArray removeObjectAtIndex:indexPath.item];
            [weakSelf.uploadImagesCollectionView reloadData];
        };
        
        // 如果已经上传，则返回
        if (model.isUploaded) {
            return cell;
        }
        
        // 上传
        NSData *imgData = UIImageJPEGRepresentation(model.img, 0.5);
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"上传测试.png", @"filename", imgData, @"data", nil];
        NSArray *array = @[dic];
        
        [BmobFile filesUploadBatchWithDataArray:array progressBlock:^(int index, float progress) {
            weakCell.circleProgress.progressValue = progress;
        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
            if (error) {
                NSLog(@"上传失败！！！！！");
            } else {
                // 上传成功
                if (!weakSelf) {
                    return;
                }
                
                model.isUploaded = YES;
                [weakCell.circleProgress setHidden:YES];
                
                for (int i = 0; i < array.count; i++) {
                    BmobFile *file = array[i];
                    [self.imagesURLArray addObject:file.url];
                    //NSLog(@"%@", self.imagesURLArray[i]);
                }
            }
        }];
    }
    
    return cell;
}

#pragma mark --------------- ChooseCategoryDelegate ------------------

/*
 - (void)chooseCategory:(NSString *)category
 {
 self.itemCategory = category;
 NSLog(@"%@", self.itemCategory);
 }
 */

- (void)chooseCategory:(NSString *)mainCategory category:(NSString *)category
{
    self.itemCategory = mainCategory;
    self.viceCategory = category;
}

#pragma mark --------------- ChooseLocationDelegate ------------------

- (void)chooseLocation:(NSString *)locationStr
{
    self.locationView.location = locationStr;
}

#pragma mark ------------------- SecondhandBL delegate -------------------

- (void)publishSecondhandFinished
{
    NSLog(@"创建二手商品成功！！");
    // 重置当前collectionData的选中状态
    // 如果能直接销毁发布页，则collectionData也销毁掉了
    /*
    for (int i = 0; i < self.collectionData.count; i++) {
        CollectionDataModel *model = self.collectionData[i];
        model.selected = NO;
    }
     */
    
    [self.activityIndicatorView stopAnimating];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)publishSecondhandFailed
{
    NSLog(@"创建二手商品失败！！");
}


#pragma mark ------------------- action -------------------

- (void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.titleInputView resignFirstResponder];
    [self.descriptionInputView resignFirstResponder];
}

// 添加更多的图片按钮点击事件
- (void)addMoreImgTapAction
{
    // 判断collectionData[0]的image是否为空，如果为空，那么当前的提交是由浏览大图中提交的；
    // 如果不为空，则是由缩略图中提交的。
    
    // 重置collectionData的选中状态
    /*
    for (int i = 0; i < self.collectionData.count; i++) {
        CollectionDataModel *model = self.collectionData[i];
        model.selected = NO;
    }
    */
    
    [self getPhotoAssetCollections];
    
    ImagePickerVC *imgPickVC = [[ImagePickerVC alloc] init];
    imgPickVC.tableData = self.tableData;
    imgPickVC.collectionData = self.collectionData;
    imgPickVC.hidesBottomBarWhenPushed = YES;
    imgPickVC.delegate = self;
    //imgPickVC.flag = YES;            // 新增加图片，flag为YES
    //imgPickVC.selectedArray = selectedArray;
    
    [self.navigationController pushViewController:imgPickVC animated:YES];
}

- (void)closePublish
{
    [self.delegate deleteSelectedImgs];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)publishSecondhand
{
    UserMO *userMO = [UserInfoSingleton sharedManager].userMO;
    if (userMO == nil) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论必须登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }

    SecondhandVO *model = [[SecondhandVO alloc] init];
    model.productName = self.titleInputView.text;
    model.originalPrice = self.priceView.originalPrice;
    model.nowPrice = self.priceView.nowPrice;
    model.pictureArray = self.imagesURLArray;
    model.productDescription = self.descriptionInputView.text;
    //20160718 add userID by hou
    model.userID = userMO.user_id;
    model.userName = userMO.user_name;
    model.userIconImage = userMO.head_image_url;
    model.sex = userMO.gender;
    if (![self.itemCategory isEqualToString:@"请选择分类             >"]) {
        NSLog(@"%@", self.itemCategory);
        model.mainCategory = self.itemCategory;
        model.viceCategory = self.viceCategory;
    }
    
    if (![self.locationView.location isEqualToString:@"选择学校"]) {
        model.location = self.locationView.location;
        model.school = self.locationView.location;
        NSLog(@"%@", model.location);
    }
    
    if (model.productName == nil || model.productDescription == nil || model.pictureArray.count == 0 ||
        model.location == nil || model.nowPrice == 0 || model.mainCategory == nil || model.viceCategory == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"必须包含标题，描述，至少一张图片，学校，价格以及物品分类" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //code
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self.activityIndicatorView startAnimating];
        [self.bl createSecondhand:model];
    }
}

// 选择商品分类

- (void)chooseCategoryBtnClicked
{
    ItemCategoryViewController *itemCategoryVC = [[ItemCategoryViewController alloc] initWithFrame:self.view.frame];
    itemCategoryVC.delegate = self;
    [self.navigationController pushViewController:itemCategoryVC animated:NO];
}

// 选择学校
- (void)chooseLocation
{
    LocationViewController *locVC = [[LocationViewController alloc] initWithFrame:self.view.frame];
    locVC.delegate = self;
    [self.navigationController pushViewController:locVC animated:NO];
}

#pragma mark ------------------- getter & setter -------------------

- (NSMutableArray *)imagesURLArray
{
    if (!_imagesURLArray) {
        _imagesURLArray = [[NSMutableArray alloc] init];
    }
    
    return _imagesURLArray;
}


- (void)setItemCategory:(NSString *)itemCategory
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *btnAttributeString = [[NSMutableAttributedString alloc] initWithString:itemCategory attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontSize14,NSParagraphStyleAttributeName:paragraphStyle}];
    [self.categoryButton setAttributedTitle:btnAttributeString forState:UIControlStateNormal];
    
    if (!_itemCategory) {
        _itemCategory = [NSString stringWithString:itemCategory];
    } else {
        _itemCategory = itemCategory;
    }
}

- (SecondhandBL *)bl
{
    if (!_bl) {
        _bl = [SecondhandBL new];
        _bl.delegate = self;
    }
    
    return _bl;
}

- (NSMutableArray *)selectedImgArray
{
    if (!_selectedImgArray) {
        _selectedImgArray = [[NSMutableArray alloc] init];
    }
    
    return _selectedImgArray;
}

- (UICollectionView *)uploadImagesCollectionView
{
    if (!_uploadImagesCollectionView) {
        CGFloat margin = 10.0f;
        CGSize winSize = [UIScreen mainScreen].bounds.size;
        CGFloat itemW = (winSize.width - margin * 2.0f) / 4.0f;
        CGFloat itemH = itemW;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        
        CGFloat collectionX = margin;
        CGFloat collectionY = CGRectGetMaxY(self.descriptionInputView.frame) + margin / 2.0f;
        CGFloat collectionW = winSize.width - margin * 2.0f;
        _uploadImagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(collectionX, collectionY, collectionW, itemH) collectionViewLayout:flowLayout];
        _uploadImagesCollectionView.dataSource = self;
        _uploadImagesCollectionView.delegate = self;
        _uploadImagesCollectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return _uploadImagesCollectionView;
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

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicatorView setBackgroundColor:[UIColor blackColor]];
        _activityIndicatorView.center = self.view.center;
        [self.view addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}

@end
