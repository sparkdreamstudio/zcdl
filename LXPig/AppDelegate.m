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
#import "AddressManager.h"
#import "SlideViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initUmeng];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self initModel];
    [self setApperanceAndFlatWithIos6];
    UIImageView* launchView = [[UIImageView alloc]init];
    if (SCREEN_HEIGHT == 480) {
        launchView.image = [UIImage imageNamed:@"iphone4"];
    }
    else if (SCREEN_HEIGHT == 568)
    {
        launchView.image = [UIImage imageNamed:@"iphone5"];
    }
    else if(SCREEN_HEIGHT == 667)
    {
        launchView.image = [UIImage imageNamed:@"iphone6"];
    }
    else
    {
        launchView.image = [UIImage imageNamed:@"iphone6plus"];
    }
    launchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.window addSubview:launchView];
    [self.window bringSubviewToFront:launchView];
    [[UserManagerObject shareInstance] autoLoginResult:^(BOOL islogin) {
        [[NetWorkClient shareInstance]postUrl:SERVICE_CONTACT With:@{@"action":@"detail"} success:^(NSDictionary *responseObj, NSString *timeSp) {
            [[UserManagerObject shareInstance] setServiceMobile:[[responseObj objectForKey:@"data"] objectForKey:@"tel"]];
            [[UserManagerObject shareInstance] setServiceQQ:[[responseObj objectForKey:@"data"] objectForKey:@"qq"]];
        } failure:^(NSDictionary *responseObj, NSString *timeSp) {
            
        }];
        if (islogin && [[UserManagerObject shareInstance]userType]==0) {
            [[PigCart shareInstance] refreshCartListSuccess:nil failure:nil];
            [[AddressManager shareInstance]getAddressArraySuccess:nil failure:nil];
            
        }
    }];
    UIStoryboard* storyboad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.window.rootViewController = [storyboad instantiateInitialViewController];
    self.mainController = (SlideViewController*)self.window.rootViewController;
    
    [self.window bringSubviewToFront:launchView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    launchView.userInteractionEnabled = YES;
    [launchView addGestureRecognizer:tap];
    return YES;
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
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


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initModel
{
    [NetWorkClient shareInstance];
}

-(void)tapGesture:(UITapGestureRecognizer*)tap
{
    UIView* view = tap.view;
    [view removeGestureRecognizer:tap];
    POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    animation.toValue = @(0);
    animation.duration = 1;
    [animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        if (finished) {
            [view removeFromSuperview];
        }
    }];
    [view pop_addAnimation:animation forKey:@"launchView"];
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
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]}];
        
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:
         @{ NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
        
    }
    
    
}

-(void)initUmeng
{
    [UMSocialData setAppKey:@"559f8b4f67e58ed786003993"];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialQQHandler setQQWithAppId:@"1104674913" appKey:@"dEYLcVwuLWJmorvU" url:@"http://www.umeng.com/"];
    [UMSocialWechatHandler setWXAppId:@"wx0d16ba0810ca5a8c" appSecret:@"1fa57f69e0f97b38e730208d4afdc6e9" url:@"http://www.umeng.com/"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

@end
