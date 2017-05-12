//
//  AppDelegate.m
//  仿淘宝购物订单逻辑
//
//  Created by macOfEthan on 17/4/16.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import "AppDelegate.h"
#import "OrderViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UITabBarController * tabBarCtl = [[UITabBarController alloc] init];
    
    UINavigationController * orderNav = [[UINavigationController alloc] initWithRootViewController:[[OrderViewController alloc] init]];
    [orderNav.tabBarItem setImage:[UIImage imageNamed:@"purchaseCar"]];
    orderNav.tabBarItem.title = @"购物车";
    tabBarCtl.tabBar.tintColor = CZY_ORANGE;
    tabBarCtl.viewControllers = @[orderNav];
    
    self.window.rootViewController = tabBarCtl;
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}


@end
