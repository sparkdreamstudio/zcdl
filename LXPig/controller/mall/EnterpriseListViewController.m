//
//  EnterpriseListViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/20.
//
//

#import "EnterpriseListViewController.h"
#import "NetWorkClient.h"
#import "UIViewController+LXPig.h"
#import "ProductInfo.h"
#import "MallHomeController.h"
@interface EnterpriseListViewController ()

@property (strong,nonatomic)NSMutableArray* enterpriseList;
@property (assign,nonatomic)NSInteger currentPage;

@end

@implementation EnterpriseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.tableView.style == UITableViewStylePlain) {
        UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        [self.tableView setTableFooterView:footerView];
    }
    // Do any additional setup after loading the view.
    _currentPage = 0;
    _enterpriseList = [NSMutableArray array];
    [self addBackButton];
    [self addPullRefresh];
    [self addInfinitScorll];
    [self startRefresh];
}

-(void)pullRfresh
{
    self.currentPage = 1;
    __weak EnterpriseListViewController* weakself = self;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPageNo"];
    [params setValue:@"20" forKey:@"pageSize"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_ENTERPRISE With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        NSArray* array = [responseObj objectForKey:@"data"];
        [weakself.enterpriseList removeAllObjects];
        for (NSDictionary*dic in array) {
            EnterpriseInfo* info = [[EnterpriseInfo alloc]init];
            info.keyId = [[dic objectForKey:@"id"]longLongValue];
            info.name = [dic objectForKey:@"name"];
            info.tel = [dic objectForKey:@"tel"];
            info.fax = [dic objectForKey:@"fax"];
            info.address = [dic objectForKey:@"address"];
            info.intro = [dic objectForKey:@"intro"];
            [weakself.enterpriseList addObject:info];
        }
        [weakself.tableView reloadData];
        [weakself stopPull];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [weakself stopPull];
        if (responseObj) {
            [weakself  showErrorHudDimissWithString:[responseObj objectForKey:@"message"]];
        }
    }];
}

-(void)infinitScorll
{
    self.currentPage++;
    __weak EnterpriseListViewController* weakself = self;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPageNo"];
    [params setValue:@"20" forKey:@"pageSize"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_ENTERPRISE With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        NSArray* array = [responseObj objectForKey:@"data"];
        NSMutableArray* infoArray = [NSMutableArray array];
        for (NSDictionary*dic in array) {
            EnterpriseInfo* info = [[EnterpriseInfo alloc]init];
            info.keyId = [[dic objectForKey:@"id"]longLongValue];
            info.name = [dic objectForKey:@"name"];
            info.tel = [dic objectForKey:@"tel"];
            info.fax = [dic objectForKey:@"fax"];
            info.address = [dic objectForKey:@"address"];
            info.intro = [dic objectForKey:@"intro"];
            [infoArray addObject:info];
        }
        [weakself.enterpriseList addObjectsFromArray:infoArray];
        [weakself.tableView beginUpdates];
        NSMutableArray* indexpathArray = [NSMutableArray array];
        for (NSUInteger index = weakself.enterpriseList.count-infoArray.count-1; index<weakself.enterpriseList.count-1; index++) {
            [indexpathArray addObject:[NSIndexPath indexPathForRow:index+1 inSection:0]];
        }
        [weakself.tableView insertRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationNone];
        [weakself.tableView endUpdates];
        [weakself stopInfinitScorll];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [weakself stopInfinitScorll];
        if (responseObj) {
            [weakself  showErrorHudDimissWithString:[responseObj objectForKey:@"message"]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.enterpriseList.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"查看全部企业";
            break;
        }
        default:
        {
            EnterpriseInfo *info = self.enterpriseList[indexPath.row-1];
            cell.textLabel.text = info.name;
            break;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber* enterpriseId = nil;
    switch (indexPath.row) {
        case 0:
        {
            enterpriseId = nil;
            break;
        }
        default:
        {
            EnterpriseInfo *info = self.enterpriseList[indexPath.row-1];
            enterpriseId = [NSNumber numberWithLongLong:info.keyId];
            break;
        }
    }
//    [self.controller setValue:enterpriseId forKey:@"enterpriseId"];
//    [self.controller startRefresh];
    [self.controller setEnterpriseId:enterpriseId];
    [self.navigationController popViewControllerAnimated:YES];
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
