//
//  AddressTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/30.
//
//

#import "AddressTableViewController.h"
#import "AddressTableViewController.h"
#import "AddressManager.h"
#import "AddressManageTableViewCell.h"
@interface AddressTableViewController ()
@property (weak,nonatomic)AddressTableViewController * addressTableViewController;
@end

@implementation AddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AddressManager shareInstance] addressArray].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressManageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadAddress:[[AddressManager shareInstance] addressArray][indexPath.row]];
    return cell;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segue_address_table"]) {
        self.addressTableViewController = [segue destinationViewController];
    }
}


@end
