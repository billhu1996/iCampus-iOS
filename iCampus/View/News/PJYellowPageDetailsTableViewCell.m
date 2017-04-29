//
//  PJYellowPageDetailsTableViewCell.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJYellowPageDetailsTableViewCell.h"

@implementation PJYellowPageDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _phoneLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setCellDataSource:(NSDictionary *)cellDataSource {
    _nameLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"name"]];
    _phoneLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"telephone"]];
}

@end