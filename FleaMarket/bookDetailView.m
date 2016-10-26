//
//  bookDetailView.m
//  FleaMarket
//
//  Created by Hou on 8/2/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "bookDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <BmobSDK/BmobUser.h>
#import "presentLayerPublicMethod.h"

@implementation bookDetailView
NSIndexPath *indexPathGlobal;
float heightDetail;
float widthDeatail;
-(instancetype)initWithFrame:(CGRect)frame index:(NSIndexPath *)indexPath{
    self = [super initWithFrame: frame];
    heightDetail = self.frame.size.height;
    widthDeatail = self.frame.size.width;
    indexPathGlobal = indexPath;
    if(self){
        if(indexPath.section == 0){
            if(!_schoolS0){
                _schoolS0 = [[UILabel alloc] init];
                _schoolS0.font = FontSize12;
                _schoolS0.textColor = [UIColor grayColor];
                [self addSubview:_schoolS0];
            }
            if(!_headImageViewS0){
                _headImageViewS0 = [[UIImageView alloc] init];
                [self addSubview:_headImageViewS0];
            }
            if(!_userNameS0){
                _userNameS0 = [[UILabel alloc] init];
                [self addSubview:_userNameS0];
                _userNameS0.font = FontSize12;
            }
            if(!_btnConcernS0){
                _btnConcernS0 = [[UIButton alloc] init];
                [self addSubview:_btnConcernS0];
                _btnConcernS0.titleLabel.font = FontSize12;
                //201609261124 modify
                //_btnConcernS0.backgroundColor = orangColorPCH;
                //_btnConcernS0.titleLabel.textColor = [UIColor whiteColor];
            }
        }else if(indexPath.section == 1){
            if(!_bookDisViewS1){
                _bookDisViewS1 = [[bookDisplayCellView alloc] init];
                [self addSubview:_bookDisViewS1];
            }
            if(!_labelS1){
                _labelS1 = [[UILabel alloc] init];
                [self addSubview: _labelS1];
                _labelS1.font = FontSize12;
                _labelS1.textColor = [UIColor grayColor];
            }
        }else if(indexPath.section == 2){
            if(!_viewLineS2){
                _viewLineS2 = [[UIView alloc] init];
                [self addSubview:_viewLineS2];
                _viewLineS2.backgroundColor = orangColorPCH;
            }
            if(!_labelS2){
                _labelS2 = [[UILabel alloc] init];
                [self addSubview:_labelS2];
                _labelS2.text = @"最近访客";
                _labelS2.font = FontSize12;
            }
            if(!_scrollViewS2){
                _scrollViewS2 = [[UIScrollView alloc] init];
                [self addSubview:_scrollViewS2];
            }
        }else if(indexPath.section == 3){
            if(!_viewLineS3){
                _viewLineS3 = [[UIView alloc] init];
                [self addSubview:_viewLineS3];
                _viewLineS3.backgroundColor = orangColorPCH;
            }
            if(!_labelS3){
                _labelS3 = [[UILabel alloc] init];
                [self addSubview: _labelS3];
                _labelS3.font =FontSize12;
                _labelS3.text = @"留言";
            }
        }
    }
    return self;
}

-(CGFloat)layoutSubviews:(NSIndexPath *)indexPath data:(NSMutableDictionary *)mudic{
    _recMudicBD = [[NSMutableDictionary alloc] init];
    _recMudicBD = mudic;
    if(indexPathGlobal.section == 0){
       return [self layoutS0View:mudic];
    }else if(indexPathGlobal.section == 1){
        return [self layoutS1View:indexPath data:mudic];
    }else if(indexPathGlobal.section == 2){
        return [self layoutS2View: indexPath data:mudic];
    }else if(indexPathGlobal.section == 3){
       return [self layoutS3View:indexPath data: mudic];
    }
    return 0;
}

-(CGFloat)layoutS1View:(NSIndexPath *)indexPath data:(NSMutableDictionary *)mudic{
    if(indexPath.row == 0){
        return [_bookDisViewS1 layoutViewSelf:mudic];
    }else if(indexPath.row == 1){
        return [self drawSection1Row1:mudic];
    }
    return 0;
}

-(CGFloat)drawSection1Row1:(NSMutableDictionary *)mudic{
    float labelS1_x = 10;
    float labelS1_y = 0;
    float labelS1Width = screenWidthPCH - 2 * labelS1_x;
    NSString *strDefault = @"备注: ";
    NSString *str = [strDefault stringByAppendingString: [mudic objectForKey:@"remark"]];
    _labelS1.text = str;
    _labelS1.textColor = [UIColor blackColor];
    CGSize titleSizeLabelS1 = [_labelS1.text boundingRectWithSize:CGSizeMake(labelS1Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    if(titleSizeLabelS1.height < 45){
        titleSizeLabelS1.height = 45;
    }
    _labelS1.frame = CGRectMake(labelS1_x, labelS1_y, labelS1Width, titleSizeLabelS1.height);
    
    return titleSizeLabelS1.height;
}

-(CGFloat)layoutS3View:(NSIndexPath *)indexPath data:(NSMutableDictionary *)mudic{
    float marginS3 = 0;
    float marginVertialS3 = 10.0;
    if(indexPath.row == 0){
        float viewLineS2_x = marginS3;
        float viewLineS2_y = marginVertialS3;
        float viewLineS2Width = 3.0;
        float viewLineS2Height = heightDetail - 2 * marginVertialS3;
        _viewLineS3.frame = CGRectMake(viewLineS2_x, viewLineS2_y, viewLineS2Width, viewLineS2Height);
        
        float labelS2_x = marginVertialS3 + viewLineS2_x + viewLineS2Width;
        float labelS2Width = widthDeatail - labelS2_x;
        _labelS3.frame = CGRectMake(labelS2_x, viewLineS2_y, labelS2Width, viewLineS2Height);
    }else if(indexPath.row == 1){
        
    }
    return 0;
}

//最近访客数据
-(CGFloat)layoutS2View:(NSIndexPath *)indexPath data:(NSMutableDictionary *)mudic{
    float margin = 0.0;
    float marginVertial = 10.0;
    float viewLineS2_x = margin;
    float viewLineS2_y = marginVertial;
    float viewLineS2Width = 3.0;
    float viewLineS2Height = heightDetail - 2 * marginVertial;
    if(indexPath.row == 0){
        _viewLineS2.frame = CGRectMake(viewLineS2_x, viewLineS2_y, viewLineS2Width, viewLineS2Height);
        float labelS2_x = marginVertial + viewLineS2_x + viewLineS2Width;
        float labelS2Width = widthDeatail - labelS2_x;
        _labelS2.frame = CGRectMake(labelS2_x, viewLineS2_y, labelS2Width, viewLineS2Height);
    }else if(indexPath.row == 1){
        _scrollViewS2.frame = CGRectMake(0, 0, widthDeatail, heightDetail);
        _scrollViewS2.delegate = self;
        _scrollViewS2.contentSize = CGSizeMake(widthDeatail, heightDetail);
        _scrollViewS2.showsVerticalScrollIndicator = NO;
        NSArray *arrURL = [mudic objectForKey:@"visitorURLArr"];
        if(arrURL){
            dispatch_async(dispatch_get_main_queue(), ^{
                for(int i = 0; i < arrURL.count; i++){
                UIImageView *headImageView = [[UIImageView alloc] init];
                float visitorImage_height = viewLineS2Height;
                float visitorImage_width = visitorImage_height;
                headImageView.frame = CGRectMake(5 * i + i * visitorImage_width, viewLineS2_y, visitorImage_width, visitorImage_height);
                NSURL *urlImage = [NSURL URLWithString:[arrURL objectAtIndex:i]];
                [headImageView sd_setImageWithURL:urlImage];
                [_scrollViewS2 addSubview: headImageView];
            }
        });
    }
    }
    return 0;
}

-(CGFloat)layoutS0View:(NSMutableDictionary *)mudic{

    float margin = 0.1 * heightDetail;
    float headImageWidth = heightDetail - 2 * margin;
    float headImageHeight = headImageWidth;
    float headImage_x = 15;
    CGRect headImageFrame = CGRectMake(headImage_x, margin, headImageWidth, headImageHeight);
    _headImageViewS0.frame = headImageFrame;
    [_headImageViewS0 sd_setImageWithURL:[NSURL URLWithString:[mudic objectForKey:@"userHeadImageURL"]] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];
    
    float bookUserName_x = headImageWidth + 2 * margin + headImage_x;
    float bookUserNameWidth = widthDeatail/2;
    float bookUserNameHeight = 0.4 * heightDetail;
    _userNameS0.frame = CGRectMake(bookUserName_x, margin, bookUserNameWidth, bookUserNameHeight);
    _userNameS0.text = [mudic objectForKey:@"userName"];
    _nameStr = _userNameS0.text;
    
    float bookPubTime_y = bookUserNameHeight + margin;
    float bookPubTimeHeight = bookUserNameHeight;
    _schoolS0.frame =CGRectMake(bookUserName_x, bookPubTime_y, bookUserNameWidth, bookPubTimeHeight);
    _schoolS0.text = [mudic objectForKey:@"school"];
    
    float schoolLabel_x = widthDeatail/2 + bookUserName_x;
    float schoolLabelWidth = widthDeatail/2 - 15 - bookUserName_x;
    float schoolLabelHeight = 0.4 * heightDetail;
    float schoolLabel_y = 0.3 * heightDetail;
    
    _btnConcernS0.frame = CGRectMake(schoolLabel_x, schoolLabel_y, schoolLabelWidth, schoolLabelHeight);
    [_btnConcernS0 setTitle:@"加关注" forState: UIControlStateNormal];
    _btnConcernS0.titleLabel.font =FontSize12;
    [_btnConcernS0 addTarget:self action:@selector(btnConcernClicked:) forControlEvents:UIControlEventTouchDown];
    [_btnConcernS0 setTitleColor: orangColorPCH forState:UIControlStateNormal];
    _btnConcernS0.layer.cornerRadius = 0.0f;
    _btnConcernS0.layer.borderColor = orangColorPCH.CGColor;
    _btnConcernS0.layer.borderWidth = 1.0f;
    _btnConcernS0.layer.masksToBounds = YES;
    BmobUser *curUser = [BmobUser getCurrentUser];
    if([curUser.objectId isEqualToString:[mudic objectForKey:@"ownerObjectId"]]){
        [_btnConcernS0 setTitle:@"已关注" forState: UIControlStateNormal];
        [_btnConcernS0 setBackgroundColor:[UIColor clearColor]];
        [_btnConcernS0 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnConcernS0.layer.borderColor = [UIColor whiteColor].CGColor;

    }else{
        [self requestConcernedDataFromServer:curUser.objectId];
    }
    return 0;
}

//从用户表获取关注的人
-(void)requestConcernedDataFromServer:(NSString *)objectId{
    concernBL *conBL = [concernBL sharedManager];
    conBL.delegate = self;
    [conBL requestConcernedDataBL:objectId];
}

-(void)btnConcernClicked:(UIButton *)sender{
    BmobUser *curUser = [BmobUser getCurrentUser];
    NSMutableDictionary *mudic = [[NSMutableDictionary alloc] init];
    if([_recMudicBD objectForKey:@"ownerObjectId"]){
        [mudic setObject:[_recMudicBD objectForKey:@"ownerObjectId"] forKey:@"concernedObjectId"];
    }
    if([_recMudicBD objectForKey:@"userName"]){
        [mudic setObject:[_recMudicBD objectForKey:@"userName"] forKey:@"concernedUserName"];
    }
    if([_recMudicBD objectForKey:@"userHeadImageURL"]){
        [mudic setObject:[_recMudicBD objectForKey:@"userHeadImageURL"] forKey:@"concernedAvatar"];
    }
    if([_recMudicBD objectForKey:@"school"]){
        [mudic setObject:[_recMudicBD objectForKey:@"school"] forKey:@"concernedSchool"];
    }
    if(curUser.objectId)
        [mudic setObject:curUser.objectId forKey:@"currentUserObjectId"];
    if([_recMudicBD objectForKey:@"exchangeCategory"])
    [mudic setObject:[_recMudicBD objectForKey:@"exchangeCategory"] forKey:@"exchangeCategory"];
    concernBL *conBL = [concernBL sharedManager];
    conBL.delegate = self;
    [conBL updateConcernedDataBL:mudic];
}

-(void)concernedUserUploadFailedBL:(NSError *)error{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"服务器连接失败..." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertCon addAction:action];
    [self.window.rootViewController presentViewController:alertCon animated:YES completion:nil];
}

-(void)concernedUserUploadFinishedBL:(BOOL)value{
    if(value){
        [_btnConcernS0 setTitle:@"已关注" forState: UIControlStateNormal];
        [_btnConcernS0 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_btnConcernS0 setBackgroundColor:[UIColor clearColor]];
        _btnConcernS0.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

#pragma 从用户表获取关注的数据代理函数 begin
-(void)concernedDataRequestFinishedBL:(NSArray *)arr{
    NSString *ownerObjectId = [_recMudicBD objectForKey:@"ownerObjectId"];
    BOOL concernTag;

    if(![arr isEqual:@""]){
        if(arr){
            for(int i = 0; i < arr.count; i++){
                NSMutableDictionary *mudic = [arr objectAtIndex:i];
                if([[mudic objectForKey:@"concernedObjectId"] isEqualToString:ownerObjectId]){
                    concernTag = 1;
                    break;
                }
            }
        }
        if(concernTag){
            [_btnConcernS0 setTitle:@"已关注" forState: UIControlStateNormal];
            [_btnConcernS0 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_btnConcernS0 setBackgroundColor:[UIColor clearColor]];
            _btnConcernS0.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }
}

-(void)concernedDataRequestFailedBL:(NSError *)error{
    //[presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"未能添加关注"];
}
-(void)cocnernedDataRequestNODataBL:(BOOL)value{
    NSLog(@"Concerned no data");
}

#pragma 从用户表获取关注的数据代理函数 end
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
