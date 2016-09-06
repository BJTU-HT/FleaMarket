//
//  LeaveMessageVC.m
//  FleaMarket
//
//  Created by Hou on 8/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "LeaveMessageVC.h"
#import <BmobSDK/BmobUser.h>
#import "publicSearchBL.h"
#import "presentLayerPublicMethod.h"

@interface LeaveMessageVC ()

@end

@implementation LeaveMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.activityIndicatorViewLM stopAnimating];
}

-(void)passDicFromSecondToLM:(NSMutableDictionary *)mudic{
    _mudicLM = [[NSMutableDictionary alloc] init];
    _mudicLM = mudic;
    if(!_contentArrMu){
        _contentArrMu = [[NSMutableArray alloc] init];
    }
    [_contentArrMu setArray: [_mudicLM objectForKey:@"contentArr"]];
}

-(void)initializeView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    float textView_x = 10;
    float textView_y = 10 + navStatusBarHeightPCH;
    float textView_width = screenWidthPCH - 2 * textView_x;
    float textView_height = screenHeightPCH * 0.2;
    CGRect textViewFrame = CGRectMake(textView_x, textView_y, textView_width, textView_height);
    _textView = [[UITextView alloc] initWithFrame: textViewFrame];
    _textView.delegate = self;
    [self.view addSubview: _textView];
    _textView.font = FontSize12;
    _textView.layer.borderColor = orangColorPCH.CGColor;
    _textView.layer.cornerRadius = 10.0f;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.masksToBounds = YES;
    
    _labelText = [[UILabel alloc] init];
    _labelText.text = @"最多输入255个字符";
    _labelText.font = FontSize12;
    _labelText.textColor = grayColorPCH;
    [self.view insertSubview:_labelText atIndex:1];
    _labelText.frame = CGRectMake(textView_x + 5, textView_y + 10, 200, 15);
    _labelText.enabled = NO;
    _labelText.backgroundColor = [UIColor clearColor];
    
    float btn_x = textView_x;
    float btn_y = textView_y + textView_height + 15;
    float btn_width = textView_width;
    float btn_height = 40;
    _pubMesBtn = [[UIButton alloc] initWithFrame:CGRectMake(btn_x, btn_y, btn_width, btn_height)];
    _pubMesBtn.backgroundColor = orangColorPCH;
    _pubMesBtn.titleLabel.textColor = [UIColor whiteColor];
    _pubMesBtn.titleLabel.font = FontSize16;
    _pubMesBtn.layer.cornerRadius = 6.0f;
    _pubMesBtn.layer.masksToBounds = YES;
    [self.view addSubview:_pubMesBtn];
    [_pubMesBtn addTarget:self action:@selector(pubMesBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [_pubMesBtn setTitle:@"发布留言" forState:UIControlStateNormal];
}

-(void)pubMesBtnClicked:(UIButton *)sender{
    [self requestDataFromServerLM];
    [self.activityIndicatorViewLM startAnimating];
}

-(void)requestDataFromServerLM{
    BmobUser *curUser = [BmobUser getCurrentUser];
    if(!_mudicContentTemp){
        _mudicContentTemp = [[NSMutableDictionary alloc] init];
    }
    [_mudicContentTemp setObject:self.textView.text forKey:@"content"];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    if(dateString){
        [_mudicContentTemp setObject:dateString forKey:@"publishTime"];
    }
    if(curUser.username){
        [_mudicContentTemp setObject: curUser.username forKey:@"userName"];
    }
    if([_mudicLM objectForKey:@"objectId"]){
        [_mudicContentTemp setObject:[_mudicLM objectForKey:@"objectId"] forKey:@"product_id"];
    }
    if([_mudicLM objectForKey:@"userName"]){
        [_mudicContentTemp setObject:[_mudicLM objectForKey:@"userName"] forKey:@"to_userName"];
    }
    publicSearchBL *pubS = [publicSearchBL sharedManager];
    pubS.delegatePSBL = self;
    [pubS leaveMessageRequestBL:_mudicContentTemp];
}

//leave message delegate
-(void)leaveMesFinishedBL:(NSString *)headURL{
    bookDetailVC *bookDVC = [[bookDetailVC alloc] init];
    self.delegateBPDD = bookDVC;
    if(headURL)
        [_mudicContentTemp setObject:headURL forKey:@"avatarLM"];
    if(_mudicContentTemp)
        [_contentArrMu addObject:_mudicContentTemp];
    if(_contentArrMu)
        [_mudicLM setObject:_contentArrMu forKey:@"contentArr"];
    [self.delegateBPDD passMudicValueLMToSecond:_mudicLM];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)leaveMesFailedBL:(NSError *)error{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"留言上传失败"];
}
//delegate method
-(void)textViewDidChange:(UITextView *)textView{
    if(_textView.text.length == 0){
        _labelText.text = @"最多输入255个字符";
    }else{
        _labelText.text = @"";
    }
}

//下面这段搞定键盘关闭。点return 果断关闭键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//点击空白处关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//_activityIndicatorViewLM setter method
- (UIActivityIndicatorView *)activityIndicatorViewLM
{
    if (!_activityIndicatorViewLM) {
        _activityIndicatorViewLM = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_activityIndicatorViewLM setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicatorViewLM setBackgroundColor:[UIColor blackColor]];
        _activityIndicatorViewLM.center = self.view.center;
        [self.view addSubview:_activityIndicatorViewLM];
    }
    return _activityIndicatorViewLM;
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
