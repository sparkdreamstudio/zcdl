//
//  LXPigViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/28.
//
//

#import "LXPigTabBarController.h"
#import "EnterpriseListViewController.h"
#import "ProductDetailViewController.h"
#import "AppDelegate.h"
#import "SlideViewController.h"
#import "PostQuestionViewController.h"
#import "NetWorkClient.h"
#import "SettingViewController.h"
@interface LXPigTabBarController ()
@property (assign,nonatomic) BOOL selectHasNavigator;
@property (assign,nonatomic) BOOL selectThirdDirect;
@end

@implementation LXPigTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectHasNavigator = NO;
    self.selectThirdDirect = NO;
    if (IOS_SYSTEM_VERSION >=8.0) {
        self.navigationController.navigationBar.translucent = YES;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(processNtf:) name:NTF_SHOW_ORDER object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(processNtf:) name:NTF_SHOW_POST_QUESTION object:nil];
    for (int index = 0; index < self.viewControllers.count; ++index) {
        switch (index) {
            case 0:
            {
                if (IOS_SYSTEM_VERSION < 7.0f) {
//                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_mall_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_mall"]];
                }
                else
                {
                    [[self.viewControllers[index] tabBarItem] setImage:[UIImage imageNamed:@"tab_mall"]];
                }
                break;
            }
            case 1:
            {
                if (IOS_SYSTEM_VERSION < 7.0f) {
//                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_info"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_info_selected"]];
                }
                else
                {
                    [[self.viewControllers[index] tabBarItem] setImage:[UIImage imageNamed:@"tab_info"]];
                }
                break;
            }
            case 2:
            {
                if (IOS_SYSTEM_VERSION < 7.0f) {
//                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_q&a"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_q&a_selected"]];
                }
                else
                {
                    [[self.viewControllers[index] tabBarItem] setImage:[UIImage imageNamed:@"tab_q&a"]];
                }
                break;
            }
            case 3:
            {
                if (IOS_SYSTEM_VERSION < 7.0f) {
//                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_set_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_set"]];
                }
                else
                {
                    [[self.viewControllers[index] tabBarItem] setImage:[UIImage imageNamed:@"tab_set"]];
                }
                break;
            }
            case 4:
            {
                if (IOS_SYSTEM_VERSION < 7.0f) {
//                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_person_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_person"]];
                }
                else
                {
                    [[self.viewControllers[index] tabBarItem] setImage:[UIImage imageNamed:@"tab_person"]];
                }
                break;
            }
            default:
                break;
        }
    }
    self.tabBar.tintColor = NavigationBarColor;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SlideViewController* controller = ((AppDelegate*)[[UIApplication sharedApplication]delegate]).mainController;
    controller.panGesture.enabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SlideViewController* controller = ((AppDelegate*)[[UIApplication sharedApplication]delegate]).mainController;
    controller.panGesture.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processNtf:(NSNotification*)ntf
{
    if ([ntf.name isEqualToString:NTF_SHOW_ORDER]) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"my_order"] animated:NO];
    }
    else if ([ntf.name isEqualToString:NTF_SHOW_POST_QUESTION])
    {
        if([[UserManagerObject shareInstance]userType]==-1)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SHOW_LOGIN object:nil];
            [[NetWorkClient shareInstance]postUrl:SERVICE_CODESERVICE With:@{@"action":@"listByParentId",@"parentId":@"4"} success:^(NSDictionary *responseObj, NSString *timeSp) {
                NSArray*  qAndAType = [responseObj objectForKey:@"data"];
                PostQuestionViewController* controller = [[PostQuestionViewController alloc]initWithNibName:@"PostQuestionViewController" bundle:nil];
                controller.qAndAType = qAndAType;
                [self.navigationController pushViewController:controller animated:NO];
            } failure:^(NSDictionary *responseObj, NSString *timeSp) {
                
            }];
        }
        else if ([[UserManagerObject shareInstance]userType]==0)
        {
            [[NetWorkClient shareInstance]postUrl:SERVICE_CODESERVICE With:@{@"action":@"listByParentId",@"parentId":@"4"} success:^(NSDictionary *responseObj, NSString *timeSp) {
                NSArray*  qAndAType = [responseObj objectForKey:@"data"];
                PostQuestionViewController* controller = [[PostQuestionViewController alloc]initWithNibName:@"PostQuestionViewController" bundle:nil];
                controller.qAndAType = qAndAType;
                [self.navigationController pushViewController:controller animated:NO];
            } failure:^(NSDictionary *responseObj, NSString *timeSp) {
                
            }];
        }
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [tabBar.items indexOfObject:item];
//    if (IOS_SYSTEM_VERSION >=8.0f) {
//        SettingViewController* controller = [self.viewControllers objectAtIndex:3];
//        if (index == 3) {
//            
//            if (self.selectHasNavigator == NO || controller.pushView == YES) {
//                controller.topContraint.constant = 0;
//                controller.topContraintHeight = 0;
//                self.selectThirdDirect = YES;
//            }
//            else if (self.selectThirdDirect == NO && controller.pushView == NO)
//            {
//                controller.topContraint.constant = 44;
//                controller.topContraintHeight = 44;
//            }
//        }
//        else if (index == 0 || index == 4)
//        {
//            self.selectHasNavigator = NO;
//            if(self.selectHasNavigator == YES)
//            {
//                self.selectThirdDirect = NO;
//            }
//            controller.pushView = NO;
//        }
//        else
//        {
//            if (self.selectHasNavigator == NO) {
//                self.selectHasNavigator = YES;
//            }
//        }
//        
//    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
