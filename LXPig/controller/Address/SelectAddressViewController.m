//
//  SelectAddressViewController.m
//  LXPig
//
//  Created by 李响 on 15/5/28.
//
//

#import "SelectAddressViewController.h"
#import "SelectedTableViewController.h"
#import "AddressViewController.h"
@interface SelectAddressViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SelectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title = @"选择收货地址";
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 4;
    // Do any additional setup after loading the view from its nib.
    SelectedTableViewController* childController = [[SelectedTableViewController alloc]init];
    [self addChildViewController:childController];
    [self.view addSubview:childController.view];
    childController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-[bottomView]" options:0 metrics:nil views:@{@"tableView":childController.view,@"bottomView":self.bottomView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView":childController.view}]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showAddressManager:(id)sender {
    AddressViewController* addressController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"address_manager"];
    [self.navigationController pushViewController:addressController animated:YES];
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
