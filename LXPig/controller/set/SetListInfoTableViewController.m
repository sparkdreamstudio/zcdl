//
//  SetListInfoTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/15.
//
//

#import "SetListInfoTableViewController.h"
#import "NetWorkClient.h"
#import "SetListInfoTableViewCell.h"
#import "AdWebViewController.h"
@interface SetListInfoTableViewController ()
@property (nonatomic,strong) NSMutableArray* listArray;
@property (assign,nonatomic) NSInteger currentPage;
@end

@implementation SetListInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    [self addPullRefresh];
    [self addInfinitScorll];
    [self.tableView registerNib:[UINib nibWithNibName:@"SetListInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetListInfoTableViewCell"];
    self.title = self.info[@"name"];
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
    [[NetWorkClient shareInstance]postUrl:SERVICE_TOOLHELP With:@{@"action":@"list",@"codeId":self.info[@"id"],@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"10"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.listArray = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if (self.listArray.count < 20) {
            [self setInfinitScorllHidden:YES];
        }
        else{
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
    [[NetWorkClient shareInstance]postUrl:SERVICE_WEBNEWS With:@{@"action":@"list",@"codeId":self.info[@"id"],@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"10"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
        NSArray* array = [responseObj objectForKey:@"data"];
        if (array.count == 0) {
            [self setInfinitScorllHidden:YES];
            return ;
        }
        if (array.count < 20) {
            [self setInfinitScorllHidden:YES];
        }
        else{
            [self setInfinitScorllHidden:NO];
        }
        [self.listArray addObjectsFromArray:array];
        NSMutableArray* indexPathArray = [NSMutableArray array];
        for (NSInteger index = self.listArray.count-array.count; index < self.listArray.count; index++) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        self.currentPage--;
        [self stopInfinitScorll];
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
    NSDictionary *dic = self.listArray[indexPath.row];
    return [Utils getSizeOfString:dic[@"overview"] WithSize:CGSizeMake(SCREEN_WIDTH-23, NSIntegerMax) AndSystemFontSize:13].height + 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetListInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetListInfoTableViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.listArray[indexPath.row];
    
    cell.title.text = dic[@"title"];
    cell.info.text = dic[@"overview"];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdWebViewController* controller = [[AdWebViewController alloc]initWithNibName:@"AdWebViewController" bundle:nil];
    controller.adInfo =  self.listArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
