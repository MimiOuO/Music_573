//
//  MioSearchResultVC.m
//  orrilan
//
//  Created by 吉格斯 on 2019/8/6.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioSearchResultVC.h"

@interface MioSearchResultVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *searchTable;
@property (nonatomic, strong) NSMutableArray *resultArr;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) NSInteger page;
@end

@implementation MioSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _resultArr = [[NSMutableArray alloc] init];
    _page = 1;
    
    _searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSW, KSH - NavH)];
    
    _searchTable.separatorStyle =UITableViewCellSeparatorStyleNone;
    _searchTable.dataSource = self;
    _searchTable.delegate = self;
    _searchTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self serchRequest];
    }];
    
    [self.view addSubview:_searchTable];
}




#pragma mark - netWork
-(void)serchRequest{
    
    NSDictionary *dic = @{
                          @"k":_key,
                          @"page":[NSString stringWithFormat:@"%ld",(long)_page],
                          };
    MioGetRequest *request = [[MioGetRequest alloc] initWithRequestUrl:api_base argument:dic];
    
    [request success:^(NSDictionary *result) {

    } failure:^(NSString *errorInfo) {
        
        
    }];
}

#pragma mark - PYSearchViewControllerDelegate

-(void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithSearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText{
    [_resultArr removeAllObjects];
    _key = searchText;
    [self serchRequest];

}

-(void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchHistoryAtIndex:(NSInteger)index searchText:(NSString *)searchText{
    [_resultArr removeAllObjects];
    _key = searchText;
    [self serchRequest];
}

#pragma mark - tableViewDatasoure & delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = color_main;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
