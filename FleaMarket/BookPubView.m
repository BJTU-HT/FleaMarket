//
//  BookPubView.m
//  FleaMarket
//
//  Created by Hou on 7/20/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "BookPubView.h"


@implementation BookPubView
float labelBorderWidth;
NSMutableArray *mutableArrField;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = lightGrayColorPCH;
    mutableArrField = [[NSMutableArray alloc] initWithCapacity: 8];
    labelBorderWidth = 0.5;
    if(self){
        if(!self.bookName){
            self.bookName = [[UITextField alloc] init];
            self.bookName.placeholder = @"书名";
            self.bookName.font = FontSize14;
            self.bookName.textColor = [UIColor grayColor];
            self.bookName.layer.borderWidth = labelBorderWidth;
            self.bookName.layer.borderColor = grayColorPCH.CGColor;
            self.bookName.textAlignment = NSTextAlignmentLeft;
            self.bookName.delegate = self;
            self.bookName.tag = 0;
            [self addSubview:self.bookName];
            [mutableArrField addObject:self.bookName.text];
        }
        if(!self.author){
            self.author = [[UITextField alloc] init];
            self.author.placeholder = @"作者";
            self.author.layer.borderColor = grayColorPCH.CGColor;
            self.author.layer.borderWidth = labelBorderWidth;
            self.author.textColor = [UIColor grayColor];
            self.author.font = FontSize14;
            self.author.delegate = self;
            self.author.textAlignment = NSTextAlignmentLeft;
            [self addSubview:self.author];
            self.author.tag = 1;
            [mutableArrField addObject:self.author.text];

        }
        if(!self.pressHouse){
            self.pressHouse = [[UITextField alloc] init];
            self.pressHouse.layer.borderWidth = labelBorderWidth;
            self.pressHouse.placeholder = @"出版社";
            self.pressHouse.font = FontSize14;
            self.pressHouse.textColor = [UIColor grayColor];
            self.pressHouse.layer.borderColor = grayColorPCH.CGColor;
            self.pressHouse.textAlignment = NSTextAlignmentLeft;
            self.pressHouse.delegate = self;
            [self addSubview: self.pressHouse];
            self.pressHouse.tag = 2;
            [mutableArrField addObject:self.pressHouse.text];
        }
        if(!self.sellPrice){
            self.sellPrice = [[UITextField alloc] init];
            self.sellPrice.placeholder = @"出售价";
            self.sellPrice.font = FontSize14;
            self.sellPrice.layer.borderWidth = labelBorderWidth;
            self.sellPrice.textColor = [UIColor grayColor];
            self.sellPrice.layer.borderColor = grayColorPCH.CGColor;
            self.sellPrice.textAlignment = NSTextAlignmentLeft;
            self.sellPrice.delegate = self;
            [self addSubview:self.sellPrice];
            self.sellPrice.tag = 3;
            [mutableArrField addObject:self.sellPrice.text];
        }
        if(!self.originalPrice){
            self.originalPrice = [[UILabel alloc] init];
            self.originalPrice.text = @"原价";
            self.originalPrice.textAlignment = NSTextAlignmentLeft;
            self.originalPrice.font = FontSize14;
            [self addSubview:self.originalPrice];
        }
        if(!self.originalPriceField){
            self.originalPriceField = [[UITextField alloc] init];
            self.originalPriceField.font = FontSize14;
            [self addSubview:self.originalPriceField];
            self.originalPriceField.delegate = self;
            self.originalPriceField.tag = 4;
            [mutableArrField addObject:self.originalPriceField.text];
        }
        if(!self.amount){
            self.amount = [[UILabel alloc] init];
            self.amount.text = @"数量:";
            self.amount.font = FontSize14;
            [self addSubview:self.amount];
        }
        if(!self.amountField){
            self.amountField = [[UITextField alloc] init];
            self.amountField.font = FontSize14;
            [self addSubview:self.amountField];
            self.amountField.delegate = self;
            self.amountField.tag = 5;
            [mutableArrField addObject:self.amountField.text];
        }
        if(!self.category){
            self.category = [[UILabel alloc] init];
            self.category.font = FontSize14;
            self.category.text = @"类别:";
            [self addSubview:self.category];
        }
        if(!self.categoryBtn){
            self.categoryBtn = [[UIButton alloc] init];
            [self.categoryBtn setTitle:@"点击选择分类" forState:UIControlStateNormal];
            [self.categoryBtn setTitleColor:grayColorPCH forState:UIControlStateNormal];
            self.categoryBtn.titleLabel.font = FontSize14;
            self.categoryBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.categoryBtn.tag = 1;
            [self addSubview:_categoryBtn];
        }
        if(!self.depreciate){
            self.depreciate = [[UILabel alloc] init];
            self.depreciate.text = @"折旧:";
            self.depreciate.font = FontSize14;
            [self addSubview:self.depreciate];
        }
        if(!self.depreciateBtn){
            self.depreciateBtn = [[UIButton alloc] init];
            [_depreciateBtn setTitle:@"点击选择折旧率" forState:UIControlStateNormal];
            [_depreciateBtn setTitleColor:grayColorPCH forState:UIControlStateNormal];
            self.depreciateBtn.tag = 2;
            _depreciateBtn.titleLabel.font = FontSize14;
            _depreciateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:self.depreciateBtn];
        }
        if(!self.remark){
            self.remark = [[UILabel alloc] init];
            self.remark.text = @"备注:";
            self.remark.font =FontSize14;
            [self addSubview:self.remark];
        }
        if(!self.remarkField){
            self.remarkField = [[UITextField alloc] init];
            //self.remarkField.text = @"可为空";
            self.remarkField.placeholder = @"可为空";
            self.remarkField.textColor = [UIColor blackColor];
            self.remarkField.font =FontSize14;
            self.remarkField.textAlignment = NSTextAlignmentLeft;
            self.remarkField.delegate = self;
            self.remarkField.tag = 6;
            [self addSubview:self.remarkField];
            [mutableArrField addObject:self.remarkField.text];
        }
        if(!self.bookImageBtn){
            self.bookImageBtn = [[UIButton alloc] init];
            self.bookImageBtn.backgroundColor = [UIColor grayColor];
            [self addSubview:self.bookImageBtn];
        }
        if(!self.publishBtn){
            self.publishBtn = [[UIButton alloc] init];
            //self.publishBtn.titleLabel.text = @"发布";
            [self.publishBtn setTitle:@"发布" forState:UIControlStateNormal];
            [self.publishBtn setBackgroundColor:orangColorPCH];
            [self addSubview:self.publishBtn];
        }
        if(!self.ISBN){
            self.ISBN = [[UILabel alloc] init];
            self.ISBN.text = @"所在学校:";
            self.ISBN.font =FontSize14;
            [self addSubview: self.ISBN];
        }
        if(!self.ISBNField){
            self.ISBNField = [[UITextField alloc] init];
            self.ISBNField.text = @"点击选择所属学校";
            self.ISBNField.font = FontSize14;
            self.ISBNField.textColor = grayColorPCH;
            //[self addSubview:self.ISBNField];
            self.ISBNField.delegate = self;
            self.ISBNField.tag = 7;
            [mutableArrField addObject:self.ISBNField.text];
        }
        //2016-09-21-18-14 add
        if(!self.schoolBtn){
            self.schoolBtn = [[UIButton alloc] init];
            self.schoolBtn.titleLabel.font = FontSize14;
            [self.schoolBtn setTitle:@"请点击选择学校" forState:UIControlStateNormal];
            [self.schoolBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self addSubview: self.schoolBtn];
        }
        if(!self.viewLine1){
            self.viewLine1 = [[UIView alloc] init];
            [self addSubview:self.viewLine1];
            self.viewLine1.backgroundColor = grayColorPCH;
        }
        if(!self.viewLine2){
            self.viewLine2 = [[UIView alloc] init];
            [self addSubview: self.viewLine2];
            self.viewLine2.backgroundColor = grayColorPCH;
        }
        if(!self.viewLine3){
            self.viewLine3 = [[UIView alloc] init];
            [self addSubview:self.viewLine3];
            self.viewLine3.backgroundColor = grayColorPCH;
        }
        if(!self.viewLine4){
            self.viewLine4 = [[UIView alloc] init];
            [self addSubview:self.viewLine4];
            self.viewLine4.backgroundColor = grayColorPCH;
        }
        if(!self.viewLine5){
            self.viewLine5 = [[UIView alloc] init];
            [self addSubview:self.viewLine5];
            self.viewLine5.backgroundColor = grayColorPCH;
        }
        if(!self.viewLine6){
            self.viewLine6 = [[UIView alloc] init];
            [self addSubview:self.viewLine6];
            self.viewLine6.backgroundColor = grayColorPCH;
        }
        if(!self.viewLineOrange){
            self.viewLineOrange = [[UIView alloc] init];
            [self addSubview:self.viewLineOrange];
            self.viewLineOrange.backgroundColor = orangColorPCH;
        }
        if(!self.ISBNClickBtn){
            self.ISBNClickBtn = [[UIButton alloc] init];
            //[self addSubview:self.ISBNClickBtn];
            [self.ISBNClickBtn setTitle:@"扫码" forState:UIControlStateNormal];
            [self.ISBNClickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    float margin = 0.02 * height;
    float labelFieldHeight = 0.08 * height;
    float wholeLabelWidth = 0.5 * width;
    float labelWidth = 0.14 * width;
    float fieldWidth = 0.36 * width;
    
    float bookName_x_offset = 0;
    float bookName_y_offset = 0;
    float bookNameWidth = 0.5 * width;
    
    self.bookName.frame = CGRectMake(bookName_x_offset, bookName_y_offset, bookNameWidth, labelFieldHeight);
    
    
    float author_x_offset = 0;
    float author_y = bookName_y_offset + labelFieldHeight;
    float authorWidth = bookNameWidth;
    
    self.author.frame = CGRectMake(author_x_offset, author_y, authorWidth, labelFieldHeight);
    
    float pressHouse_x = 0;
    float pressHouse_y = author_y + labelFieldHeight;
    float pressHouseWidth = authorWidth;
    
    self.pressHouse.frame = CGRectMake(pressHouse_x, pressHouse_y, pressHouseWidth, labelFieldHeight);
    
    float sellPrice_x = 0;
    float sellPrice_y = pressHouse_y + labelFieldHeight;
    float sellPriceWidth = pressHouseWidth;
    
    self.sellPrice.frame = CGRectMake(sellPrice_x, sellPrice_y, sellPriceWidth, labelFieldHeight);
    
    float bookImageBtn_x = 0.5 * width;
    float bookImageBtn_y = 0;
    float bookImageBtnWidth = 0.5 * width;
    float bookImageBtnHeight = 0.32 * height;
   
    self.bookImageBtn.frame = CGRectMake(bookImageBtn_x, bookImageBtn_y, bookImageBtnWidth, bookImageBtnHeight);
    
    float viewline1SepreateHeight = 0.02 * height;
    float viewline1_x = 0;
    float viewline1_y = margin + bookImageBtn_y + bookImageBtnHeight;
    float viewline1_height = viewline1SepreateHeight;
    self.viewLine1.frame = CGRectMake(viewline1_x, viewline1_y, width, viewline1_height);
    
    float originalPrice_y = margin + bookImageBtn_y + bookImageBtnHeight + viewline1SepreateHeight;
    float originalPriceWidth = labelWidth;
    
    self.originalPrice.frame = CGRectMake(0, originalPrice_y, originalPriceWidth, labelFieldHeight);
    
    float originalField_x = originalPriceWidth;
    float originalField_y = originalPrice_y;
    float originalFieldWidth = fieldWidth;
    
    self.originalPriceField.frame = CGRectMake(originalField_x, originalField_y, originalFieldWidth, labelFieldHeight);
    
    float category_x = 0.5 * width;
    float category_y = originalPrice_y;
    float categoryWidth = labelWidth;
    
    self.category.frame = CGRectMake(category_x, category_y, categoryWidth, labelFieldHeight);
    
    float categoryField_x = category_x + categoryWidth;
    float categoryField_y = category_y;
    float categoryFieldWidth = fieldWidth;
    
    self.categoryBtn.frame = CGRectMake(categoryField_x, categoryField_y, categoryFieldWidth,labelFieldHeight);
    
    //分割线
    float seprateHeight = 0.002 * height;
    float viewline2_y = categoryField_y + labelFieldHeight;
    
    self.viewLine2.frame = CGRectMake(0, viewline2_y, width, seprateHeight);
    
    float amount_x = 0;
    float amount_y = categoryField_y + labelFieldHeight + seprateHeight;
    
    self.amount.frame = CGRectMake(amount_x, amount_y, labelWidth, labelFieldHeight);
    
    float amountField_x = labelWidth;
    float amountField_y = amount_y;
    
    self.amountField.frame = CGRectMake(amountField_x, amountField_y, fieldWidth, labelFieldHeight);
    
    float depreciate_x = wholeLabelWidth;
    float depreciate_y = amountField_y;
    
    self.depreciate.frame = CGRectMake(depreciate_x, depreciate_y, labelWidth, labelFieldHeight);
    
    float depreciateField_x = depreciate_x + labelWidth;
    float depreciateField_y = depreciate_y;
    
    self.depreciateBtn.frame = CGRectMake(depreciateField_x, depreciateField_y, fieldWidth, labelFieldHeight);
    
    //分割线
    float viewline3_y = depreciateField_y + labelFieldHeight;
    self.viewLine3.frame = CGRectMake(0, viewline3_y, width, seprateHeight);
    
    float remark_x = 0;
    float remark_y = depreciateField_y + labelFieldHeight + seprateHeight;
    
    self.remark.frame = CGRectMake(remark_x, remark_y, labelWidth, labelFieldHeight);
    
    float remarkField_x = labelWidth;
    float remarkField_y = remark_y;
    float remarkFieldWidth = width - labelWidth;
    
    self.remarkField.frame = CGRectMake(remarkField_x, remarkField_y, remarkFieldWidth, labelFieldHeight);
    
    //分割线
    float viewline4_y = remark_y + labelFieldHeight;
    self.viewLine4.frame = CGRectMake(0, viewline4_y, width, seprateHeight);
    
    float ISBN_x = 0;
    float ISBN_y = remarkField_y + labelFieldHeight + seprateHeight;
    
    self.ISBN.frame = CGRectMake(ISBN_x, ISBN_y, labelWidth + 10, labelFieldHeight);
    
    float ISBNField_x = labelWidth + 15;
    float ISBNField_y = ISBN_y;
    float ISBNFieldWidth = width - 2 * labelWidth;
    
    
    self.ISBNField.frame = CGRectMake(ISBNField_x, ISBNField_y, ISBNFieldWidth, labelFieldHeight);
    self.schoolBtn.frame = CGRectMake(ISBNField_x, ISBNField_y, ISBNFieldWidth, labelFieldHeight);
    //分割线
    self.ISBNClickBtn.frame = CGRectMake(ISBNField_x + ISBNFieldWidth, ISBNField_y, labelWidth, labelFieldHeight);
    float viewline5_y = ISBNField_y + labelFieldHeight;
    self.viewLine5.frame = CGRectMake(0, viewline5_y, width, seprateHeight);
    
    float publishBtn_x = 0.1 * width;
    float publishBtn_y = ISBNField_y + labelFieldHeight + margin + seprateHeight;
    float publsihBtnWidth = 0.8 * width;
    
    self.publishBtn.frame = CGRectMake(publishBtn_x, publishBtn_y, publsihBtnWidth, labelFieldHeight);
    
}

//关闭键盘 UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击空白处关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    NSLog(@"beging--%ld", (long)textField.tag);
//    self.fieldStr = textField.text;
//    textField.text = @"";
//    textField.textColor = [UIColor blackColor];
//    return YES;
//}
//
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    NSLog(@"end--%ld", (long)textField.tag);
//    if(!textField.text.length){
//        textField.text = [mutableArrField objectAtIndex:textField.tag];
//        textField.textColor = [UIColor lightGrayColor];
//    }
//    return YES;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
