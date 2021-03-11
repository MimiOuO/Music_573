//
//  MioEditInfoVC.m
//  573music
//
//  Created by Mimio on 2020/12/16.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioEditInfoVC.h"
#import "HXPhotoPicker.h"
#import "XMTextView.h"
#import <LEEAlert.h>
#import <AFHTTPSessionManager.h>
#import "MioChooseFavoriteTagView.h"

@interface MioEditInfoVC ()<favoriteDelegate>
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel *signLab;
@property (nonatomic, strong) UILabel *genderLab;
@property (nonatomic, strong) UILabel *favoriteLab;
@property (nonatomic, strong) HXPhotoManager *avatarManger;

@end

@implementation MioEditInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    [self creatUI];
}

-(void)creatUI{
    UIView *bgView = [UIView creatView:frame(Mar, NavH + 12, KSW_Mar2 , 44*4 + 64 + 60) inView:self.view bgColor:color_card radius:6];
    
    NSArray *titleArr = @[@"头像",@"昵称",@"性别",@"我想听",@"个性签名",@""];
    NSArray *heightArr = @[@60,@44,@44,@44,@44,@64];
    NSArray *topArr = @[@0,@60,@104,@148,@192,@236];
    for (int i = 0; i < titleArr.count ; i++) {
        
        UIView *infoView = [UIView creatView:frame(0, [topArr[i] intValue], KSW_Mar2, [heightArr[i] intValue]) inView:bgView bgColor:appClearColor radius:8];
        infoView.tag = i+100;
        UILabel *titleLab = [UILabel creatLabel:frame(12, [heightArr[i] intValue]/2 - 22, 100, 44) inView:infoView text:titleArr[i] color:color_text_one size:16 alignment:NSTextAlignmentLeft];
        UIView *split = [UIView creatView:frame(10, [topArr[i] intValue] + [heightArr[i] intValue], KSW_Mar2 - 20, 0.5) inView:bgView bgColor:color_split radius:0];
        if (i < 5) {
            MioImageView *arrow = [MioImageView creatImgView:frame(KSW_Mar2 - 20 - 12 , [heightArr[i] intValue]/2 - 10, 20, 20) inView:infoView image:@"right" bgTintColorName:name_icon_three radius:0];
        }
        
        [infoView whenTapped:^{
            [self clickInfo:infoView];
        }];
        
    }
    _avatar = [UIImageView creatImgView:frame(KSW_Mar2 - 39 - 48, 6, 48, 48) inView:[bgView viewWithTag:100] image:@"" radius:24];
    [_avatar sd_setImageWithURL:_user.avatar.mj_url placeholderImage:image(@"qxt_yonhu")];
    
    _nickNameLab = [UILabel creatLabel:frame(KSW_Mar2 - 39 - 200 , 0, 200, 44) inView:[bgView viewWithTag:101] text:_user.nickname color:color_text_two size:15 alignment:NSTextAlignmentRight];

    _genderLab = [UILabel creatLabel:frame(KSW_Mar2 - 39 - 200 , 0, 200, 44) inView:[bgView viewWithTag:102] text:((_user.gender == 1) ? (@"男") :(_user.gender == 0 ? @"女" : @"")) color:color_text_two size:15 alignment:NSTextAlignmentRight];
    _favoriteLab = [UILabel creatLabel:frame(KSW_Mar2 - 39 - 200 , 0, 200, 44) inView:[bgView viewWithTag:103] text:[_user.favorite_tags componentsJoinedByString:@"、"] color:color_text_two size:15 alignment:NSTextAlignmentRight];
    _signLab = [UILabel creatLabel:frame(12 , 12, KSW_Mar2 - 24, 60) inView:[bgView viewWithTag:105] text:_user.sign.length > 0?_user.sign:@"暂时还没有个性签名哦..." color:color_text_two size:15 alignment:NSTextAlignmentLeft];
    _signLab.numberOfLines = 2;
    _signLab.height = [_signLab.text heightForFont:Font(14) width:KSW_Mar2 - 24];
}

-(void)clickInfo:(UIView *)view{
    if (Equals(view.tag, 100)) {//头像
        [self selectAvatar];
    }
    if (Equals(view.tag, 101)) {//昵称
        XMTextView *noteTV = [[XMTextView alloc] initWithFrame:CGRectMake(0, 0, 240, 70)];
        noteTV.textFont = [UIFont systemFontOfSize:14];
        noteTV.textColor = subColor;
        noteTV.textMaxNum = 12;
        noteTV.isSetBorder = YES;
        noteTV.borderLineWidth = 0.5;
        noteTV.placeholderColor = grayTextColor;
        noteTV.maxNumColor = grayTextColor;
        ViewRadius(noteTV, 8);
        [LEEAlert alert].config
        .LeeTitle(@"修改昵称")
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = noteTV;
            custom.isAutoWidth = YES;
        })
        .LeeCancelAction(@"取消", nil)
        .LeeAction(@"确认", ^{
            if (noteTV.tempText.length == 0) {
                [UIWindow showInfo:@"昵称不能为空"];
                return;
            }
            [self modifyInfoKey:@"nickname" andValue:noteTV.tempText];
            _nickNameLab.text = noteTV.tempText;
        })
        .LeeShow();
    }
    if (Equals(view.tag, 102)) {//性别
        UIAlertController *alertController = [[UIAlertController alloc] init];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _genderLab.text = @"男";
            [self modifyInfoKey:@"gender" andValue:@"1"];
        }];
        UIAlertAction *famaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _genderLab.text = @"女";
            [self modifyInfoKey:@"gender" andValue:@"0"];
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:maleAction];
        [alertController addAction:famaleAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (Equals(view.tag, 103)) {//兴趣
        MioChooseFavoriteTagView *view = [MioChooseFavoriteTagView new];
        view.delegate = self;
        [view showFavoriteTagViewWithArr:_user.favorite_tags];
    }
    if (view.tag >= 104) {//签名
        XMTextView *noteTV = [[XMTextView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
        noteTV.textFont = [UIFont systemFontOfSize:14];
        noteTV.textColor = subColor;
        noteTV.textMaxNum = 40;
        noteTV.isSetBorder = YES;
        noteTV.borderLineWidth = 0.5;
        noteTV.placeholderColor = grayTextColor;
        noteTV.maxNumColor = grayTextColor;
        ViewRadius(noteTV, 8);
        [LEEAlert alert].config
        .LeeTitle(@"请输入个性签名")
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = noteTV;
            custom.isAutoWidth = YES;
        })
        .LeeCancelAction(@"取消", nil)
        .LeeAction(@"确认", ^{
            if (noteTV.tempText.length == 0) {
                [UIWindow showInfo:@"签名不能为空"];
                return;
            }
            [self modifyInfoKey:@"sign" andValue:noteTV.tempText];
            _signLab.text = noteTV.tempText;

        })
        .LeeShow();
    }


}

-(void)modifyInfoKey:(NSString *)key andValue:(NSString *)value{
    [MioPutReq(api_modifyInfo, @{key:value}) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        [UIWindow showSuccess:@"修改成功"];
    } failure:^(NSString *errorInfo) {
        NSLog(@"%@",errorInfo);
    }];
}

- (void)chooseFavorite:(NSArray *)tagArr{
    _user.favorite_tags = tagArr;
    _favoriteLab.text = [tagArr componentsJoinedByString:@"、"];
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

    [manager POST:api_uploadPic parameters:@{@"dir":@"avatar"}
       headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:data name:@"file" fileName:@"11" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
      
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self modifyInfoKey:@"avatar" andValue:responseObject[@"data"][@"path"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@", error);
    }];
}

@end
