//
//  LeftViewController.m
//  练习2
//
//  Created by admin on 2017/8/19.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "LeftViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"
@interface LeftViewController ()
@property (strong,nonatomic) NSArray *arr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)settingAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self uiLayout];
    [self dataInitialize];
}
//每次将要来都这个页面的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //已登录
        _loginBtn.hidden=YES;
        _usernameLable.hidden=NO;
        UserModel *user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"Avatar"]];
        _usernameLable.text= user.nickname;
        
    }else{
        //未登录
        _loginBtn.hidden=NO;
        _usernameLable.hidden=YES;
        _avatarImageView.image=[UIImage imageNamed:@"Avatar"];
        _usernameLable.text=@"游客";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)uiLayout{
    _avatarImageView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
}
-(void)dataInitialize{
    _arr = @[@"我的活动",@"我的推广",@"积分中心",@"意见反馈",@"关于我们"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _arr.count;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
        cell.textLabel.text  = _arr[indexPath.row];
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        
        
        return cell;
    }
    
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 50.f;
    }else{
    return UI_SCREEN_H-170-80-50*5;
    }
}
//设置点击细胞后干什么
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([Utilities loginCheck]) {
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"Let2MyAct" sender:self];
                    break;
                case 1:
                    
                    break;
                case 2:
                    
                    break;
                case 3:
                    
                    break;
                case 4:
                    
                    break;
                default:
                    break;
            }
        }else{
            
            UINavigationController *signNavi=[Utilities getStoryboardInstance:
                                              @"Member"byIdentity:@"SignNavi"];
            [self presentViewController:signNavi animated:YES completion:nil];

        }
    }
    
    
}

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转过去的那个页面
    //1、获得要跳转的页面的实例
    UINavigationController *signNavi=[Utilities getStoryboardInstance:
                                      @"Member"byIdentity:@"SignNavi"];
       [self presentViewController:signNavi animated:YES completion:nil];
    //执行跳转
    
}

- (IBAction)settingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if ([Utilities loginCheck]) {
        
    }else{
        
        UINavigationController *signNavi=[Utilities getStoryboardInstance:
                                          @"Member"byIdentity:@"SignNavi"];
        [self presentViewController:signNavi animated:YES completion:nil];

    }
}
@end
