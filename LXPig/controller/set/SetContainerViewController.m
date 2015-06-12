//
//  SetContainerViewController.m
//  LXPig
//
//  Created by 李响 on 15/6/12.
//
//

#import "SetContainerViewController.h"
#import "SettingViewController.h"

@interface SetContainerViewController ()

@end

@implementation SetContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (IOS_SYSTEM_VERSION < 8.0) {
//        [self.view removeConstraint:self.topContraint];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:64]];
//    }
    SettingViewController* controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"set_view_controller"];
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
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
