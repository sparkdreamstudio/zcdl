//
//  Q&ASearchViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import "Q&ASearchViewController.h"
#import "NetWorkClient.h"
#import "QAndADetailViewController.h"
@interface Q_ASearchViewController ()<UISearchBarDelegate>
@property (strong,nonatomic) NSString* key;
@property (nonatomic,strong) NSMutableArray * problemArray;
@property (assign,nonatomic) NSInteger currentPage;
@end

@implementation Q_ASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    UISearchBar* searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    self.navigationItem.titleView = searchBar;
    searchBar.placeholder =@"请输入一个关键词";
    
    [self addInfinitScorll];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QAndQSearchUsefulCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QAndASearchCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.key = searchBar.text;
    self.currentPage = 1;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:@"10" forKey:@"pageSize"];
    [params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPageNo"];
    [params setValue:[[UserManagerObject shareInstance]sessionid] forKey:@"sessionid"];
    [params setValue:self.key forKey:@"keyword"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_PROBLEM With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.problemArray = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if (self.problemArray.count <10) {
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
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:@"10" forKey:@"pageSize"];
    [params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPageNo"];
    [params setValue:[[UserManagerObject shareInstance]sessionid] forKey:@"sessionid"];
    [params setValue:self.key forKey:@"keyword"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_PROBLEM With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
        NSMutableArray* array = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if(array.count == 0)
        {
            [self setInfinitScorllHidden:YES];
            return ;
        }
        if (array.count <10) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        [self.problemArray addObjectsFromArray:array];
        NSMutableArray* indexPathArray = [NSMutableArray array];
        for (NSInteger index = (self.problemArray.count - array.count); index < self.problemArray.count; index++) {
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.problemArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 153;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    NSDictionary* dic = self.problemArray[indexPath.row];
    NSInteger isSolve = [dic[@"isSolve"] integerValue];
    if (isSolve == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
    }
    UIView* view = [cell viewWithTag:5];
    view.layer.borderWidth = 1;
    view.layer.borderColor = HEXCOLOR(@"cdcdcd").CGColor;
    view.layer.masksToBounds = YES;
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%@提问",dic[@"members"][@"name"]];
    label = (UILabel*)[cell viewWithTag:2];
    label.text = dic[@"content"];
    label = (UILabel*)[cell viewWithTag:3];
    label.text = dic[@"createTime"];
    label = (UILabel*)[cell viewWithTag:4];
    label.text = [NSString stringWithFormat:@"有用 %@ | 回复 %@",dic[@"usefulCnt"],dic[@"replyCnt"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QAndADetailViewController* controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"problem_detail"];
    controller.qAndAType =self.qAndAType;
    controller.problem = self.problemArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
