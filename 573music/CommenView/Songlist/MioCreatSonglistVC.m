//
//  MioCreatSonglistVC.m
//  573music
//
//  Created by Mimio on 2020/12/29.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioCreatSonglistVC.h"
#import "HXPhotoPicker.h"
#import "XMTextView.h"
#import <LEEAlert.h>
#import <AFHTTPSessionManager.h>

@interface MioCreatSonglistVC ()
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *introLab;
@property (nonatomic, strong) XMTextView *noteTV;
@property (nonatomic, strong) HXPhotoManager *avatarManger;
@property (nonatomic, strong) NSString *avatarPath;
@end

@implementation MioCreatSonglistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = NO;
    WEAKSELF;
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"创建歌单" forState:UIControlStateNormal];
    [self.navView.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.navView.rightButton setTitleColor:color_main forState:UIControlStateNormal];
    self.navView.rightButtonBlock = ^{
        [weakSelf creatSonglist];
    };
    
    _avatarPath = @"";
    [self creatUI];
}

-(void)creatUI{
    UIView *bgView = [UIView creatView:frame(Mar, NavH + 12, KSW_Mar2 , 44*2 + 200 + 60) inView:self.view bgColor:color_card radius:6];
    
    NSArray *titleArr = @[@"封面",@"名称",@"简介",@""];
    NSArray *heightArr = @[@60,@44,@44,@200];
    NSArray *topArr = @[@0,@60,@104,@148];
    for (int i = 0; i < titleArr.count ; i++) {
        
        UIView *infoView = [UIView creatView:frame(0, [topArr[i] intValue], KSW_Mar2, [heightArr[i] intValue]) inView:bgView bgColor:appClearColor radius:8];
        infoView.tag = i+100;
        UILabel *titleLab = [UILabel creatLabel:frame(12, [heightArr[i] intValue]/2 - 22, 100, 44) inView:infoView text:titleArr[i] color:color_text_one size:16 alignment:NSTextAlignmentLeft];
        UIView *split = [UIView creatView:frame(10, [topArr[i] intValue] + [heightArr[i] intValue], KSW_Mar2 - 20, 0.5) inView:bgView bgColor:color_split radius:0];
        if (i < 2) {
            MioImageView *arrow = [MioImageView creatImgView:frame(KSW_Mar2 - 20 - 12 , [heightArr[i] intValue]/2 - 10, 20, 20) inView:infoView image:@"right" bgTintColorName:name_icon_three radius:0];
        }
        
        [infoView whenTapped:^{
            [self clickInfo:infoView];
        }];
        
    }
    _avatar = [UIImageView creatImgView:frame(KSW_Mar2 - 39 - 48, 6, 48, 48) inView:[bgView viewWithTag:100] image:@"qxt_yinyue" radius:24];
    ;
    
    _nameLab = [UILabel creatLabel:frame(KSW_Mar2 - 39 - 200 , 0, 200, 44) inView:[bgView viewWithTag:101] text:@"" color:color_text_two size:15 alignment:NSTextAlignmentRight];

  
    _noteTV = [[XMTextView alloc] initWithFrame:CGRectMake(0, 0, KSW_Mar2 , 200)];
    _noteTV.textFont = [UIFont systemFontOfSize:14];
    _noteTV.textColor = color_text_two;
    _noteTV.textMaxNum = 200;
    _noteTV.isSetBorder = NO;
    _noteTV.placeholderColor = color_text_two;
    _noteTV.maxNumColor = color_text_two;
    _noteTV.textView.backgroundColor = appClearColor;
    _noteTV.backgroundColor = appClearColor;
    ViewRadius(_noteTV, 8);
    [[bgView viewWithTag:103] addSubview:_noteTV];
}

-(void)clickInfo:(UIView *)view{
    if (Equals(view.tag, 100)) {//头像
        [self selectAvatar];
    }
    if (Equals(view.tag, 101)) {//昵称
        XMTextView *noteTV = [[XMTextView alloc] initWithFrame:CGRectMake(0, 0, 240, 70)];
        noteTV.textFont = [UIFont systemFontOfSize:14];
        noteTV.textColor = subColor;
        noteTV.textMaxNum = 20;
        noteTV.isSetBorder = YES;
        noteTV.borderLineWidth = 0.5;
        noteTV.placeholderColor = grayTextColor;
        noteTV.maxNumColor = grayTextColor;

        ViewRadius(noteTV, 8);
        [LEEAlert alert].config
        .LeeTitle(@"歌单名称")
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = noteTV;
            custom.isAutoWidth = YES;
        })
        .LeeCancelAction(@"取消", nil)
        .LeeAction(@"确认", ^{
            if (noteTV.tempText.length == 0) {
                [UIWindow showInfo:@"名称不能为空"];
                return;
            }
            _nameLab.text = noteTV.tempText;
        })
        .LeeShow();
    }

    if (Equals(view.tag, 102)) {//签名

        
    }
}

-(void)creatSonglist{
    
    if (_avatarPath.length < 2) {
        [UIWindow showInfo:@"请选择封面"];
        return;
    }
    if (_nameLab.text.length < 2) {
        [UIWindow showInfo:@"输入一个2-20个字符的名称"];
        return;
    }
    
    NSDictionary *dic = @{
        @"cover_image_path":_avatarPath,
        @"title":_nameLab.text,
        @"song_list_description":_noteTV.tempText,
    };

    [MioPostReq(api_songLists, dic) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        [UIWindow showSuccess:@"创建成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}


#pragma mark - 选择照片
-(void)selectAvatar{
    WEAKSELF;
    [self hx_presentSelectPhotoControllerWithManager:self.avatarManger didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        HXPhotoModel *model = photoList.firstObject;
        _avatar.image = model.previewPhoto;
        [self uploadPhoto:model.previewPhoto];
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSSLog(@"block - 取消了");
    }];
}

- (HXPhotoManager *)avatarManger {
    if (!_avatarManger) {
        _avatarManger = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _avatarManger.configuration.singleSelected = YES;
        _avatarManger.configuration.singleJumpEdit = YES;
        _avatarManger.configuration.cameraPhotoJumpEdit = YES;
        _avatarManger.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_1x1;
    }
    return _avatarManger;
}

- (void)uploadPhoto:(UIImage *)image
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager POST:api_uploadPic parameters:@{@"dir":@"songlist"}
       headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:data name:@"file" fileName:@"11" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
      
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _avatarPath = responseObject[@"data"][@"path"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@", error);
    }];
}



@end
