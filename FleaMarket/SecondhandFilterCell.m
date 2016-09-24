//
//  SecondhandFilterCell.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandFilterCell.h"

@interface SecondhandFilterCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *numberBtn;

@end

@implementation SecondhandFilterCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)frame{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        self.frame = frame;
        //
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        //
        //        NSLog(@"self.frame.size.width:%f",self.frame.size.width);
        _numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _numberBtn.frame = CGRectMake(self.frame.size.width-85, 12, 80, 15);
        _numberBtn.font = [UIFont systemFontOfSize:11];
        _numberBtn.layer.cornerRadius = 7;
        _numberBtn.layer.masksToBounds = YES;
        [_numberBtn setBackgroundImage:[UIImage imageNamed:@"film"] forState:UIControlStateNormal];
        [_numberBtn setBackgroundImage:[UIImage imageNamed:@"film"] forState:UIControlStateHighlighted];
        [_numberBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_numberBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_numberBtn];
        
        //下划线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
        lineView.backgroundColor = lightGrayColorPCH;
        [self.contentView addSubview:lineView];
    }
    return self;
}

-(void)setGroupM:(SchoolGroupModel *)groupM{
    _groupM = groupM;
    _nameLabel.text = groupM.name;
    
    if (groupM.list == nil) {
        //[_numberBtn setTitle:[NSString stringWithFormat:@"%@",groupM.count] forState:UIControlStateNormal];
    }else{
        //[_numberBtn setTitle:[NSString stringWithFormat:@"%@>",groupM.count] forState:UIControlStateNormal];
        [_numberBtn setTitle:@">" forState:UIControlStateNormal];
    }
    
    //NSString *str = [NSString stringWithFormat:@"%@>",groupM.count];
    NSString *str = [NSString stringWithFormat:@">"];
    CGSize textSize = [str sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(80, 15) lineBreakMode:NSLineBreakByWordWrapping];
    
    _numberBtn.frame = CGRectMake(self.frame.size.width-10-textSize.width-10, 12, textSize.width+10, 15);
    
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
