//
//  AppDelegate.m
//  LXPig
//
//  Created by leexiang on 15/4/6.
//
//

#import "AppDelegate.h"
#import "NetWorkClient.h"
#import "UserManagerObject.h"
#import "PigCart.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initModel];
    [self setApperanceAndFlatWithIos6];
    [[UserManagerObject shareInstance] autoLoginResult:^(BOOL islogin) {
        [[PigCart shareInstance] refreshCartListSuccess:nil failure:nil];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard* storyboad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        self.window.rootViewController = [storyboad instantiateInitialViewController];
        [self.window makeKeyAndVisible];
    }];
    return YES;
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
}

-(void)initModel
{
    [NetWorkClient shareInstance];
}

-(void)setApperanceAndFlatWithIos6
{
    
    [[UINavigationBar appearance]setBarTintColor:NavigationBarColor];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage imageNamed:@"tab_selected_indicator"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    if (IOS_SYSTEM_VERSION < 7.0) {
        [[UINavigationBar appearance] setBackgroundImage:[Utils imageWithColor:NavigationBarColor size:CGSizeMake(1, 44)] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:
         @{ NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]}];
        
        //bar button
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage new]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"buttonItem_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 0)]
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0)
                                                             forBarMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:
         @{ UITextAttributeFont: [UIFont systemFontOfSize:17],
            UITextAttributeTextColor:[UIColor whiteColor],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateNormal];
        
        
        //tabbarbutton
        [[UITabBarItem appearance] setTitleTextAttributes:
         @{ UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
            UITextAttributeTextColor: NavigationBarColor }
                                                 forState:UIControlStateSelected];
    }
    else
    {
        [[UINavigationBar appearance]setBarTintColor:NavigationBarColor];
        [[UINavigationBar appearance] setTitleTextAttributes:
         @{ NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}];
        
        [[UITabBar appearance] setSelectedImageTintColor:NavigationBarColor];
        [[UITabBarItem appearance] setTitleTextAttributes:
         @{UITextAttributeTextColor: NavigationBarColor}
                                                 forState:UIControlStateSelected];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:
         @{ UITextAttributeTextColor:[UIColor whiteColor]} forState:UIControlStateNormal];
        
    }
    
    
}

@end
