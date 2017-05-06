//
//  PJMyPublishLostTableView.m
//  iCampus
//
//  Created by #incloud on 2017/5/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJMyPublishLostTableView.h"


@implementation PJMyPublishLostTableView

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = RGB(232, 234, 236);
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"PJMyPublishLostTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJMyPublishLostTableViewCell"];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 210;
}

- (void)setTableDataArr:(NSMutableArray *)tableDataArr {
    _tableDataArr = tableDataArr;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJMyPublishLostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJMyPublishLostTableViewCell" forIndexPath:indexPath];
    cell.dataSource = _tableDataArr[indexPath.row];
    cell.cellDelegate = self;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_tableDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)cellClick:(NSArray *)data index:(NSInteger)index {
    [_tableDelegate tableViewClick:data index:index];
}

@end
