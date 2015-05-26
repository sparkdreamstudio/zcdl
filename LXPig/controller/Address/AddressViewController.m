//
//  AddressViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/30.
//
//

#import "AddressViewController.h"
#import "AddressTableViewController.h"
@interface AddressViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;
@property (weak,nonatomic) AddressTableViewController* controller;


@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.addAddressBtn.layer.masksToBounds = YES;
    self.addAddressBtn.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.controller.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addNewAddress:(id)sender {
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segue_address_table"]) {
        self.controller = [segue destinationViewController];
        self.controller.model = self.model;
    }
}


@end
