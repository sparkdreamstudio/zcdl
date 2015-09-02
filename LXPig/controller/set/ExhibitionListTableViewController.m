//
//  ExhibitionListTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import "ExhibitionListTableViewController.h"
#import "NetWorkClient.h"
#import "ExhibitionListTableViewCell.h"
#import "ExhibitionDetailViewController.h"
#define PULL_PAGE_SIZE 20
@interface ExhibitionListTableViewController ()
{
    NSInteger showMenus;
    NSInteger changeButtonIndex;
    NSString *changeButtonString;
    NSInteger changeButttonVal;
}
@property (strong,nonatomic) NSMutableArray* exhibitionArray;
@property (assign,nonatomic) NSInteger       currentPage;
@property (strong,nonatomic) UIButton*      diquButton;
@property (strong,nonatomic) UIButton*      timeButton;
@property (strong,nonatomic) UIButton*      typeButton;
@property (nonatomic,strong)    UIButton* topHideBtn;
@property (nonatomic,strong)    UIButton* bottomHideBtn;
@property (nonatomic,strong)    UITableView* mainTableView;
@property (nonatomic,strong) NSArray* diquArray;
@property (nonatomic,strong) NSArray* timeArray;
@property (nonatomic,strong) NSArray* typeArray;
@end

@implementation ExhibitionListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动报名";
    [self addBackButton];
    [self addPullRefresh];
    [self addInfinitScorll];
    [self startRefresh];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ExhibitionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    showMenus = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.diquArray == nil) {
        [[NetWorkClient shareInstance]postUrl:SERVICE_OTHERSERVICE With:@{@"action":@"area"} success:^(NSDictionary *responseObj, NSString *timeSp) {
            NSMutableArray * array = [NSMutableArray array];
            [array addObject:@"全部"];
            [array addObjectsFromArray:[responseObj objectForKey:@"data"]];
            self.diquArray = [NSArray arrayWithArray:array];
        } failure:^(NSDictionary *responseObj, NSString *timeSp) {
            
        }];

    }
    if (self.timeArray == nil)
    {
        [[NetWorkClient shareInstance]postUrl:SERVICE_OTHERSERVICE With:@{@"action":@"time"} success:^(NSDictionary *responseObj, NSString *timeSp) {
            NSMutableArray * array = [NSMutableArray array];
            [array addObject:@"全部"];
            [array addObjectsFromArray:[responseObj objectForKey:@"data"]];
            self.timeArray = [NSArray arrayWithArray:array];
        } failure:^(NSDictionary *responseObj, NSString *timeSp) {
            
        }];
    }
    if (self.typeArray == nil) {
        [[NetWorkClient shareInstance]postUrl:SERVICE_CODESERVICE With:@{@"action":@"listByParentId",@"parentId":@"81"} success:^(NSDictionary *responseObj, NSString *timeSp) {
            NSMutableArray * array = [NSMutableArray array];
            [array addObject:@"全部"];
            [array addObjectsFromArray:[responseObj objectForKey:@"data"]];
            self.typeArray = [NSArray arrayWithArray:array];
        } failure:^(NSDictionary *responseObj, NSString *timeSp) {
            
        }];
    }
}

-(void)pullRfresh
{
    self.currentPage = 1;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary: @{@"action":@"list",@"currentPageNo":@(self.currentPage),@"pageSize":@(PULL_PAGE_SIZE)}];
    if (changeButtonIndex == 1) {
        [params setObject:changeButtonString forKey:@"area"];
    }
    else if (changeButtonIndex == 2)
    {
        [params setObject:changeButtonString forKey:@"time"];
    }
    else if (changeButtonIndex == 3)
    {
        [params setObject:@(changeButttonVal) forKey:@"type"];
    }
    [[NetWorkClient shareInstance]postUrl:SERVICE_EXHIBIT With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.exhibitionArray = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if (self.exhibitionArray.count < PULL_PAGE_SIZE) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        [self.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
    }];
}

-(void)infinitScorll
{
    self.currentPage++;
    [[NetWorkClient shareInstance]postUrl:SERVICE_EXHIBIT With:@{@"action":@"list",@"currentPageNo":@(self.currentPage),@"pageSize":@(PULL_PAGE_SIZE)} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
        NSArray* array = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if (array.count == 0) {
            [self setInfinitScorllHidden:YES];
            return;
        }
        if (array.count < PULL_PAGE_SIZE) {
            [self setInfinitScorllHidden:YES];
        }
        else{
            [self setInfinitScorllHidden:NO];
        }
        [self.exhibitionArray addObjectsFromArray:array];
        NSMutableArray* indexPathArray = [NSMutableArray array];
        for (NSInteger index = self.exhibitionArray.count-array.count; index <self.exhibitionArray.count; index++) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
        self.currentPage--;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.tableView == tableView) {
        return self.exhibitionArray.count;
    }
    if (tableView.tag == 1) {
        return self.diquArray.count ;
    }
    if (tableView.tag == 2)
    {
        return self.timeArray.count;
    }
    
        return self.typeArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return 98;
    }
    else
    {
        return 44;
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
//        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, 44);
//        [button setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];
//        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        [button setTitle:@"种猪企业" forState:UIControlStateNormal];
//        [button setTitleColor:TextGrayColor forState:UIControlStateNormal];
//        [button setTitleColor:NavigationBarColor forState:UIControlStateSelected];
//        button.tag = 1;
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:button];
//        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4-1, 0, 1, 44)];
//        imageView.image = [UIImage imageNamed:@"segment_divider"];
//        [headerView addSubview:imageView];
        
        self.diquButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.diquButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 44);
        [self.diquButton setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];
        [self.diquButton setImage:[UIImage imageNamed:@"mall_main_menu_normal"] forState:UIControlStateNormal];
        [self.diquButton setImage:[UIImage imageNamed:@"mall_main_menu_selected"] forState:UIControlStateSelected];
        [self.diquButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if (changeButtonIndex == 1) {
            [self.diquButton setTitle:changeButtonString forState:UIControlStateNormal];
        }
        else
        {
            [self.diquButton setTitle:@"地区" forState:UIControlStateNormal];
        }
        
        [self.diquButton setTitleColor:TextGrayColor forState:UIControlStateNormal];
        [self.diquButton setTitleColor:NavigationBarColor forState:UIControlStateSelected];
        self.diquButton.tag = 1;
        [self.diquButton setSelected:showMenus == 1?YES:NO];
        [self.diquButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.diquButton];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, 1, 44)];
        imageView.image = [UIImage imageNamed:@"segment_divider"];
        [headerView addSubview:imageView];
        
        
        self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.timeButton.frame = CGRectMake(SCREEN_WIDTH/3+1, 0, SCREEN_WIDTH/3, 44);
        [self.timeButton setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];
        [self.timeButton setImage:[UIImage imageNamed:@"mall_main_menu_normal"] forState:UIControlStateNormal];
        [self.timeButton setImage:[UIImage imageNamed:@"mall_main_menu_selected"] forState:UIControlStateSelected];
        [self.timeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if (changeButtonIndex == 2) {
            [self.timeButton setTitle:changeButtonString forState:UIControlStateNormal];
        }
        else
        {
            [self.timeButton setTitle:@"时间" forState:UIControlStateNormal];
        }
        
        [self.timeButton setTitleColor:TextGrayColor forState:UIControlStateNormal];
        [self.timeButton setTitleColor:NavigationBarColor forState:UIControlStateSelected];
        [self.timeButton setSelected:showMenus == 2?YES:NO];
        self.timeButton.tag = 2;
        [self.timeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.timeButton];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2-1, 0, 1, 44)];
        imageView.image = [UIImage imageNamed:@"segment_divider"];
        [headerView addSubview:imageView];
        
        
        self.typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.typeButton.frame = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 44);
        [self.typeButton setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];
        [self.typeButton setImage:[UIImage imageNamed:@"mall_main_menu_normal"] forState:UIControlStateNormal];
        [self.typeButton setImage:[UIImage imageNamed:@"mall_main_menu_selected"] forState:UIControlStateSelected];
        [self.typeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.typeButton setTitle:@"种类" forState:UIControlStateNormal];
        [self.typeButton setTitleColor:TextGrayColor forState:UIControlStateNormal];
        [self.typeButton setTitleColor:NavigationBarColor forState:UIControlStateSelected];
        self.typeButton.tag = 3;
        [self.typeButton setSelected:showMenus == 3?YES:NO];
        [self.typeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.typeButton];
        self.tableView.scrollEnabled = YES;
        
        return headerView;
    }
    else{
        return  [[UIView alloc]init];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        ExhibitionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        NSDictionary* dic = self.exhibitionArray[indexPath.row];
        [cell loadData:dic];
        return cell;
    }
    else if (tableView.tag == 1)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row == 0)
        {
            cell.textLabel.text = self.diquArray[indexPath.row];
        }
        else{
            cell.textLabel.text = [self.diquArray[indexPath.row] objectForKey:@"val"];
        }
        
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
        if(indexPath.row == 0)
        {
            cell.textLabel.text = self.timeArray[indexPath.row];
        }
        else{
            cell.textLabel.text = [self.timeArray[indexPath.row] objectForKey:@"val"];
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
        if(indexPath.row == 0)
        {
            cell.textLabel.text = self.typeArray[indexPath.row];
        }
        else{
            cell.textLabel.text = [self.typeArray[indexPath.row] objectForKey:@"name"];
        }

        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        NSDictionary* dic = self.exhibitionArray[indexPath.row];
        ExhibitionDetailViewController* controller = [[ExhibitionDetailViewController alloc]initWithNibName:@"ExhibitionDetailViewController"bundle:nil];
        controller.info = dic;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (tableView.tag == 1)
    {
        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(indexPath.row == 0)
        {
            changeButtonIndex = 0;
            changeButtonString = @"";
        }
        else{
            changeButtonIndex = 1;
            changeButtonString = cell.textLabel.text;
        }
        [self hideMenu:^{
            showMenus = 0;
            [self startRefresh];
            self.diquButton.selected = NO;
        }];
    }
    else if (tableView.tag == 2)
    {
        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        if(indexPath.row == 0)
        {
            changeButtonIndex = 0;
            changeButtonString = @"";
        }
        else{
            changeButtonIndex = 2;
            changeButtonString = cell.textLabel.text;
        }
        [self hideMenu:^{
            showMenus = 0;
            [self startRefresh];
            self.diquButton.selected = NO;
        }];
    }
    else if (tableView.tag == 3)
    {
        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(indexPath.row == 0)
        {
            changeButtonIndex = 0;
            changeButtonString = @"";
        }
        else{
            changeButtonIndex = 3;
            changeButtonString = cell.textLabel.text;
            changeButttonVal = [[self.typeArray[indexPath.row] objectForKey:@"id"] integerValue];
        }
        [self hideMenu:^{
            showMenus = 0;
            [self startRefresh];
            self.diquButton.selected = NO;
        }];
    }
    
}


-(void)buttonClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 1:
        {
            
            [sender setSelected:sender.selected==YES?NO:YES];
            NSLog(@"%d",sender.selected);
            //            sender.selected = !sender.selected;
            if (sender.selected) {
                showMenus = 1;
                [self showMenuWithView:sender];
                self.timeButton.selected = NO;
                self.typeButton.selected = NO;
            }
            else
            {
                [self hideMenu:^{
                    showMenus = 0;
                    [self.tableView reloadData];
                }];
            }
            break;
        }
        
        case 2:
        {
            [sender setSelected:sender.selected==YES?NO:YES];
            //            sender.selected = !sender.selected;
            if (sender.selected) {
                showMenus = 2;
                [self showMenuWithView:sender];
                self.diquButton.selected = NO;
                self.typeButton.selected = NO;
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
        case 3:
        {
            [sender setSelected:sender.selected==YES?NO:YES];
            //            sender.selected = !sender.selected;
            if (sender.selected) {
                showMenus = 3;
                [self showMenuWithView:sender];
                self.diquButton.selected = NO;
                self.timeButton.selected = NO;
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
        self.topHideBtn = nil;
        self.bottomHideBtn = nil;
        self.mainTableView = nil;
    }
    CGRect orginRect = [viewbtn convertRect:viewbtn.frame toView:self.view];
    CGFloat topheight = orginRect.origin.y;
    CGFloat bottomY = orginRect.origin.y+orginRect.size.height;
    CGFloat bottomHeight = self.view.frame.size.height;
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
    
        self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, bottomY, SCREEN_WIDTH, 0.01) style:UITableViewStylePlain];
        self.mainTableView.tag = showMenus;
        self.mainTableView.delegate = self;
        self.mainTableView.dataSource = self;
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mainTableView];
        
        POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, bottomY, SCREEN_WIDTH, 150)];
        [self.mainTableView pop_addAnimation:animation forKey:@"animation"];
    
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
    else
    {
        self.topHideBtn = nil;
        self.bottomHideBtn = nil;
        self.mainTableView = nil;
        self.tableView.scrollEnabled = YES;
    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
