//
//  MallNaviController.m
//  LXPig
//
//  Created by leexiang on 15/4/16.
//
//

#import "MallNaviController.h"

@interface MallNaviController ()
@property (weak,nonatomic) IBOutlet UITabBarItem *item;
@end

@implementation MallNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS_SYSTEM_VERSION < 7.0f) {
        [self.item setFinishedSelectedImage:[UIImage imageNamed:@"tab_mall_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_mall"]];
    }
    else
    {
        [self.item setImage:[UIImage imageNamed:@"tab_mall"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
