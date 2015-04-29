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
