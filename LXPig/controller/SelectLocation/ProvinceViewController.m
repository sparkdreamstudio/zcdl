//
//  ProvinceViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "ProvinceViewController.h"
#import "NetWorkClient.h"
#import "LocationNaviViewController.h"
@interface ProvinceViewController ()
@property (strong,nonatomic)NSArray* provinceArray;
@end

@implementation ProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NetWorkClient shareInstance]postUrl:SERVICE_AREAR With:@{@"action":@"loadProvince"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.provinceArray = [responseObj objectForKey:@"data"];
        [self.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.provinceArray.count;
    }
    else
    {
        return 0;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = [self.provinceArray[indexPath.row] objectForKey:@"val"];
        return cell;
    }
    else
    {
        return nil;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        LocationNaviViewController* controller = (LocationNaviViewController*) self.navigationController;
        controller.temp.province = [self.provinceArray[indexPath.row] objectForKey:@"val"];
    }
    else
    {
        
    }
}

-(IBAction)cancel:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
