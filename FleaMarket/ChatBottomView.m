//
//  ChatBottomView.m
//  FleaMarket
//
//  Created by Hou on 5/17/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "ChatBottomView.h"

@interface ChatBottomView ()

@end

@implementation ChatBottomView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
//        self.voiceBtn = [[UIButton alloc] init];
//        [self.voiceBtn setBackgroundImage:[UIImage imageNamed:@"micphone.jpg"] forState:UIControlStateNormal];
//        //声音按钮
//        //[self addSubview:_voiceBtn];
//        
//        self.smileBtn = [[UIButton alloc] init];
//        [self.smileBtn setBackgroundImage:[UIImage imageNamed:@"smile.jpg"] forState:UIControlStateNormal];
//        //[self addSubview:_smileBtn];
//        
//        self.addBtn = [[UIButton alloc] init];
//        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"plus.jpg"] forState:UIControlStateNormal];
//        [self.addBtn setBackgroundColor:[UIColor blueColor]];
//        [self addSubview:_addBtn];
        
        UIButton *sendButton = [[UIButton alloc] init];
        [sendButton setTitle:@"发送" forState: UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        [sendButton setBackgroundColor:[UIColor blueColor]];
        self.sendBtn = sendButton;
        [self addSubview: self.sendBtn];
        //文本控件区
        self.textField = [[UITextField alloc] init];
        [self addSubview:_textField];
        self.backgroundColor = whiteSmokePCH;
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    float viewHeight = self.frame.size.height;
//    float viewWidth = self.frame.size.width;
//    float gapPer = 0.05;
//    float margin_x_per = 0.02;
//    
//    float voiceBtn_x_offset = viewWidth * margin_x_per;
//    float voiceBtn_y_offset = viewHeight * 0.2;
//    float voiceBtnHeight = viewHeight * 0.6;
//    float voiceBtnWidth = voiceBtnHeight;
//    //声音按钮
//    self.voiceBtn.frame = CGRectMake(voiceBtn_x_offset, voiceBtn_y_offset, voiceBtnWidth, voiceBtnHeight);
//    
//    float addBtn_x_offset = viewWidth - voiceBtn_x_offset - voiceBtnWidth;
//    float addBtn_y_offset = voiceBtn_y_offset;
//    float addBtnWidth = voiceBtnWidth;
//    float addBtnHeight = voiceBtnHeight;
//    //加号按钮
//    self.addBtn.frame = CGRectMake(addBtn_x_offset, addBtn_y_offset, addBtnWidth, addBtnHeight);
//    
//    float smileBtn_x_offset = viewWidth - voiceBtn_x_offset - viewWidth * gapPer - 2 * addBtnWidth;
//    float smileBtn_y_offset = addBtn_y_offset;
//    float smileBtnWidth = voiceBtnWidth;
//    float smileBtnHeight = voiceBtnHeight;
//    //表情按钮
//    self.smileBtn.frame = CGRectMake(smileBtn_x_offset, smileBtn_y_offset, smileBtnWidth, smileBtnHeight);
    
//    float textField_x_offset = voiceBtn_x_offset + voiceBtnWidth + gapPer * viewWidth;
//    float textField_y_offset = 0.1 *viewHeight;
//    float textFieldWidth = viewWidth - 3 * voiceBtnWidth - 3 *gapPer *viewWidth - 2 *voiceBtn_x_offset;
//    float textFieldHeight = 0.8 * viewHeight;
//    //textField 文本输入区
//    self.textField.frame = CGRectMake(textField_x_offset, textField_y_offset, textFieldWidth, textFieldHeight);
//    self.textField.layer.masksToBounds = YES;
//    self.textField.layer.cornerRadius = 5;
//    self.textField.layer.borderColor = [UIColor grayColor].CGColor;
//    self.textField.backgroundColor = [UIColor whiteColor];
    //2016-09-21-11-32 modify
    
    float sendBtn_w = 70.0f;
    float sendBtn_h = 0.8 * viewHeight;
    float margin = 20.0f;
    
    float textField_x_offset = 20.0f;
    float textField_y_offset = 0.1 * viewHeight;
    float textFieldWidth = screenWidthPCH - 3 * margin - sendBtn_w;
    float textFieldHeight = 0.8 * viewHeight;
    //textField 文本输入区
    self.textField.frame = CGRectMake(textField_x_offset, textField_y_offset, textFieldWidth, textFieldHeight);
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 8.0f;
    self.textField.layer.borderColor = [UIColor blackColor].CGColor;
    self.textField.backgroundColor = [UIColor whiteColor];
    
    float sendBtn_x = textFieldWidth + 2 * margin;
    float sendBtn_y = 0.1 * viewHeight;
    
    self.sendBtn.frame = CGRectMake(sendBtn_x, sendBtn_y, sendBtn_w, sendBtn_h);
    //self.sendBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.sendBtn.layer.borderWidth = 1.0f;
    self.sendBtn.layer.cornerRadius = 8.0f;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
