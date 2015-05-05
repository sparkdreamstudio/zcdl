//
//  DistrictViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "DistrictViewController.h"
#import "NetWorkClient.h"
#import "LocationNaviViewController.h"
@interface DistrictViewController ()
@property (strong,nonatomic) NSArray* districtArray;
@end

@implementation DistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    // Do any additional setup after loading the view.
    LocationNaviViewController* controller = (LocationNaviViewController*) self.navigationController;
    NSString* city = controller.temp.city;
    [[NetWorkClient shareInstance]postUrl:SERVICE_AREAR With:@{@"city":city,@"action":@"loadDistrictByCity"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.districtArray = [responseObj objectForKey:@"data"];
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
        return self.districtArray.count;
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
        cell.textLabel.text = [self.districtArray[indexPath.row] objectForKey:@"val"];
        return cell;
    }
    else
    {
        return nil;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationNaviViewController* controller = (LocationNaviViewController*) self.navigationController;
    if (tableView == self.tableView) {
        controller.temp.district = [self.districtArray[indexPath.row] objectForKey:@"val"];
        
    }
    else
    {
        
    }

    
    controller.location.province = controller.temp.province;
    controller.location.city = controller.temp.city;
    [controller.location setValue:controller.temp.district forKey:@"district"];
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
