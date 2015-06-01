//
//  RightMenuViewController.m
//  LXPig
//
//  Created by 李响 on 15/6/1.
//
//

#import "RightMenuViewController.h"
#import "SlideViewController.h"
@interface RightMenuViewController ()<UIAlertViewDelegate>

@end

@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 0:
        {
            [self.slideController showCenterView];
            [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SHOW_POST_QUESTION object:nil];
            break;
        }
        case 1:
            
            [self.slideController showCenterView];
            [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SHOW_ORDER object:nil];
            break;
        case 2:
        {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否拨打电话:4008004047" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
            [alertView show];
            break;
        }
        case 3:
            [self.slideController showCenterView];
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4008004047"]];
    }
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
