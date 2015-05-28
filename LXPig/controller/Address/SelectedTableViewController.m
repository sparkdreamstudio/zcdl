//
//  SelectedTableViewController.m
//  LXPig
//
//  Created by 李响 on 15/5/28.
//
//

#import "SelectedTableViewController.h"
#import "AddressManager.h"
#import "SelectAddressTableViewCell.h"
@interface SelectedTableViewController ()

@end

@implementation SelectedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    SelectAddressTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadAddress:[[AddressManager shareInstance] addressArray][indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SETORDERADDRESS object:[[AddressManager shareInstance]addressArray][indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
