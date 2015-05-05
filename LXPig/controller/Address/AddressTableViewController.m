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
#import "EditAddressViewController.h"
@interface AddressTableViewController ()
@property (weak,nonatomic)EditAddressViewController * addressTableViewController;

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.model != 1)
    {
        [self performSegueWithIdentifier:@"address_edit" sender:[[AddressManager shareInstance]addressArray][indexPath.row]];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SETORDERADDRESS object:[[AddressManager shareInstance]addressArray][indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"address_edit"]) {
        self.addressTableViewController = [segue destinationViewController];
        self.addressTableViewController.address = sender;
    }
}


@end
