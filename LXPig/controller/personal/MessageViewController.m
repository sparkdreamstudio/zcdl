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

@interface MessageViewController ()
@property (strong,nonatomic) NSMutableArray* messagesArray;
@property (assign,nonatomic) NSInteger currentPage;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    
    [self addPullRefresh];
    [self addInfinitScorll];
    [self startRefresh];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pullRfresh{
    _currentPage = 1;
    [[NetWorkClient shareInstance]postUrl:SERVICE_MESSAGE With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"pageSize":@"20",@"currentPageNo":[NSNumber numberWithInteger:_currentPage]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.messagesArray = [responseObj objectForKey:@"data"];
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
    _currentPage = 1;
    [[NetWorkClient shareInstance]postUrl:SERVICE_MESSAGE With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"pageSize":@"20",@"currentPageNo":[NSNumber numberWithInteger:_currentPage]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
        NSArray* array = [responseObj objectForKey:@"data"];
        [self.messagesArray addObjectsFromArray:array];
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
    return 62;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* message = self.messagesArray[indexPath.row];
    if ([[message objectForKey:@"isRead"] integerValue]==0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        UIView* unreadView = [cell.contentView viewWithTag:0];
        unreadView.layer.masksToBounds = YES;
        unreadView.layer.cornerRadius = 5;
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:1];
        label.text = [message objectForKey:@"createTime"];
        label = (UILabel*)[cell.contentView viewWithTag:2];
        label.text = [message objectForKey:@"content"];
        return cell;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:1];
        label.text = [message objectForKey:@"createTime"];
        label = (UILabel*)[cell.contentView viewWithTag:2];
        label.text = [message objectForKey:@"createTime"];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"message_detail" sender:self.messagesArray[indexPath.row]];
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
