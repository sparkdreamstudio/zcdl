//
//  OrderCommentViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/7.
//
//

#import "OrderCommentViewController.h"
#import "OrderCommentTableViewController.h"

@interface OrderCommentViewController ()<JGProgressHUDDelegate>

@end

@implementation OrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title = @"发表评价";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    if (progressHUD.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"order_comment_table"]) {
        OrderCommentTableViewController* controller = [segue destinationViewController];
        controller.orderInfo = self.orderInfo;
        controller.controller = self;
    }
}


@end
