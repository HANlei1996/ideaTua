//
//  SignUpViewController.m
//  练习2
//
//  Created by admin on 2017/8/19.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTelTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *vC;
@property (weak, nonatomic) IBOutlet UIButton *vCBtn;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
- (IBAction)vCBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor=[UIColor grayColor];
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}

//用Model的方式返回上一页
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}
//按return收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _userTelTextField || textField == _passWordTextField || textField == _nickName || textField == _confirmTextField || textField == _vC) {
        [textField resignFirstResponder];
    }
    return YES;
}
//- (void)countTime{
//    count --;
//    if (count > 60) {
//        NSString *secStr = [Utilities checkZero:count];
//        _timerLabel.text = [NSString stringWithFormat:@"00:00:%@", secStr];
//        }else{
//        NSString *secStr = [Utilities checkZero:sec];
//            _timerLabel.text = [NSString stringWithFormat:@"%@:%@:%@", hourStr, minStr, secStr];
//        }
//}

- (IBAction)vCBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self VerificationCodeRequest];

}

- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event {

    if (_userTelTextField.text.length== 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入你的手机号" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字
    NSCharacterSet *notDigits=[[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if ([_userTelTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound || _userTelTextField.text.length != 11) {
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    if (_nickName.text.length > 8) {
        [Utilities popUpAlertViewWithMsg:@"请输入规范的昵称" andTitle:nil onView:self];
        return;
    }

    if (_passWordTextField.text.length==0) {
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self];
        return;
    }
    if (_passWordTextField.text.length < 6 || _passWordTextField.text.length > 18) {
        [Utilities popUpAlertViewWithMsg:@"你输入的密码必须在6~18之间" andTitle:nil onView:self];
        return;
    }
    if ([_passWordTextField.text isEqualToString:_confirmTextField.text]) {
        // [self request];
    }else{
        [Utilities popUpAlertViewWithMsg:@"密码输入不一致，请重新输入" andTitle:@"提示" onView:self];
       // _passWordTextField.text = @"";
        _confirmTextField.text = @"";
    }
    }
/*- (void)request{
    _avi = [Utilities getCoverOnView:self.view];
    
    [RequestAPI requestURL:@"/register" withParameters:@{@"userTel":_userTelTextField.text,@"userPwd":_passWordTextField.text,@"nickName":_nickName.text,@"nums":_vC,@"city":,@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            //[_avi stopAnimating];
            
        }else{
            [_avi stopAnimating];
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误,请稍等再试" andTitle:@"提示" onView:self];
    }];
}*/
- (void)VerificationCodeRequest{

    [RequestAPI requestURL:@"/register/verificationCode" withParameters:@{@"userTel":_userTelTextField.text,@"type":@(1)} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            //[_avi stopAnimating];
            
        }else{
            [_avi stopAnimating];
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误,请稍等再试" andTitle:@"提示" onView:self];
    }];
}

@end
