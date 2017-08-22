//
//  ViewController.m
//  练习2
//
//  Created by admin on 17/7/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "ListViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "IssueViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL isLoading;
    BOOL firstVisit;
}
@property (weak, nonatomic) IBOutlet UITableView *activiyTableView;
@property (weak, nonatomic) IBOutlet UIButton *CityBtn;
@property(strong,nonatomic)NSMutableArray *arr;
- (IBAction)searchAction:(UIBarButtonItem *)sender;
- (IBAction)favoAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)switchAction:(UIBarButtonItem *)sender;

@property (strong,nonatomic) UIImageView *zoomIV;
@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property (strong,nonatomic) CLLocationManager *locMgr;
@property (strong,nonatomic) CLLocation *location;



@end

@implementation ListViewController
//第一次将要开始渲染这个页面的时候
-(void)awakeFromNib{
    [super awakeFromNib];
}
//第一次来到这个页面的时候，
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //ActivityModel *activity=[[ActivityModel alloc]init];
   // activity.name=@"活动";
    
    //过两秒执行networkRequest方法
    //[self performSelector:@selector(network) withObject:nil afterDelay:2];
    [self naviConfig];
    [self data];
    [self uilay];
    [self locationConfig];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
    
}
//每次将要来都这个页面的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationStart];
}
//每次到达这个页面的时候
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
//每次将要离开这个页面的时候
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locMgr stopUpdatingLocation];
}
//每次离开这个页面的时候
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //获得当前页面的导航控制器所维系的关于导航关系的数组,判断该数组中是否包含自己来得知当前操作是离开打本页面还是退出被本页面
    if(![self.navigationController.viewControllers containsObject:self])
    {
        //在这里释放所有监听（包括Action事件；protcol协议；Gesture手势；Notification通知...）
        
    }
}
//一旦退出这个页面的时候（并且所有的监听都已经全部被释放了）
-(void)dealloc{
    //在这里释放所有内存（这是为nil)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//这个方法专门处理定位的基本设置
-(void)locationConfig{
    _locMgr = [CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //识别定位到的设备位移多少距离进行一次识别
    _locMgr.distanceFilter =kCLDistanceFilterNone;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy =kCLLocationAccuracyBest ;
}
//这个方法处理开始定位
-(void)locationStart{
  //判断用户有没有选择过是否使用定位
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //询问用户是否愿意使用定位
#ifdef __IPHONE_8_0
        //使用“使用中打开定位”这个策略去运用定位功能
        [_locMgr requestWhenInUseAuthorization];
#endif
    }
    //打开定位服务的开关（开始定位）
    [_locMgr startUpdatingLocation];
}

// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title=@"活动列表";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor=[UIColor brownColor];
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
}
-(void)refreshConfiguretion{
    //初始化一个下拉刷新控件
    UIRefreshControl *refreshContro=[[UIRefreshControl alloc]init];
    
    refreshContro.tag=10001;
    //设置标题
    NSString * title=@"加载中🐰";
    //创建属性字典
    NSDictionary *attrD=@{NSForegroundColorAttributeName : [UIColor grayColor]};
    //将文字和属性字典包裹成一个带属性的字符串
    NSAttributedString *attri=[[NSAttributedString alloc]initWithString:title attributes:attrD];
    refreshContro.attributedTitle=attri;
    //设置风格颜色为黑色（风格颜色：刷新指示器的颜色）
    refreshContro.tintColor=[UIColor blackColor];
    //设置背景颜色
    refreshContro.backgroundColor=[UIColor groupTableViewBackgroundColor];
    //定义用户出发下拉事件执行的方法
    [refreshContro addTarget:self action:@selector(refreData:) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到activityView中（在tableView中，下拉刷新控件会自动放置在表格视图顶部后侧位置
    [self.activiyTableView addSubview:refreshContro];
    
}
-(void)refreData:(UIRefreshControl *)sender{
    //
    [self performSelector:@selector(end) withObject:nil afterDelay:2];
    
}
-(void)end{
    //在activityView中根据下标10001获得其子视图：下拉刷新控件
    UIRefreshControl *refresh=(UIRefreshControl *)[self.activiyTableView viewWithTag:10001];
    //结束刷新
    [refresh endRefreshing];
}

//专门做界面的操作
-(void)uilay{
    
    _activiyTableView.tableFooterView=[UIView new];//为表格视图创建footer（该方法可以去除表格视图底部多余的下划线)
    [self refreshConfiguretion];
}

//专门做数据的处理
-(void)data{
    BOOL appInit = NO;
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //说明不是第一次打开APP
        appInit = YES;
    }else{
        if ([Utilities getUserDefaults:@"UserCity"] == nil) {
            //也说明是第一次打开APP
            appInit = YES;
        }if (appInit) {
            //第一次来到APP将默认城市与记忆城市同步
            NSString *userCity = _CityBtn.titleLabel.text;
            [Utilities setUserDefaults:@"UserCity" content:userCity];
        }else{
        //不是第一次来到APP则将记忆城市与按钮城市名方向同步
            NSString *userCity = [Utilities getUserDefaults:@"UserCity"];
            [_CityBtn setTitle:userCity forState:UIControlStateNormal];
        }
    }
    
    
    firstVisit = YES;
    isLoading=NO;
    //初始化
    _arr=[NSMutableArray new];
    //创建菊花膜
    _aiv =[Utilities getCoverOnView:self.view];
    [self refreshPage];
}
-(void)refreshPage{
    page=1;
    [self network];
}
//执行网络请求
-(void)network{
    
    perPage=10;
    /*NSDictionary *dicA=@{ @"name":@"环太湖骑行",@"neirong":@"从无锡滨湖区到雪浪街道太湖边出发，往东绕过苏州、嘉兴、湖州、宜兴，返回无锡",@"like":@80,@"unlike":@8,@"imgURL":@"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A",@"isFavo":@YES};
    NSDictionary *dicB=@{ @"name":@"雪浪山骑马",@"neirong":@"从无锡滨湖区到雪浪街道太湖边出发，往",@"like":@80,@"unlike":@8,@"imgURL":@"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_1_885E76C7-7EA0-423D-B029-2085C0F769E6",@"isFavo":@NO};
    NSDictionary *dicC=@{ @"name":@"黄浦江浮潜",@"neirong":@"从无锡滨湖区到雪浪街道太湖边出发，往东绕过苏州、嘉兴、湖州、宜兴，返回无锡",@"like":@80,@"unlike":@8,@"imgURL":@"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_3_2ADCF0CE-0A2F-46F0-869E-7E1BCAF455C1",@"isFavo":@NO};*/

  
   // NSMutableArray *array=[NSMutableArray arrayWithObjects:dicA,dicB,dicC, nil];
    /*
    for (NSDictionary *dict in array) {
       
        //用ActivityModel类中定义的初始化方法initWithDictionary：将遍历得来的字典dictionary转换成ActivityMode对象
        ActivityModel *activityModel=[[ActivityModel alloc]initWithDictionary:dict];
        //将上述实例化好的ActivityModel对象插入_arr数组中
        [_arr addObject:activityModel];
    }
     */
   
    
    if (!isLoading) {
        isLoading=YES;
        //在这里开启有个真实的网络请求
        //设置接口地址
        NSString *request=@"/event/list";
        //设置接口入参
        NSDictionary *parameter=@{@"page":@(page),@"perPage":@(perPage),@"city": _CityBtn.titleLabel.text};
        //开始请求
        [RequestAPI requestURL:request withParameters:parameter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
            //成功以后要做的事情在此处执行
            NSLog(@"responseObject=%@",responseObject);
            //停止菊花转
            [self endA];
            if ([responseObject[@"resultFlag"]integerValue]==8001) {
                //业务逻辑成功的情况下
                NSDictionary *result=responseObject[@"result"];
                NSArray *models=result[@"models"];
                NSDictionary *pagingInfo= result[@"pagingInfo"];
                totalPage=[  pagingInfo [@"totalPage"]integerValue];
                if (page ==1) {
                    //清空数组
                    [_arr removeAllObjects];
                    
                }
                for (NSDictionary *dict in models) {
                    
                    //用ActivityModel类中定义的初始化方法initWithDictionary：将遍历得来的字典dictionary转换成ActivityMode对象
                    ActivityModel *activityModel=[[ActivityModel alloc]initWithDictionary:dict];
                    //将上述实例化好的ActivityModel对象插入_arr数组中
                    [_arr addObject:activityModel];
                }
                //刷新表格（重载数据）
                [_activiyTableView reloadData];
            }else{
                //业务逻辑失败的情况下
                NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
                [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];        }
        } failure:^(NSInteger statusCode, NSError *error) {
            // 失败以后要做的事情在此处执行
            NSLog(@"statusCode=%ld",(long)statusCode);
            //停止菊花转
            
            [self endA];
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }];
    }
    
    
}
//这个方法处理所有网络请求完成后所有不同类型的动画终止
-(void)endA{
    isLoading=NO;
    [_aiv stopAnimating];
    [self end];
}
//设置表格视图一共有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置表格视图中每一组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
}
//设置当一个细胞将要出现的时候要做的事情
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是不是最后一行细胞将要出现
    if (indexPath.row==_arr.count-1) {
        //判断还有没有下一页判断
        if (page<totalPage) {
            //在这里执行上拉翻页的数据操作
            page ++;
            [self network];
        }
        
    }
}
//设置每一组每一行的 细胞长什么样
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//indexPath:组号行号
{
    //根据某个具体的名字找到该名字在页面上对应的细胞
    ActivityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActiviyCail" forIndexPath:indexPath];
    //更具当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
    ActivityModel *activity=_arr[indexPath.row];
    //将http请求的字符串转换为NSURL
    NSURL *URL=[NSURL URLWithString:activity.imgUrl];
    //依靠SDWebImage来异步的下载一张远程路径下的图片并三级缓存在项目中，同时为下载的时间周期过程中设置一张临时占位图
    [cell.activiImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"aaa"]];
    //下载图片
   // NSData *data=[NSData dataWithContentsOfURL:URL];
    //让图片加载
    //cell. activiImageView.image=[UIImage imageWithData:data];
    //给图片添加单击事件
    [self addTap:cell.activiImageView];
    
    cell.nameLabel.text=activity.name;
    cell.neirong.text=activity.neirong;
    cell.infolabel.text=[NSString stringWithFormat:@"顶:%ld",(long)activity.like];
    
    cell.lakeLabel.text=[NSString stringWithFormat:@"踩：%ld",(long)activity.unlike];
    //给每一行的收藏按钮打上下标，用来区分它是哪一行按钮
    cell.favoBtn.tag=100000+indexPath.row;
 //根据isFavo的值来判断按钮的标题是什么
    if (activity.isFavo) {
        [cell.favoBtn setTitle: @"取消收藏" forState:UIControlStateNormal];
    }else{
        [cell.favoBtn setTitle: @"收藏" forState:UIControlStateNormal];
    }
    [self addlongPress:cell];
    /*if (activity.isFavo) {
        cell.favoBtn.titleLabel.text=@"取消收藏";
    }else{
        cell.favoBtn.titleLabel.text=@"收藏";
    }*/
    
    
    //indexPath.section;//代表组号  indexPath.row;//代表行号
    /*if (indexPath.row==0) //判断当前正在渲染的细胞是第几行
    {//第一行的情况下
        
        //修改图片视图中图片的内容
        cell.activiImageView.image =[UIImage imageNamed:@"aaa"];
        //修改标签中文字的内容
        cell.nameLabel.text = @"环太湖骑行";
        cell.neirong.text = @"从无锡滨湖区到雪浪街道太湖边出发，往东绕过苏州、嘉兴、湖州、宜兴，返回无锡";
        cell.infolabel.text = @"顶:80";
        cell.lakeLabel.text = @"踩:8";
  
    }else
    {//第二行的情况下
        
        //修改图片视图中图片的内容
        cell.activiImageView.image =[UIImage imageNamed:@"bbb"];
        //修改标签中文字的内容
        cell.nameLabel.text = @"抓捕色狼";
        cell.neirong.text = @"无锡某男子，骚扰男同学，导致该男同学，局部受伤";
        cell.infolabel.text = @"顶:100";
        cell.lakeLabel.text = @"踩:8";
    }
   */
    
    
        return cell;
    
}
//添加长按手势事件
-(void)addlongPress:(UITableView *)cell{
    //初始化一个长按手势，设置响应的事件为choose
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(choose:)];
    //设置长按手势响应的时间
    longPress.minimumPressDuration=1.0;
    //将手势添加给cell
    [cell addGestureRecognizer:longPress];
    
}
//添加单击手势事件
-(void)addTap:(id)any{
    //初始化一个单击手势，设置响应事件为tapClick
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [any addGestureRecognizer:tap];
    
}
//单击手势响应事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
    
    if (tap.state==UIGestureRecognizerStateRecognized) {
        
    
    
    //拿到长按手势在_activiyTableView中的位置
    CGPoint location=[tap locationInView:_activiyTableView];
    //通过上述的点拿到现在_activiyTableView对应的indexPath
    NSIndexPath *indexPath=[_activiyTableView indexPathForRowAtPoint:location];
    //防范
    if (_arr !=nil && _arr.count !=0) {
        ActivityModel *activity=_arr[indexPath.row];
        //设置大图片的位置大小
        _zoomIV=[[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        //用户交互启用
        _zoomIV.userInteractionEnabled=YES;
        _zoomIV.backgroundColor=[UIColor blackColor];
       // _zoomIV.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:activity.imgUrl]]];
       // [_zoomIV sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"aaa"]];
        [_zoomIV sd_setImageWithURL:[NSURL URLWithString:activity.imgUrl] placeholderImage:[UIImage imageNamed:@"aaa"]];
        //设置图片的内容模式
        _zoomIV.contentMode = UIViewContentModeScaleAspectFit;
        //获得窗口实例，并将大图放置到窗口实例上，根据苹果规则，后添加的空间会覆盖前添加的控件
        [[UIApplication sharedApplication].keyWindow addSubview:_zoomIV];
        UITapGestureRecognizer *zoomIVtap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomTap:)];
        [_zoomIV addGestureRecognizer:zoomIVtap];
    }
    }
   
}
-(void)zoomTap:(UITapGestureRecognizer *)tap{
    if (tap.state==UIGestureRecognizerStateRecognized) {
        //把大图本身的东西扔掉（大图的手势）
        [_zoomIV removeGestureRecognizer:tap];
        //把自己从视图上移除
        [_zoomIV removeFromSuperview];
    //让图片彻底消失（不会造成内存的滥用)
        _zoomIV=nil;
    }
    
}
//长按手势响应事件
-(void)choose:(UILongPressGestureRecognizer *) longPress{
    //判断手势的状态（长按手势有时间间隔，对应的会有开始和结束两种状态）
    if (longPress.state==UIGestureRecognizerStateBegan) {
        NSLog(@"长按了");
    }else if(longPress.state==UIGestureRecognizerStateEnded){
        
        //NSLog(@"结束长按了");
        //拿到长按手势在_activiyTableView中的位置
        CGPoint location=[longPress locationInView:_activiyTableView];
        //通过上述的点拿到现在_activiyTableView对应的indexPath
        NSIndexPath *indexPath=[_activiyTableView indexPathForRowAtPoint:location];
        //防范
        if(_arr !=nil && _arr.count !=0){
            //根据行号拿到数组中对应的数据
            ActivityModel *activity=_arr[indexPath.row];
            //创建弹窗控制器
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"复制操作" message:@"复制活动名称或内容" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actionA=[UIAlertAction actionWithTitle:@"复制活动名称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               //创建复制版
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                //将活动名称复制
                [pasteboard setString:activity.name];
                NSLog(@"%@",pasteboard.string);
                
            }];
            UIAlertAction *actionB=[UIAlertAction actionWithTitle:@"复制活动内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                //将活动名称复制
                [pasteboard setString:activity.neirong];
                NSLog(@"%@",pasteboard.string);
            }];
            UIAlertAction *actionC=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
            
            [alert addAction:actionA];
            [alert addAction:actionB];
            [alert addAction:actionC];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
      
    }
    
}
//设置每个组每一行细胞的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取三要素（计算文字高度的三要素）
    //1、文字内容
    ActivityModel *activity=_arr[indexPath.row];
    NSString *content=activity.neirong;
    //2.字体大小
    ActivityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActiviyCail"];
    UIFont *font=cell.neirong.font;
    //3. 宽度尺寸
    CGFloat width=  [UIScreen mainScreen].bounds.size.width-30;
    CGSize size=CGSizeMake(width, 1000);
    //根据三元素计算尺寸
    CGFloat height=[content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading| NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size.height;
    //活动内容标签的原点Y轴位置加上活动内容标签根据文字自适应大小后获得的高度+活动内容标签距离细胞底部的间距
    return cell.neirong.frame.origin.y+height+10;
    
    
}
//设置每一组中每一行的细胞被点击以后要做的事情
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断当前tableView是否为activiyTableView(这个条件判断常用在一个页面中多个tableView的时候
    if([tableView isEqual:_activiyTableView]){
   //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (IBAction)favoAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_arr !=nil && _arr.count !=0) {
        //通过按钮的下标值减去100000拿到行号，再通过行号拿到对应的数据模型
        ActivityModel *activity=_arr[sender.tag-100000];
        
        
        NSString *message=activity.isFavo ?@"是否取消收藏该活动？":@"是否收藏该活动";
        //创建弹出框，标题为@“提示”，内容为 “是否收藏该活动”
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        //创建取消按钮
        UIAlertAction *actionA=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        //创建确定按钮
        UIAlertAction *actionB=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (activity.isFavo) {
                activity.isFavo= NO;
                
            }else{
                activity.isFavo=YES;
            }
            [self.activiyTableView reloadData];
        }];
        //将按钮添加到弹出框中,(添加按钮的顺序决定了按钮的排版，从左到右，从上到下，取消风格的按钮会在最左边
        [alert addAction:actionA];
        [alert addAction:actionB];
        //用presentViewController的方式，以modal的方式显示另一个页面（显示弹出框）
        [self presentViewController:alert animated:YES completion:^{
            
        }];
  
    }
    }

- (IBAction)switchAction:(UIBarButtonItem *)sender {
    //发送注册按钮被按的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftSwitch" object:nil ];
}





//当某一个页面跳转行为将要发生的时候
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"List2Detail"]) {
        //当从列表页到详情页的这个跳转要发生的时候
        //1获取要传递到下一页的数据
        NSIndexPath *indexPath=[_activiyTableView indexPathForSelectedRow];
        ActivityModel *activity=_arr[indexPath.row];
        //2获取下一页的这个实例
        DetailViewController *detailVC= segue.destinationViewController;
        //3吧数据 给下一页预备好的接收容器
        detailVC.activity=activity;
    }
}
/*- (IBAction)searchAction:(UIBarButtonItem *)sender {
    //获得要跳转的页面的实例
    SearchViewController *searchVC= [Utilities getStoryboardInstance:@"Detail" byIdentity:@"Search"];
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:searchVC];
    
    //用某种方式跳转到上述页面（这里用Model的方式跳转）
    [self presentViewController:searchVC animated:YES completion:nil];
    //[self.navigationController pushViewController:nc animated:YES];用push方式跳转
}*/
- (IBAction)searchAction:(UIBarButtonItem *)sender {
    //1、获得要跳转的页面的实例
    IssueViewController *issueVc = [Utilities getStoryboardInstance:@"Issue" byIdentity:@"issue"];
    //2、用某种方式跳转到上述页面（这里用modal的方式跳转）
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:issueVc];
    [self presentViewController:nc animated:YES completion:nil];
    
    //纯代码push的跳转
    //[self.navigationController pushViewController:searchVc animated:YES];
}
//定位失败时
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    if (error) {
        switch (error.code) {
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
                break;
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
                break;
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw", nil) andTitle:nil onView:self];
                break;
                
                
            default:[Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError", nil) andTitle:nil onView:self];
                break;
        }
    }
}
//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    //NSLog(@"纬度: %f",newLocation.coordinate.latitude);
    //NSLog(@"经度: %f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿到城市
    if (firstVisit) {
        firstVisit = !firstVisit;
        //根据定位拿到城市
        [self getRegeoViaCoordinate];
    }
}
-(void)getRegeoViaCoordinate{
    //duration表示从now开始过三个sec
    dispatch_time_t duration= dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    //用duration这个设置好的策略去做某些事
    dispatch_after(duration,dispatch_get_main_queue(), ^{
       //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //方向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                NSLog(@"locDict = %@",locDict);
                NSString *cityStr = locDict[@"City"];
                //把city的市子去掉
                cityStr = [cityStr substringToIndex:(cityStr.length - 0)];
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"LocCity"];
                //将定位到的城市保存进单例化全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"LocCity" andValue:cityStr];
                if (![cityStr isEqualToString:_CityBtn.titleLabel.text]) {
                    //将定位的城市和当前选则的城市不一样的时候去弹窗询问用户是否要切换城市
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的城市为%@,请问您是否需要切换" ,cityStr] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_CityBtn setTitle:cityStr forState:UIControlStateNormal];
                        //修改用户选择的城市记忆体
                        [Utilities removeUserDefaults:@"UserCity"];
                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
                        //重新执行网络请求
                        [self network];
                    }];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:yesAction];
                    [alert addAction:noAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }
        }];
        //关掉开关
        [_locMgr stopUpdatingLocation];
    });
}
-(void)checkCityState:(NSNotification *)note{
    NSString *cityStr = note.object;
    if (![cityStr isEqualToString:_CityBtn.titleLabel.text]){
        //修改城市按钮标题
        [_CityBtn setTitle:cityStr forState:UIControlStateNormal];
        //修改用户选择的城市记忆体
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //重新执行网络请求
        [self network];
    }
}
@end
