//
//  MioMutipleVC.m
//  573music
//
//  Created by Mimio on 2020/12/9.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMutipleVC.h"
#import "MioMutipleCell.h"
#import "YLButton.h"
#import "SODownloader.h"
#import "SODownloader+MusicDownloader.h"
#import "MioAddToSonglistVC.h"
#import "MioChooseDownloadQuantityView.h"

@interface MioMutipleVC ()<UITableViewDelegate,UITableViewDataSource,chooseDownloadDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIButton *allSelectBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) YLButton *downloadBtn;
@property (nonatomic, strong) YLButton *playBtn;
@property (nonatomic, strong) YLButton *addBtn;
@property (nonatomic, strong) YLButton *deleteBtn;


@end

@implementation MioMutipleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF;
    [self.navView.centerButton setTitle:@"批量操作" forState:UIControlStateNormal];
    self.navView.leftButton.hidden = YES;
    _allSelectBtn = [UIButton creatBtn:frame(5, StatusH, 56, 44) inView:self.navView.mainView bgColor:appClearColor title:@"全选" titleColor:color_text_one font:15 radius:0 action:^{
        [weakSelf selectAll];
    }];

    
    [self.navView.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    self.navView.rightButtonBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    _tableView = [UITableView creatTable:frame(0, NavH, KSW, KSH - NavH - TabH) inView:self.view vc:self];
    [_tableView registerClass:[MioMutipleCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setEditing:YES animated:YES];
    _tableView.backgroundColor = appClearColor;

    [self creatBottomView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.height = KSH;
}

-(void)downloadClick{
//    [UIWindow showInfo:@"开发中"];
//    return;
    goLogin;

    NSMutableArray *selectArr = [[NSMutableArray alloc] init];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectArr addObject:_musicArr[obj.row]];
    }];
    if (selectArr.count == 0) {
        [UIWindow showInfo:@"还未选择歌曲"];
        return;
    }
    MioChooseDownloadQuantityView *view = [[MioChooseDownloadQuantityView alloc] init];
    view.delegate = self;
    view.musicArr = selectArr;
    [view show];
   
}

- (void)chooseDownloadQuailtyDone{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)playClick{
    NSMutableArray *selectArr = [[NSMutableArray alloc] init];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectArr addObject:_musicArr[obj.row]];
    }];
    if (selectArr.count == 0) {
        [UIWindow showInfo:@"还未选择歌曲"];
        return;
    }
    [mioPlayList addLaterPlayList:selectArr fromModel:_fromModel andId:_fromId];
    [UIWindow showSuccess:@"添加成功"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addClick{
//    goLogin;
    NSMutableArray *selectArr = [[NSMutableArray alloc] init];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectArr addObject:_musicArr[obj.row]];
    }];
    
    if (selectArr.count == 0) {
        [UIWindow showInfo:@"还未选择歌曲"];
        return;
    }

    MioAddToSonglistVC *vc = [[MioAddToSonglistVC alloc] init];
    vc.musicArr = selectArr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)deleteClick{
    NSMutableArray<MioMusicModel *> *selectArr = [[NSMutableArray alloc] init];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectArr addObject:_musicArr[obj.row]];
    }];
    if (selectArr.count == 0) {
        [UIWindow showInfo:@"还未选择歌曲"];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        if ([self.delegate respondsToSelector:@selector(mutipleDelete:)]) {
            [self.delegate mutipleDelete:selectArr];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    alertController.modalPresentationStyle = 0;
    [self presentViewController:alertController animated:YES completion:nil];
    
}


-(void)selectAll{
    if (Equals(_allSelectBtn.titleLabel.text, @"全选")) {
        [_musicArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];

        [_allSelectBtn setTitle:@"全不选" forState:UIControlStateNormal];
    }else{
        [self.tableView reloadData];
        [_allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
}

- (void)setMusicArr:(NSArray<MioMusicModel *> *)musicArr{
    _musicArr = musicArr;
    [_tableView reloadData];
}

-(void)setType:(MioMutipleType)type{
    _type = type;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    MioMutipleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
       cell = [[MioMutipleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.music = _musicArr[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



-(void)creatBottomView{
    _bottomView = [UIView creatView:frame(0, KSH - 49 - SafeBotH, KSW, 49 + SafeBotH) inView:self.view bgColor:appWhiteColor radius:0];
    MioImageView *bottomImg = [MioImageView creatImgView:frame(0, 0, KSW, 49 + SafeBotH) inView:_bottomView skin:SkinName image:@"picture_bfq" radius:0];
    
    _downloadBtn = [[YLButton alloc] initWithFrame:frame(-30, 4, 30, 40)];
    [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [_downloadBtn setTitleColor:color_text_one forState:UIControlStateNormal];
    _downloadBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _downloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_downloadBtn setImage:[image(@"download_choose") imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateNormal];
    _downloadBtn.imageRect = CGRectMake(3, 0, 24, 24);
    _downloadBtn.titleRect = CGRectMake(0, 26, 30, 14);
    [_downloadBtn addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchUpInside];
    _downloadBtn.imageView.tintColor = color_text_one;
    [_bottomView addSubview:_downloadBtn];
    
    _playBtn = [[YLButton alloc] initWithFrame:frame(-30, 4, 30, 40)];
    [_playBtn setTitle:@"稍后播" forState:UIControlStateNormal];
    [_playBtn setTitleColor:color_text_one forState:UIControlStateNormal];
    _playBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _playBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_playBtn setImage:[image(@"play_choose") imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateNormal];
    _playBtn.imageRect = CGRectMake(3, 0, 24, 24);
    _playBtn.titleRect = CGRectMake(-5, 26, 40, 14);
    [_playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.imageView.tintColor = color_text_one;
    [_bottomView addSubview:_playBtn];
    
    _addBtn = [[YLButton alloc] initWithFrame:frame(-30, 4, 30, 40)];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addBtn setTitleColor:color_text_one forState:UIControlStateNormal];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_addBtn setImage:[image(@"add_choose") imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateNormal];
    _addBtn.imageRect = CGRectMake(3, 0, 24, 24);
    _addBtn.titleRect = CGRectMake(0, 26, 30, 14);
    [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.imageView.tintColor = color_text_one;
    [_bottomView addSubview:_addBtn];
    
    _deleteBtn = [[YLButton alloc] initWithFrame:frame(-30, 4, 30, 40)];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:color_text_one forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_deleteBtn setImage:[image(@"delete_choose") imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateNormal];
    _deleteBtn.imageRect = CGRectMake(3, 0, 24, 24);
    _deleteBtn.titleRect = CGRectMake(0, 26, 30, 14);
    [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.imageView.tintColor = color_text_one;
    [_bottomView addSubview:_deleteBtn];
    
    switch (_type) {
        case MioMutipleTypePlayList://下载 加入歌单
            _downloadBtn.centerX = 1*KSW/3;
            _addBtn.centerX = 2*KSW/3;
            break;
        case MioMutipleTypeSongList://下载 稍后播 加入歌单
            _playBtn.centerX = 1*KSW/4;
            _downloadBtn.centerX = 2*KSW/4;
            _addBtn.centerX = 3*KSW/4;
            
            break;
        case MioMutipleTypeOwnSongList://删除 下载 稍后播 加入歌单
            _playBtn.centerX = 1*KSW/5;
            _downloadBtn.centerX = 2*KSW/5;
            _addBtn.centerX = 3*KSW/5;
            _deleteBtn.centerX = 4*KSW/5;
            break;
        case MioMutipleTypeDownloadList://删除 稍后播 加入歌单
            _playBtn.centerX = 1*KSW/4;
            _addBtn.centerX = 2*KSW/4;
            _deleteBtn.centerX = 3*KSW/4;
            break;
        case MioMutipleTypeLocalList://删除
            _deleteBtn.centerX = 1*KSW/2;
            break;
        default:
            break;
    }
}

@end
