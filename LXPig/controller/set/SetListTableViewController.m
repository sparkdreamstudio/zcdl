//
//  SetListTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/15.
//
//

#import "SetListTableViewController.h"
#import "NetWorkClient.h"
#import "SetListTableViewCell.h"
#import "SetListInfoTableViewController.h"
@interface SetListTableViewController ()
@property (nonatomic,strong) NSMutableArray* listArray;
@property (assign,nonatomic) NSInteger currentPage;
@end

@implementation SetListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullRefresh];
    [self addBackButton];
    [self.tableView registerNib:[UINib nibWithNibName:@"SetListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetListTableViewCell"];
    self.title = @"选择类型";
    [self startRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pullRfresh
{
    self.currentPage = 1;
    [[NetWorkClient shareInstance]postUrl:SERVICE_CODESERVICE With:@{@"action":@"listByParentId",@"parentId":[NSNumber numberWithInteger:self.codeId]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.listArray = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        [self.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetListTableViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.listArray[indexPath.row];
    
    cell.title.text = dic[@"name"];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetListInfoTableViewController* controller = [[SetListInfoTableViewController alloc]init];
    controller.info = self.listArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
