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
#import "AdWebViewController.h"
#import "LimitPromotionViewController.h"
@interface MallHomeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ProductInfoListDelegate,ImagePlayerViewDelegate>
{
    NSInteger showMenus;
    NSInteger menuSelected;
    NSInteger subSelected;
    NSInteger changeButtonIndex;
    NSString *changeButtonString;
}
@property (weak, nonatomic) IBOutlet UIButton *fakeSearchBar;

@property (weak, nonatomic) IBOutlet UIView *headerBackView;

@property (weak, nonatomic) IBOutlet ImagePlayerView *adImageView;

@property (nonatomic,strong)    ProductInfoList* productInfoList;
@property (nonatomic,strong)    NSMutableArray* menuArray;
@property (nonatomic,weak)    NSMutableArray* subTableViewArray;
@property (nonatomic,strong)    UITableView* subTableView;
@property (nonatomic,strong)    UITableView* mainTableView;
@property (nonatomic,strong)    UIButton* topHideBtn;
@property (nonatomic,strong)    UIButton* bottomHideBtn;
@property (nonatomic,strong)    UIButton* pingZhongBtn;
@property (nonatomic,strong)    UIButton* paiHangBtn;
@property (nonatomic,strong)    UIButton* huodongBtn;

@property (strong, nonatomic) NSArray* adArray;

@end

@implementation MallHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    showMenus = 0;
    menuSelected = 0;
    subSelected = 0;
    
    self.menuArray = [NSMutableArray array];
    [self.fakeSearchBar setImage:[self scaleToSize:[UIImage imageNamed:@"new_search_icon"] size:CGSizeMake(15, 15) ] forState:UIControlStateNormal];
    [self.fakeSearchBar setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.fakeSearchBar setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    self.fakeSearchBar.layer.masksToBounds = YES;
    self.fakeSearchBar.layer.cornerRadius = 13;
    [self.fakeSearchBar setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    self.productInfoList = [[ProductInfoList alloc]init];
    [self.productInfoList setDelegate:self];
    [self addPullRefresh];
    [self addInfinitScorll];
    
    [self getPicCode];
    
    [self.headerBackView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.36)];
    self.adImageView.imagePlayerViewDelegate = self;
    self.adImageView.hidePageControl = YES;
    [self startRefresh];
    
    
    if (self.tableView.style == UITableViewStylePlain) {
        UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        [self.tableView setTableFooterView:footerView];
    }
    UIView* tablebackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tablebackView.backgroundColor = [UIColor colorWithRed:0xe6/255.f green:0xe6/255.f blue:0xe6/255.f alpha:1];
    [self.tableView setBackgroundView:tablebackView];
    
    [[NetWorkClient shareInstance]postUrl:SERVICE_AD With:@{@"action":@"advlist",@"type":@"1"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.adArray = [responseObj objectForKey:@"data"];
        [self.adImageView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideMenu:nil];
    showMenus = 0;
    self.pingZhongBtn.selected = NO;
    self.paiHangBtn.selected = NO;
    self.huodongBtn.selected = NO;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
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
    changeButtonIndex = 0;
    changeButtonString = @"";
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
                [childDic setValue:[dic2 objectForKey:@"id"] forKey:@"ID"];
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

-(IBAction)showRightMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SHOW_RIGHT_MENU object:nil];
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
    for (NSUInteger i = range.location; i < (range.location+range.length); i++) {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.tableView) {
        return [self.productInfoList getCount];
    }
    else if (tableView.tag == 1)
    {
        return [self.menuArray[0] count];
    }
    else if (tableView.tag == 2)
    {
        return self.subTableViewArray.count;
    }
    else if (tableView.tag == 3)
    {
        return 3;
    }
    else
    {
        return [self.menuArray[1] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (showMenus == 0) {
            return 44;
        }
        else
        {
            return self.view.frame.size.height;
        }
    }
    else{
        return 0;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 44)];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, 44);
        [button setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:@"种猪企业" forState:UIControlStateNormal];
        [button setTitleColor:TextGrayColor forState:UIControlStateNormal];
        [button setTitleColor:NavigationBarColor forState:UIControlStateSelected];
        button.tag = 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        
        self.pingZhongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pingZhongBtn.frame = CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 44);
        [self.pingZhongBtn setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];
        [self.pingZhongBtn setImage:[UIImage imageNamed:@"mall_main_menu_normal"] forState:UIControlStateNormal];
        [self.pingZhongBtn setImage:[UIImage imageNamed:@"mall_main_menu_selected"] forState:UIControlStateSelected];
        [self.pingZhongBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        if (changeButtonIndex == 1) {
            [self.pingZhongBtn setTitle:changeButtonString forState:UIControlStateNormal];
        }
        else
        {
            [self.pingZhongBtn setTitle:@"品种" forState:UIControlStateNormal];
        }
        
        [self.pingZhongBtn setTitleColor:TextGrayColor forState:UIControlStateNormal];
        [self.pingZhongBtn setTitleColor:NavigationBarColor forState:UIControlStateSelected];
        self.pingZhongBtn.tag = 2;
        [self.pingZhongBtn setSelected:showMenus == 2?YES:NO];
        [self.pingZhongBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.pingZhongBtn];
        
        self.paiHangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.paiHangBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, 44);
        [self.paiHangBtn setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];
        [self.paiHangBtn setImage:[UIImage imageNamed:@"mall_main_menu_normal"] forState:UIControlStateNormal];
        [self.paiHangBtn setImage:[UIImage imageNamed:@"mall_main_menu_selected"] forState:UIControlStateSelected];
        [self.paiHangBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        if (changeButtonIndex == 2) {
            [self.paiHangBtn setTitle:changeButtonString forState:UIControlStateNormal];
        }
        else
        {
            [self.paiHangBtn setTitle:@"排行" forState:UIControlStateNormal];
        }
        
        [self.paiHangBtn setTitleColor:TextGrayColor forState:UIControlStateNormal];
        [self.paiHangBtn setTitleColor:NavigationBarColor forState:UIControlStateSelected];
        [self.paiHangBtn setSelected:showMenus == 1?YES:NO];
        self.paiHangBtn.tag = 3;
        [self.paiHangBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.paiHangBtn];
        
        self.huodongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.huodongBtn.frame = CGRectMake(SCREEN_WIDTH/4*3, 0, SCREEN_WIDTH/4, 44);
        [self.huodongBtn setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];
        [self.huodongBtn setImage:[UIImage imageNamed:@"mall_main_menu_normal"] forState:UIControlStateNormal];
        [self.huodongBtn setImage:[UIImage imageNamed:@"mall_main_menu_selected"] forState:UIControlStateSelected];
        [self.huodongBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.huodongBtn setTitle:@"最新活动" forState:UIControlStateNormal];
        [self.huodongBtn setTitleColor:TextGrayColor forState:UIControlStateNormal];
        [self.huodongBtn setTitleColor:NavigationBarColor forState:UIControlStateSelected];
        self.huodongBtn.tag = 4;
        [self.huodongBtn setSelected:showMenus == 3?YES:NO];
        [self.huodongBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.huodongBtn];
        self.tableView.scrollEnabled = YES;
        
        return headerView;
    }
    else{
        return  [[UIView alloc]init];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return 112;
    }
    else if (tableView.tag == 1)
    {
        return 44;
    }
    else if (tableView.tag == 2)
    {
        return 44;
    }
    else
    {
        return 44;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        ProductInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell loadProductInfo:[self.productInfoList getProductInfo:indexPath.row]];
        return cell;
    }
    else if (tableView.tag == 1)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.menuArray[0][indexPath.row] objectForKey:@"Title"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
         return cell;
    }
    else if (tableView.tag == 2)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.subTableViewArray[indexPath.row] objectForKey:@"Title"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }
    else if (tableView.tag == 4)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"限量抢购";
                break;
            case 1:
                cell.textLabel.text = @"限时抢购";
                break;
            case 2:
                cell.textLabel.text = @"组团抢购";
                break;
            default:
                break;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.menuArray[1][indexPath.row] objectForKey:@"Title"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        ProductInfo* sendInfo = [self.productInfoList getProductInfo:indexPath.row];
        [self performSegueWithIdentifier:@"product_detail" sender:sendInfo];
    }
    else if (tableView.tag == 3)
    {
        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        changeButtonIndex = 2;
        changeButtonString = cell.textLabel.text;
        NSInteger row = indexPath.row+1;
        [self hideMenu:^{
            showMenus = 0;
            [self setOrderList:[NSNumber numberWithInteger:row]];
            self.paiHangBtn.selected = NO;
        }];
        

    }
    else if (tableView.tag == 1)
    {
        showMenus = 0;
        menuSelected = indexPath.row;
        self.subTableViewArray = [self.menuArray[0][indexPath.row] objectForKey:@"Children"];
        if(self.subTableViewArray.count == 0)
        {
            
            [self hideMenu:^{
                [self setCodeId:nil];
                changeButtonIndex = 1;
                changeButtonString = @"品种";
                [self setCodeId:nil];
                self.pingZhongBtn.selected = NO;
            }];
        }
        else{
            [self.subTableView reloadData];
        }
        
    }
    else if (tableView.tag == 2)
    {
        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        changeButtonIndex = 1;
        changeButtonString = cell.textLabel.text;
        NSInteger row = indexPath.row;
        [self hideMenu:^{
            showMenus = 0;
            subSelected = indexPath.row;
            [self setCodeId:[self.subTableViewArray[row] objectForKey:@"ID"]];
            self.pingZhongBtn.selected = NO;
        }];
    }
    else if (tableView.tag == 4)
    {
        showMenus = 0;
        NSInteger type = indexPath.row;
        self.huodongBtn.selected = NO;
        [self hideMenu:^{
            LimitPromotionViewController *controller = [[LimitPromotionViewController alloc]init];
            controller.type = type;
            [self.tabBarController.navigationController pushViewController:controller animated:YES];
        }];
        
    }
    
}
-(void)buttonClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 1:
        {
            [self performSegueWithIdentifier:@"go_enterprise_list" sender:self];
            showMenus = 0;
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            
            break;
        }
        case 3:
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                showMenus = 1;
                [self showMenuWithView:sender];
                self.pingZhongBtn.selected = NO;
                self.huodongBtn.selected = NO;
            }
            else
            {
                [self hideMenu:^{
                    showMenus = 0;
                    [self.tableView reloadData];
                }];
            }
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView setContentOffset:CGPointMake(0, 158) animated:NO];
            
            break;
            //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        case 2:
        {
            [sender setSelected:sender.selected==YES?NO:YES];
//            sender.selected = !sender.selected;
            if (sender.selected) {
                showMenus = 2;
                [self showMenuWithView:sender];
                self.paiHangBtn.selected = NO;
                self.huodongBtn.selected = NO;
            }
            else
            {
                [self hideMenu:^{
                    showMenus = 0;
                    [self.tableView reloadData];
                }];
            }
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView setContentOffset:CGPointMake(0, 158) animated:NO];
            
            break;
        }
        case 4:
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                showMenus = 3;
                [self showMenuWithView:sender];
                self.pingZhongBtn.selected = NO;
                self.paiHangBtn.selected = NO;
            }
            else{
                [self hideMenu:^{
                    showMenus = 0;
                    [self.tableView reloadData];
                }];
            }
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView setContentOffset:CGPointMake(0, 158) animated:NO];
            
            break;
        }
        default:
            break;
    }
}

-(void)showMenuWithView:(UIView*)viewbtn
{
    self.tableView.scrollEnabled = NO;
    if (self.topHideBtn) {
        [self.topHideBtn removeFromSuperview];
        [self.bottomHideBtn removeFromSuperview];
        [self.mainTableView removeFromSuperview];
        [self.subTableView removeFromSuperview];
        self.topHideBtn = nil;
        self.bottomHideBtn = nil;
        self.mainTableView = nil;
        self.subTableView = nil;
    }
    CGRect orginRect = [viewbtn convertRect:viewbtn.frame toView:self.view];
    CGFloat topheight = orginRect.origin.y;
    CGFloat bottomY = orginRect.origin.y+orginRect.size.height;
    CGFloat bottomHeight = self.view.frame.size.height-(orginRect.origin.y+orginRect.size.height);
    self.topHideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topHideBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, orginRect.origin.y);
    [self.topHideBtn addTarget:self action:@selector(hideBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.topHideBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topHideBtn];
    self.bottomHideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomHideBtn.frame = CGRectMake(0, orginRect.origin.y+orginRect.size.height, SCREEN_WIDTH, bottomHeight);
    [self.bottomHideBtn addTarget:self action:@selector(hideBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomHideBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:self.bottomHideBtn];
    if (showMenus==1) {
        self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, bottomY, SCREEN_WIDTH, 0.01) style:UITableViewStylePlain];
        self.mainTableView.tag = 3;
        self.mainTableView.delegate = self;
        self.mainTableView.dataSource = self;
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mainTableView];

        POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, bottomY, SCREEN_WIDTH, 132)];
        [self.mainTableView pop_addAnimation:animation forKey:@"animation"];
    }
    else if (showMenus == 2)
    {
        self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, bottomY, SCREEN_WIDTH/3, 0.01) style:UITableViewStylePlain];
        self.mainTableView.tag = 1;
        self.mainTableView.delegate = self;
        self.mainTableView.dataSource = self;
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mainTableView];
        
        POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, bottomY, SCREEN_WIDTH/3, 132)];
        [self.mainTableView pop_addAnimation:animation forKey:@"animation"];
        
        self.subTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, bottomY, SCREEN_WIDTH/3*2, 0.01) style:UITableViewStylePlain];
        self.subTableView.tag = 2;
        self.subTableView.delegate = self;
        self.subTableView.dataSource = self;
        self.subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.subTableView];
        
        self.subTableViewArray = [self.menuArray[0][menuSelected] objectForKey:@"Children"];
        
        animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH/3, bottomY, SCREEN_WIDTH/3*2, 132)];
        [self.subTableView pop_addAnimation:animation forKey:@"animation"];
    }
    else if (showMenus==3)
    {
        self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, bottomY, SCREEN_WIDTH, 0.01) style:UITableViewStylePlain];
        self.mainTableView.tag = 4;
        self.mainTableView.delegate = self;
        self.mainTableView.dataSource = self;
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:self.mainTableView];
        
        POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, bottomY, SCREEN_WIDTH, 132)];
        [self.mainTableView pop_addAnimation:animation forKey:@"animation"];
    }
}

-(void)hideBtnClick:(UIButton*)btn
{
    [self hideMenu:^{
        showMenus = 0;
        [self.tableView reloadData];
    }];
}
-(void)hideMenu:(void(^)(void))block
{
    if (self.mainTableView) {
        if (self.subTableView) {
            POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, self.mainTableView.frame.origin.y, SCREEN_WIDTH/3, 0.01)];
            [animation setCompletionBlock:^(POPAnimation *an, BOOL finished) {
                if (finished) {
                    if (block) {
                        block();
                    }
                    [self.topHideBtn removeFromSuperview];
                    [self.bottomHideBtn removeFromSuperview];
                    [self.mainTableView removeFromSuperview];
                    [self.subTableView removeFromSuperview];
                    self.subTableView = nil;
                    self.topHideBtn = nil;
                    self.bottomHideBtn = nil;
                    self.mainTableView = nil;
                    self.tableView.scrollEnabled = YES;
                }
            }];
            [self.mainTableView pop_addAnimation:animation forKey:@"animation"];
            
            animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH/3, self.mainTableView.frame.origin.y, SCREEN_WIDTH/3*2, 0.01)];
            [self.subTableView pop_addAnimation:animation forKey:@"animation"];
        }
        else{
            POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, self.mainTableView.frame.origin.y, SCREEN_WIDTH, 0.01)];
            [animation setCompletionBlock:^(POPAnimation *an, BOOL finished) {
                if (finished) {
                    if (block) {
                        block();
                    }
                    [self.topHideBtn removeFromSuperview];
                    [self.bottomHideBtn removeFromSuperview];
                    [self.mainTableView removeFromSuperview];
                    self.topHideBtn = nil;
                    self.bottomHideBtn = nil;
                    self.mainTableView = nil;
                    self.tableView.scrollEnabled = YES;
                }
            }];
            [self.mainTableView pop_addAnimation:animation forKey:@"animation"];
        }
    }
    else
    {
        self.topHideBtn = nil;
        self.bottomHideBtn = nil;
        self.mainTableView = nil;
        self.subTableView = nil;
        self.tableView.scrollEnabled = YES;
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
