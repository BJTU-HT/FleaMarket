//
//  MenuCell.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/7.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "MenuCell.h"
#import "MenuButton.h"
#import "Help.h"

@interface MenuCell()

// 整体scrollview
@property (nonatomic, weak) UIScrollView *menu;

// labelArray
@property (nonatomic, strong) NSMutableArray *labelArray;

@end

@implementation MenuCell

- (void)awakeFromNib {
    //20161009 add super to release warning
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSArray *)menuNameArray
{
    NSArray *menuNameArray = [[NSArray alloc] initWithObjects:@"书籍", @"手机", @"数码", @"电脑", @"文体", @"电器", @"其他", nil];
    return menuNameArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        NSLog(@"%s", __func__);
        
        CGSize winSize = [UIScreen mainScreen].bounds.size;
        CGFloat categoryW = winSize.width/5.0f;
        CGFloat categoryH = categoryW * 1.5f;
        
        // 菜单
        NSArray *categoryArray = SecondhandCategoryDisplay;
        UIScrollView *menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, categoryH)];
        self.menu = menu;
        self.menu.contentSize = CGSizeMake(categoryW * [categoryArray count] , 0);
        self.menu.showsHorizontalScrollIndicator = NO;
        self.menu.bounces = NO;
        [self.contentView addSubview:self.menu];
        
        // 添加标签按钮
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
        }
        
        // 全部按钮是默认选中的
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
        }
        btn.backgroundColor = [UIColor whiteColor];
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
