//
//  PJBusTableView.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJBusTableView.h"
#import "PJBusTableViewCell.h"

@implementation PJBusTableView
{
    UISearchBar *_kSearchBar;
    NSMutableArray *_kSearchArr;
}

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self registerNib:[UINib nibWithNibName:@"PJBusTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJBusTableViewCell"];
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [UIView new];
    self.estimatedRowHeight = 60;
    self.rowHeight = UITableViewAutomaticDimension;
    
    _kSearchArr = [@[] mutableCopy];
    _kSearchBar = [UISearchBar new];
    _kSearchBar.delegate = self;
    _kSearchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.tableHeaderView = _kSearchBar;
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_kSearchArr.count > 0) {
        return _kSearchArr.count;
    } else {
        return _dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJBusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJBusTableViewCell" forIndexPath:indexPath];
    [_tableDelegate PJRegister3DtouchCell:cell];
    if (_kSearchArr.count > 0) {
        cell.cellDataSource = _kSearchArr[indexPath.row];
    } else {
        cell.cellDataSource = _dataArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PJBusTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [_kSearchBar resignFirstResponder];
    [_tableDelegate PJBusTableViewCellClick:_dataArr[indexPath.row]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    // 使用谓词匹配
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchText];
    if (_kSearchArr != nil) {
        [_kSearchArr removeAllObjects];
    }
    for (NSDictionary *dict in _dataArr) {
        NSString *str = dict[@"busName"];
        if ([preicate evaluateWithObject:str]) {
            [_kSearchArr addObject:dict];
        }
    }
    [self reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_kSearchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_kSearchBar resignFirstResponder];
}

@end
