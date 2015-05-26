//
//  ConfirmOrdViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "ConfirmOrdViewController.h"
#import "ConfirmOrderContainerViewController.h"
@interface ConfirmOrdViewController ()

@end

@implementation ConfirmOrdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
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
    if ([segue.identifier isEqualToString:@"show_confirm_order_view"]) {
        ConfirmOrderContainerViewController* controller = [segue destinationViewController];
        controller.qianGouProduct = self.qianGouProduct;
    }
}


@end
