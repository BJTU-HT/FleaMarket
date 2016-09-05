//
//  SelectedPhotoCollectionViewLayout.m
//  test123
//
//  Created by tom555cat on 16/6/5.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "SelectedPhotoCollectionViewLayout.h"

@interface SelectedPhotoCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation SelectedPhotoCollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    [self.array removeAllObjects];
    for (NSUInteger idx = 0; idx < count; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [self.array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    CGFloat collectionViewH = self.collectionView.frame.size.height;
    CGFloat x = indexPath.item * collectionViewH;
    CGFloat y = 0;
    attr.frame = CGRectMake(x, y, collectionViewH, collectionViewH);
    return attr;
}

- (CGSize)collectionViewContentSize
{
    CGSize size = self.collectionView.frame.size;
    CGFloat maxWidth = 0;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger idx = 0; idx < count; idx++) {
        maxWidth += size.height;
    }
    NSLog(@"max width is:%f", maxWidth);
    return CGSizeMake(maxWidth, 0);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"array number is : %ld", _array.count);
    return _array;
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    
    return _array;
}

@end
