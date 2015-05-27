//
//  PersonalViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/29.
//
//

#import "PersonalViewController.h"
#import "MyQuestionTableViewController.h"
#import "NetWorkClient.h"
#import "AdWebViewController.h"
@interface PersonalViewController ()<ImagePlayerViewDelegate>
@property (weak, nonatomic) IBOutlet ImagePlayerView *adImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton* logOutBtn;
@property (strong, nonatomic) NSArray* adArray;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.tableView.tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    self.logOutBtn.layer.masksToBounds = YES;
    self.logOutBtn.layer.cornerRadius = 4;

    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 35;
    
    // Do any additional setup after loading the view.
    self.adImageView.imagePlayerViewDelegate = self;
    [[NetWorkClient shareInstance]postUrl:SERVICE_AD With:@{@"action":@"advlist",@"type":@"2"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.adArray = [responseObj objectForKey:@"data"];
        [self.adImageView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[[UserManagerObject shareInstance]photoFile]] placeholderImage:nil];
    self.userName.text = [[UserManagerObject shareInstance]name];
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if ([[UserManagerObject shareInstance]userType] == 0) {
//        return 8;
//    }
//    else
//    {
//        return 3;
//    }
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([[UserManagerObject shareInstance]userType] == 0) {
//        switch (indexPath.row) {
//            case 0:
//                return 135;
//                break;
//            case 1:
//                return 88;
//                break;
//            case 2:
//                return 58;
//                break;
//            case 3:
//                return 58;
//                break;
//            case 4:
//                return 58;
//                break;
//            case 5:
//                return 58;
//                break;
//            case 6:
//                return 60;
//                break;
//            case 7:
//                return 55;
//                break;
//            default:
//                return 0;
//                break;
//        }
//    }
//    else
//    {
//        switch (indexPath.row) {
//            case 0:
//                return 58;
//                break;
//            case 1:
//                return 60;
//                break;
//            case 2:
//                return 58;
//                break;
//            default:
//                return 0;
//                break;
//        }
//    }
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([[UserManagerObject shareInstance]userType] == 0) {
//        NSString *identifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        return cell;
//    }
//    else
//    {
//        NSString *identifier = @"";
//        switch (indexPath.row) {
//            case 0:
//                identifier = @"cell2";
//                break;
//            case 1:
//                identifier = @"cell6";
//                break;
//            case 2:
//                identifier = @"cell7";
//                break;
//            default:
//                return nil;
//                break;
//        }
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        return cell;
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        [self.tabBarController.navigationController pushViewController:[[MyQuestionTableViewController alloc]initWithNibName:@"MyQuestionTableViewController" bundle:nil] animated:YES];
    }
}
-(IBAction)logOut:(id)sender
{
    [[UserManagerObject shareInstance]logOut];
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    NSDictionary* dic = self.adArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:nil];
}

-(NSInteger)numberOfItems
{
    return self.adArray.count;
}
-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSDictionary* dic = self.adArray[index];
    AdWebViewController *controller = [[AdWebViewController alloc]initWithNibName:@"AdWebViewController" bundle:nil];
    controller.adInfo = dic;
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
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
