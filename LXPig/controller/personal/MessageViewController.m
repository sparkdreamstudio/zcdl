//
//  MessageViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/2.
//
//

#import "MessageViewController.h"
#import "NetWorkClient.h"
#import "MessageDetailViewController.h"
#import "UserManagerObject.h"
#import "MessageTableViewCell.h"
#import "NetWorkClient.h"
@interface MessageViewController ()<MessageTableViewCellDelegate>
@property (strong,nonatomic) NSMutableArray* messagesArray;
@property (assign,nonatomic) NSInteger currentPage;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    
    [self addPullRefresh];
    [self addInfinitScorll];
    
    
    // Do any additional setup after loading the view.
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

-(void)pullRfresh{
    _currentPage = 1;
    [[NetWorkClient shareInstance]postUrl:SERVICE_MESSAGE With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"pageSize":@"20",@"currentPageNo":[NSNumber numberWithInteger:_currentPage]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.messagesArray = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if (self.messagesArray.count < 20) {
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
    _currentPage++;
    [[NetWorkClient shareInstance]postUrl:SERVICE_MESSAGE With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"pageSize":@"20",@"currentPageNo":[NSNumber numberWithInteger:_currentPage]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
        NSArray* array = [responseObj objectForKey:@"data"];
        [self.messagesArray addObjectsFromArray:[NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]]];
        if (array.count < 20) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        [self.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.messagesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* message = self.messagesArray[indexPath.row];
    return [Utils getSizeOfString:[message objectForKey:@"content"] WithSize:CGSizeMake(SCREEN_WIDTH-22, NSIntegerMax) AndSystemFontSize:13].height+46;
//    return 62;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* message = self.messagesArray[indexPath.row];
    if ([[message objectForKey:@"isRead"] integerValue]==0) {
        MessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        [cell loadData:message];
        cell.delegate = self;
        return cell;
    }
    else
    {
        MessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell loadData:message];
        cell.delegate = self;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"message_detail" sender:self.messagesArray[indexPath.row]];
}

-(void)messageTableViewCellDelete:(MessageTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary* message = self.messagesArray[indexPath.row];
    UIView* hud = [self showNormalHudNoDimissWithString:@"正在删除消息"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_MESSAGE With:@{@"action":@"delete",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"id":[message objectForKey:@"id"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self.messagesArray removeObject:message];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self setInfinitScorllHidden:[self showInfinitScorll]];
        [self dismissHUD:hud WithSuccessString:[responseObj objectForKey:@"message"]];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
    }];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"message_detail"]) {
        MessageDetailViewController* controller = [segue destinationViewController];
        controller.message = sender;
    }
}


@end
