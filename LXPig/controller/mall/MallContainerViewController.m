//
//  MallContainerViewController.m
//  LXPig
//
//  Created by 李响 on 15/6/12.
//
//

#import "MallContainerViewController.h"
#import "MallHomeController.h"
@interface MallContainerViewController ()

@end

@implementation MallContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MallHomeController* controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"main_mall_controller"];
    [controller.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":controller.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":controller.view}]];
    // Do any additional setup after loading the view.
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
