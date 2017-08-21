//
//  AppDelegate.m
//  练习2
//
//  Created by admin on 17/7/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AppDelegate.h"
#import <ECSlidingViewController/ECSlidingViewController.h>

@interface AppDelegate ()<ECSlidingViewControllerDelegate>

@property (strong,nonatomic) ECSlidingViewController *slidingVC;

@end

@implementation AppDelegate

//整个APP第一个会执行的逻辑方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    //初始化窗口(不用故事板设置入口箭头的时候，系统不会默认设置窗口，需要手动设置)
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //将窗口可视化
    [_window makeKeyAndVisible];
    UINavigationController *navi=[Utilities getStoryboardInstance:@"Main" byIdentity:@"HomeNavi"];
    //创建门框(初始化的同时顺便设置好门框最外层的那扇门，也就是用户首先会看到的正中间的页面)
    _slidingVC=[[ECSlidingViewController alloc]initWithTopViewController:navi];
    //签协议
    //_slidingVC.delegate=self;
    //放好左边那扇门
    _slidingVC.underLeftViewController = [Utilities getStoryboardInstance:@"Member" byIdentity:@"Left"];
    //设置手势（表示让中间的门能够对拖拽与触摸响应）
    _slidingVC.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping |ECSlidingViewControllerAnchoredGesturePanning ;
    //把上述手势添加到中间那扇门
    [navi.view addGestureRecognizer: _slidingVC.panGesture];
    //设置侧滑动画的执行时间
    _slidingVC.defaultTransitionDuration = 0.25;
    //设置滑动的幅度（中间那扇门打开的宽度）
    _slidingVC.anchorRightPeekAmount = UI_SCREEN_W / 6;
    //设置APP入口
    _window.rootViewController = _slidingVC;
    //注册策划按钮被按的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSwitchAction:) name:@"LeftSwitch" object:nil];
    return YES;
}
//当收到通知后要执行的方法
- (void)leftSwitchAction:(NSNotification *)note{
    NSLog(@"dsgfadsfg");
    //当打开的状态下合上，合上的状态下打开
    if (_slidingVC.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        // 合上的状态下打开
        [_slidingVC anchorTopViewToRightAnimated:YES];
    }else{
        // 打开的状态下合上
        [_slidingVC resetTopViewAnimated:YES];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "self.edu.__2" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"__2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"__2.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
