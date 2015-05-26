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
@interface LXPigTabBarController ()

@end

@implementation LXPigTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (int index = 0; index < self.viewControllers.count; ++index) {
        switch (index) {
            case 0:
            {
                if (IOS_SYSTEM_VERSION < 7.0f) {
                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_mall_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_mall"]];
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
                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_info"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_info_selected"]];
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
                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_q&a"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_q&a_selected"]];
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
                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_set_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_set"]];
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
                    [[self.viewControllers[index] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_person_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_person"]];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
