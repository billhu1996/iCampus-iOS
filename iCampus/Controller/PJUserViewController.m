//
//  PJUserViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/3.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJUserViewController.h"
#import "PJAboutViewController.h"
#import "PJMyLostViewController.h"
#import "PJUserAandCViewController.h"
#import "logoutFoot.h"
#import "ICNetworkManager.h"
#import "iCampus-Swift.h"

@interface PJUserViewController ()

@end

@implementation PJUserViewController
{
    logoutFoot *_footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = [NSString stringWithFormat:@"%@", [PJUser currentUser].first_name];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"settingXIB" owner:self options:nil];
    _footer = views.firstObject;
    self.tableView.tableFooterView = _footer;
    [_footer.logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    _footer.logoutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_footer.logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self toMyLost];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self toAandC];
        }
        if (indexPath.row == 1) {
            [self toAbout];
        }
    }
}

-(void)logout{
    ICLoginViewController *vc = [[NSBundle mainBundle] loadNibNamed:@"ICLoginViewController" owner:nil options:nil].firstObject;
    [self presentViewController:vc animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
        [ICNetworkManager defaultManager].token = @"";
        [PJUser logOut];
    }];
}

- (void)toAandC {
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJUserAandCSB" bundle:nil];
    PJUserAandCViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJUserAandCViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
    
- (void)toMyLost {
    PJMyLostViewController *vc = [PJMyLostViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toAbout {
    PJAboutViewController *vc = [PJAboutViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
