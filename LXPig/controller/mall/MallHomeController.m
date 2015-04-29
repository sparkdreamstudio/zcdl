//
//  ViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/6.
//
//

#import "MallHomeController.h"
#import "ProductInfoList.h"
#import "ProductInfoTableViewCell.h"
#import "UIViewController+LXPig.h"
#import "EnterpriseListViewController.h"
#import "NetWorkClient.h"
#import "ProductDetailViewController.h"
#import "FilterView.h"

@interface MallHomeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ProductInfoListDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *headerBackView;



@property (nonatomic,strong)    ProductInfoList* productInfoList;
@property (nonatomic,strong)    NSMutableArray* menuArray;

@end

@implementation MallHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuArray = [NSMutableArray array];
    //self.searchBar.frame = CGRectMake((1-0.778)*SCREEN_WIDTH/2, 2, 0.778*SCREEN_WIDTH, 44);
    //[self.searchBar setFrame:CGRectMake(0, 192, SCREEN_WIDTH, 44)];
    //self.searchBar.translatesAutoresizingMaskIntoConstraints = YES;
    self.productInfoList = [[ProductInfoList alloc]init];
    [self.productInfoList setDelegate:self];
    [self addPullRefresh];
    [self addInfinitScorll];
    
    [self getPicCode];
    
    [self.headerBackView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 158)];
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self startRefresh];
    
    
    if (self.tableView.style == UITableViewStylePlain) {
        UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        [self.tableView setTableFooterView:footerView];
    }
    UIView* tablebackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tablebackView.backgroundColor = [UIColor colorWithRed:0xe6/255.f green:0xe6/255.f blue:0xe6/255.f alpha:1];
    [self.tableView setBackgroundView:tablebackView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)setEnterpriseId:(NSNumber *)enterpriseId
{
    _enterpriseId = enterpriseId;
    _keyWord = nil;
    _codeId = nil;
    _orderList = nil;
    [self startRefresh];
}
-(void)setKeyWord:(NSString *)keyWord
{
    _enterpriseId = nil;
    _keyWord = keyWord;
    _codeId = nil;
    _orderList = nil;
    [self startRefresh];
}

-(void)setCodeId:(NSNumber *)codeId
{
    _enterpriseId = nil;
    _keyWord = nil;
    _codeId = codeId;
    _orderList = nil;
    [self startRefresh];
}

-(void)setOrderList:(NSNumber *)orderList
{
    _enterpriseId = nil;
    _keyWord = nil;
    _codeId = nil;
    _orderList = orderList;
    [self startRefresh];
}

-(void)getPicCode
{
    [[NetWorkClient shareInstance]postUrl:SERVICE_CODESERVICE With:@{@"action":@"listByParentId",@"parentId":@"1"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        NSMutableArray* picCodeArray = [NSMutableArray array];
        NSArray* data= [responseObj objectForKey:@"data"];
        for (NSDictionary* dic in data) {
            NSDictionary *firstDic = [NSMutableDictionary dictionary];
            [firstDic setValue:[dic objectForKey:@"name"] forKey:@"Title"];
            NSMutableArray* ChildArray = [NSMutableArray array];
            for (NSDictionary* dic2 in [dic objectForKey:@"childCode"]) {
                NSMutableDictionary* childDic = [NSMutableDictionary dictionary];
                [childDic setValue:[dic2 objectForKey:@"name"] forKey:@"Title"];
                [ChildArray addObject:childDic];
            }
            [firstDic setValue:ChildArray forKey:@"Children"];
            [picCodeArray addObject:firstDic];
        }
        NSArray *orderListArray = @[@{@"Title":@"订单量排行"},
                                    @{@"Title":@"好评率排行"},
                                    @{@"Title":@"发情率排行"}];
        [self.menuArray addObject:picCodeArray];
        [self.menuArray addObject:orderListArray];
        [self.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)pullRfresh
{
    [self.productInfoList refreshProductWithSearchKeyWord:_keyWord enterpriseId:_enterpriseId codeId:_codeId orderList:_orderList];
}

-(void)infinitScorll
{
    [self.productInfoList getNextPage];
}

-(void)productInfoListRefreshSuccess:(ProductInfoList *)list
{
    if ([list getCount] < 10) {
        [self setInfinitScorllHidden:YES];
    }
    else{
        [self setInfinitScorllHidden:NO];
    }
    [self stopPull];
    [self.tableView reloadData];
}

-(void)productInfoList:(ProductInfoList *)list failureMessage:(NSString *)message
{
    [self stopPull];
    [self stopInfinitScorll];
}

-(void)productInfoList:(ProductInfoList *)list NextInfos:(NSRange)range
{
    [self stopInfinitScorll];
    if (range.length < 10) {
        [self setInfinitScorllHidden:YES];
    }
    NSMutableArray* array = [NSMutableArray array];
    for (NSUInteger i = range.location; i < range.length; i++) {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productInfoList getCount];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 44)];
    UIButton* selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, 44);
    [selectButton setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];
    [selectButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [selectButton setTitle:@"种猪企业" forState:UIControlStateNormal];
    [selectButton setTitleColor:TextGrayColor forState:UIControlStateNormal];
    [selectButton setTitleColor:NavigationBarColor forState:UIControlStateSelected];
    selectButton.tag = 1;
    [selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:selectButton];
    
    FilterView* menu = [[FilterView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/2, 44) buttonTitleArray:@[@"品种",@"排行"] dataSourceArray:self.menuArray delegate:nil];
    [headerView addSubview:menu];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadProductInfo:[self.productInfoList getProductInfo:indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductInfo* sendInfo = [self.productInfoList getProductInfo:indexPath.row];
    [self performSegueWithIdentifier:@"product_detail" sender:sendInfo];
}
-(void)buttonClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 1:
        {
            [self performSegueWithIdentifier:@"go_enterprise_list" sender:self];
            break;
        }
        default:
            break;
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"go_enterprise_list"]) {
        EnterpriseListViewController* controller = [segue destinationViewController];
        controller.controller = sender;
    }
    else if([segue.identifier isEqualToString:@"product_detail"])
    {
        ProductDetailViewController* controller = [segue destinationViewController];
        controller.info = sender;
    }
}



@end
