//
//  MyQuestionDetailTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import "MyQuestionDetailTableViewController.h"
#import "NetWorkClient.h"
#import "MyQuestionDetailTableViewCell.h"
@interface MyQuestionDetailTableViewController ()<MyQuestionDetailTableViewCellDelegate>
@property (strong,nonatomic)NSMutableArray* replyArray;
@property (assign,nonatomic)NSInteger currentPage;
@end

@implementation MyQuestionDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title = @"回复详情";
    [self addPullRefresh];
    [self addInfinitScorll];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyQuestionDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyQuestionDetailReplyCnt" bundle:nil] forCellReuseIdentifier:@"cell0"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startRefresh];
}

-(void)pullRfresh
{
    self.currentPage = 1;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"problemId":self.problem[@"id"],@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20"}];
    [[NetWorkClient shareInstance] postUrl:SERVICE_PROBLEMREPLY With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.replyArray = [[responseObj objectForKey:@"data"]objectForKey:@"list"];
        self.problem = [[responseObj objectForKey:@"data"]objectForKey:@"problem"];
        if (self.replyArray.count < 20) {
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
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"problemId":self.problem[@"id"],@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20"}];
    [[NetWorkClient shareInstance] postUrl:SERVICE_PROBLEMREPLY With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
        NSArray* array = [[responseObj objectForKey:@"data"]objectForKey:@"list"];
        if (array.count == 0) {
            [self setInfinitScorllHidden:YES];
            return ;
        }
        self.problem = [[responseObj objectForKey:@"data"]objectForKey:@"problem"];
        [self.replyArray addObjectsFromArray:array];
        if (array.count < 20) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        NSMutableArray* indexPathArray = [NSMutableArray array];
        for (NSInteger index = self.replyArray.count - array.count; index < self.replyArray.count; index++) {
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
    return self.replyArray.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 38;
    }
    else{
        NSDictionary* dic = self.replyArray[indexPath.row - 1];
        return [Utils getSizeOfString:dic[@"content"] WithSize:CGSizeMake(SCREEN_WIDTH-24, NSIntegerMax) AndSystemFontSize:14].height+76;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        UILabel* label= (UILabel*)[cell viewWithTag:1];
        label.text = [NSString stringWithFormat:@"共%@条回复",self.problem[@"replyCnt"]];
        return cell;
    }
    else{
        MyQuestionDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell loadCell:self.replyArray[indexPath.row - 1] AndIsSolve:[self.problem[@"isSolve"] integerValue]];
        cell.delegate = self;
        return cell;
    }
}

-(void)questionDetailCell:(MyQuestionDetailTableViewCell *)cell AcceptBtnClick:(UIButton *)btn
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary* dic = self.replyArray[indexPath.row - 1];
    [[NetWorkClient shareInstance]postUrl:SERVICE_PROBLEMREPLY With:@{@"action":@"accept",@"sessionid":[[UserManagerObject shareInstance] sessionid],@"problemRelpyId":dic[@"id"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self startRefresh];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
    }];
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
