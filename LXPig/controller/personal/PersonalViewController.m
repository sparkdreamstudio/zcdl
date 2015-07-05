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
#import "AboutViewController.h"
@interface PersonalViewController ()<ImagePlayerViewDelegate>
@property (weak, nonatomic) IBOutlet ImagePlayerView *adImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel* unReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton* logOutBtn;
@property (weak, nonatomic) IBOutlet UIButton* jifenBtn;
@property (strong, nonatomic) NSArray* adArray;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    self.logOutBtn.layer.masksToBounds = YES;
    self.logOutBtn.layer.cornerRadius = 4;

    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 35;
    self.tableView.backgroundColor = HEXCOLOR(@"f3f3f3");
    // Do any additional setup after loading the view.
    self.adImageView.imagePlayerViewDelegate = self;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.5);
    //self.adImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.36);
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
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[[UserManagerObject shareInstance]photoFile]] placeholderImage:[UIImage imageNamed:@"user_default"]];
    if ([[UserManagerObject shareInstance]nickName]&&[[UserManagerObject shareInstance]nickName].length > 0) {
        self.userName.text = [[UserManagerObject shareInstance]nickName];
    }
    else
    {
       self.userName.text = [[UserManagerObject shareInstance]userName];
    }
    
    if ([[UserManagerObject shareInstance] userType] == 0) {
        NSString * integralString = [NSString stringWithFormat:@"%ld",[[UserManagerObject shareInstance] integral]];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前积分：%@分",integralString]];
        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:13.0]
                              range:NSMakeRange(5, integralString.length)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:NavigationBarColor
                              range:NSMakeRange(5, integralString.length)];
        [self.jifenBtn setAttributedTitle:AttributedStr forState:UIControlStateNormal];
        
        [[NetWorkClient shareInstance]postUrl:SERVICE_MESSAGE With:@{@"action":@"total",@"sessionid":[[UserManagerObject shareInstance]sessionid]} success:^(NSDictionary *responseObj, NSString *timeSp) {
            self.unReadLabel.text = [NSString stringWithFormat:@"%@条未读",[[responseObj objectForKey:@"data"]objectForKey:@"cnt"]];
        } failure:^(NSDictionary *responseObj, NSString *timeSp) {
            
        }];
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UserManagerObject shareInstance]userType] == 0) {
        if (indexPath.row == 4) {
            [self.tabBarController.navigationController pushViewController:[[MyQuestionTableViewController alloc]initWithNibName:@"MyQuestionTableViewController" bundle:nil] animated:YES];
        }
        else if (indexPath.row  == 6)
        {
            [self.tabBarController.navigationController pushViewController:[[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil] animated:YES];
        }
    }
    else
    {
        if (indexPath.row == 3) {
            [self.tabBarController.navigationController pushViewController:[[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil] animated:YES];
        }
    }
    
}
-(IBAction)jifenClick:(id)sender
{
    [self showNormalHudDimissWithString:@"积分兑换活动即将推出，敬请关注！"];
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
