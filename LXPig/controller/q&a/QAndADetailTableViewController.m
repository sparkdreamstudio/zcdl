//
//  QAndADetailTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import "QAndADetailTableViewController.h"
#import "QAndADetailViewController.h"
#import "NetWorkClient.h"
#import "QAndAProblemTableViewCell.h"
#import "QAndAReplyCntTableViewCell.h"
#import "QAndAReplyTableViewCell.h"
@interface QAndADetailTableViewController ()<QAndAProblemTableViewCellDelegate>
@property (strong,nonatomic)NSMutableArray* replyArray;
@property (assign,nonatomic)NSInteger currentPage;
@end

@implementation QAndADetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPullRefresh];
    [self addInfinitScorll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 2+self.replyArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [Utils getSizeOfString:self.problem[@"content"] WithSize:CGSizeMake(SCREEN_WIDTH-40, NSIntegerMax) AndSystemFontSize:14].height + 132;
    }
    else if (indexPath.row == 1)
    {
        return 38;
    }
    else
    {
        return [Utils getSizeOfString:self.replyArray[indexPath.row-2][@"content"] WithSize:CGSizeMake(SCREEN_WIDTH-24, NSIntegerMax) AndSystemFontSize:14].height+70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QAndAProblemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        NSString* type = @"";
        for (NSDictionary* typeObject in self.qAndAType) {
            if ([[[self.problem objectForKey:@"code"] objectForKey:@"id"]integerValue] == [[typeObject objectForKey:@"id"] integerValue]) {
                type = [typeObject objectForKey:@"name"];
                break;
            }
        }
        cell.delegate = self;
        cell.typeLabel.text = [NSString stringWithFormat:@" %@ ",type];
        [cell loadCell:self.problem];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        QAndAReplyCntTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell loadCell:self.problem];
        return cell;
    }
    else
    {
        QAndAReplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell loadCell:self.replyArray[indexPath.row-2]];
        return cell;
    }
}

-(void)QAndAProblemTableViewCellUserClick:(QAndAProblemTableViewCell *)cell
{
    if ([[UserManagerObject shareInstance]userType] == 0) {
        UIView* hud = [self.controller showNormalHudNoDimissWithString:nil];
        [[NetWorkClient shareInstance] postUrl:SERVICE_PROBLEM With:@{@"action":@"clickuseful",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"problemId":self.problem[@"id"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
            [self.controller dismissHUD:hud];
            [self startRefresh];
        } failure:^(NSDictionary *responseObj, NSString *timeSp) {
            [self.controller dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
        }];
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
