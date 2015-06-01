//
//  SearchEnterpriseController.m
//  LXPig
//
//  Created by leexiang on 15/5/2.
//
//

#import "SearchEnterpriseController.h"
#import "NetWorkClient.h"
#import "ProductInfo.h"
#import "ProductInfoTableViewCell.h"
#import "ProductDetailViewController.h"
@interface SearchEnterpriseController ()<UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,assign)    NSInteger currentPage;
@property (nonatomic,strong)    NSMutableArray* infos;
@property (nonatomic,strong)    UILabel* emptyLabel;
@end

@implementation SearchEnterpriseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-10, 44);
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    [self addInfinitScorll];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[flexSpacer,[[UIBarButtonItem alloc]initWithCustomView:self.searchBar]];
    self.navigationItem.hidesBackButton = YES;
    [self.searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    
    self.emptyLabel = [[UILabel alloc]init];
    self.emptyLabel.textColor = HEXCOLOR(@"848484");
    self.emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.emptyLabel.text = @"暂无数据";
    [self.view addSubview:self.emptyLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.emptyLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.emptyLabel attribute:NSLayoutAttributeCenterY multiplier:2 constant:0]];
    self.emptyLabel.hidden = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)infinitScorll
{
    _currentPage++;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:[NSNumber numberWithInteger:_currentPage] forKey:@"currentPageNo"];
    [params setValue:@"10" forKey:@"pageSize"];
    
    [params setValue:self.searchBar.text forKey:@"keyword"];
  
    
    __weak SearchEnterpriseController* weakself = self;
    [[NetWorkClient shareInstance]postUrl:SERVICE_PRODUCT With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        NSArray* array = [weakself getDataArray:[responseObj objectForKey:@"data"]];
        if(array.count == 0)
        {
            weakself.currentPage--;
            return ;
        }
        [weakself.infos addObjectsFromArray:array];
        [weakself.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        weakself.currentPage--;
        
    }];
}

#pragma mark -searchbar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _currentPage = 1;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:[NSNumber numberWithInteger:_currentPage] forKey:@"currentPageNo"];
    [params setValue:@"10" forKey:@"pageSize"];
    
    [params setValue:searchBar.text forKey:@"keyword"];
   
    
    __weak SearchEnterpriseController* weakself = self;
    [[NetWorkClient shareInstance]postUrl:SERVICE_PRODUCT With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        weakself.infos = [weakself getDataArray:[responseObj objectForKey:@"data"]];
        if (weakself.infos.count > 10) {
            [weakself setInfinitScorllHidden:NO];
        }
        else
        {
            [weakself setInfinitScorllHidden:YES];
        }
        if (weakself.infos.count == 0) {
            self.emptyLabel.hidden = NO;
        }
        else
        {
            self.emptyLabel.hidden = YES;
        }
        [weakself.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}
-(NSMutableArray*)getDataArray:(NSArray*)dataArray
{
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dic in dataArray) {
        ProductInfo* info = [[ProductInfo alloc]init];
        info.keyId = [[dic objectForKey:@"id"]longLongValue];
        info.enterprise = [[EnterpriseInfo alloc]init];
        //        for (NSDictionary* enterDic in [dic objectForKey:@"enterprise"]) {
        info.enterprise.keyId = [[[dic objectForKey:@"enterprise"] objectForKey:@"id"]longLongValue];
        info.enterprise.name = [[dic objectForKey:@"enterprise"] objectForKey:@"name"];
        info.enterprise.tel = [[dic objectForKey:@"enterprise"] objectForKey:@"tel"];
        info.enterprise.fax = [[dic objectForKey:@"enterprise"] objectForKey:@"fax"];
        info.enterprise.address = [[dic objectForKey:@"enterprise"] objectForKey:@"address"];
        info.enterprise.intro = [[dic objectForKey:@"enterprise"] objectForKey:@"intro"];
        //        }
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
        [array addObject:info];
    }
    return array;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.infos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell loadProductInfo:self.infos[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"search_enterprise_show" sender:self.infos[indexPath.row]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"search_enterprise_show"])
    {
        ProductDetailViewController* controller = [segue destinationViewController];
        controller.info = sender;
    }
}


@end
