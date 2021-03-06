//
//  PJNewLostViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJNewLostViewController.h"
#import "logoutFoot.h"
#import "PJUIImage+Extension.h"
#import "ICNetworkManager.h"

//#import "AFHTTPRequestOperationManager.h"


@interface PJNewLostViewController () <PJZoomImageScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

@end

@implementation PJNewLostViewController
{
    UITableView *_kTableView;
    logoutFoot *footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加失物招领";
    
    _kTableView = [UITableView new];
    _kTableView = self.tableView;
    _kTableView.tableFooterView = [UIView new];
    _imgScrollView.myDelegate = self;
    _detailsTextView.delegate = self;
    _nameTextField.delegate = self;
    _nameTextField.enabled = false;
    _nameTextField.text = [NSString stringWithFormat:@"%@",[PJUser currentUser].name];
    _phoneTextField.delegate = self;
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"settingXIB" owner:self options:nil];
    footer = views.firstObject;
    footer.backgroundColor = [UIColor clearColor];
    footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    _kTableView.tableFooterView = footer;
    footer.logoutBtn.backgroundColor = mainDeepSkyBlue;
    [footer.logoutBtn setTitle:@"添加" forState:0];
    [footer.logoutBtn addTarget:self action:@selector(uploadLost) forControlEvents:1<<6];

}

- (void)uploadLost {
    NSString *phoneNum = _phoneTextField.text;
//    NSString *nameStr = _nameTextField.text;
    NSString *detailsStr = _detailsTextView.text;
//    if ([nameStr isEqualToString:@""]) {
//        [PJHUD showErrorWithStatus:@"姓名错误"];
//        return;
//    }
    if (![self isTruePhone:phoneNum]) {
        [PJHUD showErrorWithStatus:@"号码错误"];
        return;
    }
    if ([detailsStr isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"请填写描述信息"];
        return;
    }
    if (_imgScrollView.dataSource.count == 0) {
        [PJHUD showErrorWithStatus:@"至少添加一张图片"];
        return;
    }
    NSArray *imgArr = [self setupImg:_imgScrollView.dataSource];
    [self updaeImgFromHttp:imgArr];
}

- (void)updaeImgFromHttp:(NSArray *)imgArr {
    NSDictionary *paramters = @{@"resource":imgArr};
    [PJHUD showWithStatus:@"发布中"];
    [[ICNetworkManager defaultManager] POST:@"Add Lost Image" GETParameters:nil POSTParameters:paramters success:^(NSDictionary *dict) {
        NSArray *dataArr = dict[@"resource"];
        NSMutableDictionary *lostDict = [@{@"details":_detailsTextView.text,
                                   @"author":_nameTextField.text,
                                   @"phone":_phoneTextField.text} mutableCopy];
        NSMutableArray *imgURLarr = [@[] mutableCopy];
        for (NSDictionary *dict in dataArr) {
            NSString *imgurl = dict[@"path"];
            NSMutableDictionary *imgURLdict = [@{} mutableCopy];
            imgurl = [NSString stringWithFormat:@"files/%@", imgurl];
            imgURLdict[@"url"] = imgurl;
            [imgURLarr addObject:imgURLdict];
        }
        NSString *jsonStr=[imgURLarr mj_JSONString];
        lostDict[@"imgUrlList"] = jsonStr;
        NSArray *finalArr = [@[lostDict] mutableCopy];
        [self publishNewLostWithHttp:finalArr];
    } failure:^(NSError *error) {
        
    }];
}

- (void)publishNewLostWithHttp:(NSArray *)lostArr {
    [[ICNetworkManager defaultManager] POST:@"New Lost" GETParameters:nil POSTParameters:lostArr success:^(NSDictionary *dict) {
        [PJHUD showSuccessWithStatus:@"发布成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (NSArray *)setupImg:(NSArray *)imgArr {
    NSMutableArray *newArr = [@[] mutableCopy];
    for (UIImage *img in imgArr) {
        NSData *imgData = UIImagePNGRepresentation([img imageCompress:500]);
        NSString *imgBase64String = [imgData base64EncodedStringWithOptions:0];
       
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
        NSString* date = [formatter stringFromDate:[NSDate date]];
        NSString *timeNow = [[NSString alloc] initWithFormat:@"%@.jpg", date];
        
        NSDictionary *dict = @{@"name":timeNow, @"type":@"file", @"is_base64":@YES, @"content":imgBase64String};
        [newArr addObject:dict];
    }
    return newArr;
}

- (BOOL)isTruePhone:(NSString *)mobileNum {
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_detailsTextView resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
}

-(void)keyboardWillHideNotification:(NSNotification *)notification{
    double keyboardDuration = [PJKeyBoard returnKeyBoardDuration:notification];
    [UIView animateWithDuration:keyboardDuration animations:^{
        [_kTableView setContentInset:UIEdgeInsetsZero];
    }];
}
-(void)keyboardWillShowNotification:(NSNotification *)notification{
    CGRect keyboardWindow = [PJKeyBoard returnKeyBoardWindow:notification];
    double keyboardDuration = [PJKeyBoard returnKeyBoardDuration:notification];
    [UIView animateWithDuration:keyboardDuration animations:^{
        [_kTableView setContentInset:UIEdgeInsetsMake(0, 0, keyboardWindow.size.height, 0)];
    }];
}

#pragma mark - PJZoomImageScrollViewDelegate
-(void)addZoomImage{
    if (_imgScrollView.dataSource.count > 4) {
        [PJHUD showErrorWithStatus:@"最多只能添加五张照片"];
        return;
    }
    UIAlertController *Sheet = [UIAlertController alertControllerWithTitle:@"请添加图片" message:@"选择图片"preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromPhoto:UIImagePickerControllerSourceTypeCamera];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [Sheet addAction:action1];
    [Sheet addAction:action2];
    [Sheet addAction:action3];
    [self presentViewController:Sheet animated:true completion:^{
        
    }];
}
/*
 * 从相机或者相机选择图片
 */
-(void)selectImageFromPhoto:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = type;
    picker.delegate = self;
    [self presentViewController:picker animated:true completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    [_imgScrollView.dataSource addObject:image];
    [_imgScrollView reloadData];
    [picker dismissViewControllerAnimated:true completion:^{
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([_detailsTextView.text isEqualToString:@""]) {
        _detailsTextViewLabel.hidden = NO;
    } else {
        _detailsTextViewLabel.hidden = YES;
    }
}

@end
