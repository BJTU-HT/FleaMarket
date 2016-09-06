//
//  mySellTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "mySellTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation mySellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self initSubView];
    }
    return self;
}

-(void)cellConfig:(CGRect)frame datadic:(NSMutableDictionary *)dic{
    if(!_mySellView){
        _mySellView = [[mySellAndBorrowView alloc] initWithFrame:frame];
    }
    [self.contentView addSubview:_mySellView];
    if([dic objectForKey:@"school"]){
        _mySellView.labelSchoolSell.text = [dic objectForKey: @"school"];
    }
    if([dic objectForKey:@"now_price"]){
        NSNumber *num = [dic objectForKey:@"now_price"];
        NSString *str = [NSString stringWithFormat:@"%@", num];
        NSString *str1 = @"售价: ";
        NSString *str2 = [str1 stringByAppendingString:str];
        NSString *str3 = @"元";
        NSString *str4 = [str2 stringByAppendingString:str3];
        _mySellView.labelPriceSell.text = str4;
    }
    if([dic objectForKey:@"createdAt"]){
        _mySellView.labelDateSell.text = [dic objectForKey:@"createdAt"];
    }
    if([dic objectForKey:@"sellPrice"]){
        NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"sellPrice"]];
        NSString *str1 = @"售价: ";
        NSString *str2 = [str1 stringByAppendingString:str];
        NSString *str3 = @"元";
        NSString *str4 = [str2 stringByAppendingString:str3];
        _mySellView.labelPriceSell.text = str4;
    }
    if([dic objectForKey:@"bookImageURL"]){
        [_mySellView.imageViewSell sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"bookImageURL"]] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];
    }
    if([dic objectForKey:@"picture_array"]){
        NSArray *arr = [dic objectForKey:@"picture_array"];
        NSString *str = arr[0];
        [_mySellView.imageViewSell sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
