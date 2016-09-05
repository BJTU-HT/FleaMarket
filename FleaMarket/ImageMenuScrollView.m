//
//  ImageMenuScrollView.m
//  FleaMarket
//
//  Created by tom555cat on 16/7/4.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "ImageMenuScrollView.h"
#import "MenuButton.h"

@interface ImageMenuScrollView ()

// 整体scrollview
@property (nonatomic, weak) UIScrollView *menu;
// labelArray
@property (nonatomic, strong) NSMutableArray *labelArray;

@end

@implementation ImageMenuScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize winSize = [UIScreen mainScreen].bounds.size;
        CGFloat categoryW = winSize.width/5.0f;
        CGFloat categoryH = categoryW * 1.5f;
        
        NSArray *categoryArray = SecondhandCategoryDisplay;
        UIScrollView *menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, categoryH)];
        self.menu = menu;
        self.menu.contentSize = CGSizeMake(categoryW * [categoryArray count], 0);
        self.menu.showsHorizontalScrollIndicator = NO;
        self.menu.bounces = NO;
        [self addSubview:self.menu];
        
        // 添加菜单标签
        //NSArray *categoryArray = SecondhandCategory;
        for (int i = 0; i < categoryArray.count; i++) {
            CGFloat menuBtnX = i * categoryW;
            CGFloat menuBtnY = 0;
            MenuButton *menuBtn = [[MenuButton alloc] initWithFrame:CGRectMake(menuBtnX, menuBtnY, categoryW, categoryH)];
            menuBtn.menuImage = [NSString stringWithFormat:@"label%d", i];
            menuBtn.menuName = categoryArray[i];
            
            
            // 设置标签的tag，根据tag来确定是哪一个分类
            menuBtn.tag = i;
            [menuBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.labelArray addObject:menuBtn];
            [self.menu addSubview:menuBtn];
            
            self.backgroundColor = [UIColor whiteColor];
        }
        
        // 全部按钮默认是选中的
        UIButton *btn = self.labelArray[0];
        btn.backgroundColor = [UIColor yellowColor];
    }
    
    return self;
}

- (void)buttonClicked:(UIButton *)category
{
    //NSLog(@"button tag %ld", category.tag);
    [self.delegate chooseCategory:category.tag];
    
    // 设置颜色
    for (UIButton *btn in _labelArray) {
        btn.backgroundColor = [UIColor whiteColor];
    }
    category.backgroundColor = [UIColor yellowColor];
}

- (void)setCurrentCategory:(NSInteger)currentCategory
{
    _currentCategory = currentCategory;
    // 设置颜色
    for (UIButton *btn in _labelArray) {
        if (btn.tag == currentCategory) {
            btn.backgroundColor = [UIColor yellowColor];
        } else {
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
}

-(NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [[NSMutableArray alloc] init];
    }
    
    return _labelArray;
}

@end
