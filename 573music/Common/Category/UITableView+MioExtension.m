//
//  UITableView+MioExtension.m
//  jgsschool
//
//  Created by Mimio on 2020/10/27.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "UITableView+MioExtension.h"

@implementation UITableView (MioExtension)
+(UITableView *)creatTable:(CGRect)frame inView:(UIView *)view vc:(UIViewController *)vc{

    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    tableView.backgroundColor = appClearColor;
    tableView.delegate = vc;
    tableView.dataSource = vc;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     } else {
         tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
     }
    
    [view addSubview:tableView];
    
    return tableView;
}
@end
