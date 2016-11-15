//
//  CollectionViewController.m
//  test123
//
//  Created by tom555cat on 16/5/25.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <Photos/Photos.h>
#import "CollectionViewController.h"
#import "YBImgPickerTableViewCell.h"
//#import "CollectionTableViewCell.h"
#import "AssetCollectionCell.h"
#import "CollectionDataModel.h"

#define tableH MIN(CGRectGetHeight([UIScreen mainScreen].bounds) - 64, tableCellH * tableData.count);

static NSString *IDD_IMG = @"collectionTableViewCell";

@interface CollectionViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation CollectionViewController

#pragma mark ------------------- private --------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

- (void)setup
{
    UITableView *myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [myTableView registerNib:[UINib nibWithNibName:@"YBImgPickerTableViewCell" bundle:nil] forCellReuseIdentifier:IDD_IMG];
    //[myTableView registerClass:[AssetCollectionCell class] forCellReuseIdentifier:IDD_IMG];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    self.myTableView = myTableView;
    [self.view addSubview:self.myTableView];
    
    NSLog(@"sssssss, %ld", (unsigned long)self.tableData.count);
    
    self.navigationController.delegate = self;
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------------- navigationControllerDelegate ------------------
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.myTableView reloadData];
}

#pragma mark -------------------- tableViewDelegate --------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"table number is %ld", (unsigned long)self.tableData.count);
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBImgPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDD_IMG forIndexPath:indexPath];
    /*
    ALAssetsGroup *assetsGroup = [self.tableData objectAtIndex:indexPath.row];
    cell.albumTitle = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    cell.photoNum = assetsGroup.numberOfAssets;
    cell.albumImg = [UIImage imageWithCGImage:assetsGroup.posterImage];
    */
    
    PHAssetCollection *assetCollection = [self.tableData objectAtIndex:indexPath.row];
    
    // 获取封面
    __weak YBImgPickerTableViewCell *weakCell = cell;
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    if ([assets count]) {
        PHAsset *asset = assets[0];
        [[PHImageManager defaultManager] requestImageForAsset:assets[0]
                                                   targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)
                                                  contentMode:PHImageContentModeDefault
                                                      options:nil
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakCell.albumImg = result;
            NSLog(@"%@", result);
        }];
    }
    
    cell.albumTitle = assetCollection.localizedTitle;
    cell.photoNum = [assets count];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath row %ld", (long)indexPath.row);
    
    // 传递回去的当前相册集的collectionData
    NSMutableArray *collectionData = [[NSMutableArray alloc] init];
    
    // 如果是第一个相册，则是胶卷相册，第一张图是一个“拍照”图片
    if (indexPath.row == 0) {
        CollectionDataModel *dataModel = [[CollectionDataModel alloc] init];
        dataModel.img = [UIImage imageNamed:@"takePicture.png"];
        [collectionData addObject:dataModel];
    }
    
    /**
     *   读取相册中的照片
     **/
    PHAssetCollection *assetCollection = self.tableData[indexPath.row];
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
        [collectionData addObject:dataModel];
    }

    
    //[self.delegate reloadAsset:indexPath.row];
    [self.delegate reloadCollectionData:collectionData assetCollectionIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -------------------- getter & setter -------------------


- (NSMutableArray *)tableData
{
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] init];
    }
    
    return _tableData;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
