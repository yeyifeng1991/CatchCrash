//
//  AppDelegate.m
//  CrashHandle
//
//  Created by YeYiFeng on 2018/3/7.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "AppDelegate.h"
#import "CYCatchCrash.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
//    [XHCatchCrash setDefaultHandler];//崩溃日志
    [CYCatchCrash setDefaultHandler];
    // 发送崩溃日志
    [self crashPath];
    
    
    
    return YES;
}
#pragma mark -- 发送崩溃日志
- (void)crashPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {
//        [self sendExceptionLogWithData:data path:dataPath];
    }
}
- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path {
    
//    [XHSaleHttpTask postErrorFile:data andMobile:[XHUserModel sharedXHUserModel].userInfo.mobile progress:^(NSProgress *progress) {
//
//    } success:^(id result) {
//        // 删除文件
//        NSFileManager *fileManger = [NSFileManager defaultManager];
//        [fileManger removeItemAtPath:path error:nil];
//    } failure:^(XHResultCode *result) {
//
//    }];
}


/*

 Not running：app还没运行
 Inactive：app运行在foreground但没有接收事件
 Active：app运行在foreground和正在接收事件
 Background：运行在background和正在执行代码
 Suspended：运行在background但没有执行代码

 */

#pragma mark - app将要从前台切换到后台时需要执行的操作
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark - app已经进入后台后需要执行的操作
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
#pragma mark - app将要从后台切换到前台需要执行的操作，但app还不是active状态
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

#pragma mark - app运行在foreground和正在接收事件
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark -  app将要结束时需要执行的操作
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
