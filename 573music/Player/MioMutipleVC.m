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

@interface MioMutipleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView       *tableView;
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

    [self.navView.leftButton setTitle:@"全选" forState:UIControlStateNormal];
    self.navView.leftButton.left = 5;
    self.navView.leftButtonBlock = ^{
        [weakSelf selectAll];
    };
    
    [self.navView.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    self.navView.rightButtonBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.navView.centerButton setTitle:@"批量操作" forState:UIControlStateNormal];
    _tableView = [UITableView creatTable:frame(0, NavH, KSW, KSH - NavH - TabH) inView:self.view vc:self];
    [_tableView registerClass:[MioMutipleCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setEditing:YES animated:YES];

    [self creatBottomView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.height = KSH;
}

-(void)downloadClick{
    NSMutableArray *selectArr = [[NSMutableArray alloc] init];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectArr addObject:_musicArr[obj.row]];
    }];
    NSLog(@"%@",selectArr);
}

-(void)playClick{
    
}

-(void)addClick{
    
}

-(void)deleteClick{
    
}


-(void)selectAll{
    if (Equals(self.navView.leftButton.titleLabel.text, @"全选")) {
        [_musicArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
        [self.navView.leftButton setTitle:@"全不选" forState:UIControlStateNormal];
    }else{
        [self.tableView reloadData];
        [self.navView.leftButton setTitle:@"全选" forState:UIControlStateNormal];
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



    cell.textLabel.text = [NSString stringWithFormat:@"第%ld条",(long)indexPath.row+1];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



-(void)creatBottomView{
    _bottomView = [UIView creatView:frame(0, KSH - 49 - SafeBotH, KSW, 49 + SafeBotH) inView:self.view bgColor:appWhiteColor radius:0];
    
    _downloadBtn = [[YLButton alloc] initWithFrame:frame(-30, 4, 30, 40)];
    [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [_downloadBtn setTitleColor:subColor forState:UIControlStateNormal];
    _downloadBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _downloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_downloadBtn setImage:image(@"download_choose") forState:UIControlStateNormal];
    _downloadBtn.imageRect = CGRectMake(3, 0, 24, 24);
    _downloadBtn.titleRect = CGRectMake(0, 26, 30, 14);
    [_downloadBtn addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_downloadBtn];
    
    _playBtn = [[YLButton alloc] initWithFrame:frame(-30, 4, 30, 40)];
    [_playBtn setTitle:@"稍后播" forState:UIControlStateNormal];
    [_playBtn setTitleColor:subColor forState:UIControlStateNormal];
    _playBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _playBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_playBtn setImage:image(@"download_choose") forState:UIControlStateNormal];
    _playBtn.imageRect = CGRectMake(3, 0, 24, 24);
    _playBtn.titleRect = CGRectMake(0, 26, 30, 14);
    [_playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_playBtn];
    
    _addBtn = [[YLButton alloc] initWithFrame:frame(-30, 4, 30, 40)];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addBtn setTitleColor:subColor forState:UIControlStateNormal];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_addBtn setImage:image(@"add_choose") forState:UIControlStateNormal];
    _addBtn.imageRect = CGRectMake(3, 0, 24, 24);
    _addBtn.titleRect = CGRectMake(0, 26, 30, 14);
    [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_addBtn];
    
    _deleteBtn = [[YLButton alloc] initWithFrame:frame(-30, 4, 30, 40)];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:subColor forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_deleteBtn setImage:image(@"delete_choose") forState:UIControlStateNormal];
    _deleteBtn.imageRect = CGRectMake(3, 0, 24, 24);
    _deleteBtn.titleRect = CGRectMake(0, 26, 30, 14);
    [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
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
            _deleteBtn.centerX = 1*KSW/5;
            _downloadBtn.centerX = 2*KSW/5;
            _addBtn.centerX = 3*KSW/5;
            _deleteBtn.centerX = 4*KSW/5;
            break;
        case MioMutipleTypeDownloadList://删除 稍后播 加入歌单
            _downloadBtn.centerX = 1*KSW/4;
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
