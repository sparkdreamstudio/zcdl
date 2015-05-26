//
//  LimitPromotionViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/19.
//
//

#import "LimitPromotionViewController.h"
#import "LimitEndTableViewCell.h"
#import "LimitNotStartTableViewCell.h"
#import "LimitPromotionTableViewCell.h"
#import "NetWorkClient.h"
#import "ProductDetailViewController.h"
#import "ProductInfo.h"
@interface LimitPromotionViewController ()
@property (strong,nonatomic) NSMutableArray* productList;
@property (assign,nonatomic) NSInteger currentPage;
@property (strong,nonatomic) NSString *urlString;
@end

@implementation LimitPromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullRefresh];
    [self addBackButton];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.type == 0) {
        self.title = @"限量抢购";
        self.urlString = SERVICE_LIMITNUMB;
    }
    else if (self.type == 1)
    {
        self.title = @"限时抢购";
        self.urlString = SERVICE_LIMITTIME;
    }
    else
    {
        self.title = @"组团抢购";
        self.urlString = SERVICE_LIMITGROUP;
    }
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"LimitEndTableViewCell" bundle:nil] forCellReuseIdentifier:@"LimitEndTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LimitNotStartTableViewCell" bundle:nil] forCellReuseIdentifier:@"LimitNotStartTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LimitPromotionTableViewCell" bundle:nil] forCellReuseIdentifier:@"LimitPromotionTableViewCell"];

    
    [self startRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pullRfresh
{
    self.currentPage = 1;
    [[NetWorkClient shareInstance]postUrl:self.urlString With:@{@"action":@"list"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.productList = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
//        if (self.newsArray.count < 20) {
//            [self setInfinitScorllHidden:YES];
//        }
//        else{
//            [self setInfinitScorllHidden:NO];
//        }
        [self.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
    }];
}

//-(void)infinitScorll
//{
//    self.currentPage++;
//    [[NetWorkClient shareInstance]postUrl:self.urlString  With:@{@"action":@"list",@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20",@"codeId":self.val} success:^(NSDictionary *responseObj, NSString *timeSp) {
//        [self stopInfinitScorll];
//        NSArray* array = [responseObj objectForKey:@"data"];
//        if (array.count == 0) {
//            [self setInfinitScorllHidden:YES];
//            return ;
//        }
//        if (array.count < 20) {
//            [self setInfinitScorllHidden:YES];
//        }
//        else{
//            [self setInfinitScorllHidden:NO];
//        }
//        [self.newsArray addObjectsFromArray:array];
//        NSMutableArray* indexPathArray = [NSMutableArray array];
//        for (NSInteger index = self.newsArray.count-array.count; index < self.newsArray.count; index++) {
//            [indexPathArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
//        }
//        [self.tableView beginUpdates];
//        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];
//    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
//        [self stopInfinitScorll];
//        self.currentPage--;
//    }];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  215;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary* dic = self.productList[indexPath.row];
    NSInteger status = [dic[@"status"] integerValue];
    if (status == 1) {
        LimitNotStartTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LimitNotStartTableViewCell" forIndexPath:indexPath];
        [cell loadCell:dic WithType:self.type];
        return cell;
    }
    else if(status == 2){
        LimitPromotionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LimitPromotionTableViewCell" forIndexPath:indexPath];
        [cell loadCell:dic WithType:self.type];
        return cell;
    }
    else{
        LimitEndTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LimitEndTableViewCell" forIndexPath:indexPath];
        [cell loadCell:dic WithType:self.type];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary* dic = self.newsArray[indexPath.row];
//    InfoDetailViewController* controller = [[InfoDetailViewController alloc]initWithNibName:@"InfoDetailViewController" bundle:nil];
//    controller.htmlString = dic[@"newstext"];
//    [self.controller.navigationController pushViewController:controller animated:YES];
    NSDictionary* dic = self.productList[indexPath.row][@"product"];
    ProductInfo* info = [[ProductInfo alloc]init];
    info.keyId = [[dic objectForKey:@"id"]longLongValue];
    info.enterprise = [[EnterpriseInfo alloc]init];
    info.enterprise.keyId = [[[dic objectForKey:@"enterprise"] objectForKey:@"id"]longLongValue];
    info.enterprise.name = [[dic objectForKey:@"enterprise"] objectForKey:@"name"];
    info.enterprise.tel = [[dic objectForKey:@"enterprise"] objectForKey:@"tel"];
    info.enterprise.fax = [[dic objectForKey:@"enterprise"] objectForKey:@"fax"];
    info.enterprise.address = [[dic objectForKey:@"enterprise"] objectForKey:@"address"];
    info.enterprise.intro = [[dic objectForKey:@"enterprise"] objectForKey:@"intro"];
    info.name = [dic objectForKey:@"name"];
    info.marketPrice = [[dic objectForKey:@"marketPrice"] integerValue];
    info.salePrice = [[dic objectForKey:@"salePrice"]integerValue];
    info.smallImg = [dic objectForKey:@"smallImg"];
    info.unit = [dic objectForKey:@"unit"];
    info.intro = [dic objectForKey:@"intro"];
    info.status = [[dic objectForKey:@"status"] integerValue];
    info.seq = [[dic objectForKey:@"seq"] integerValue];
    info.praise =[dic objectForKey:@"praise"];
    info.orderCnt = [[dic objectForKey:@"orderCnt"] integerValue];
    ProductDetailViewController* controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"product_detail"];
    controller.type = 1;
    controller.info = info;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
