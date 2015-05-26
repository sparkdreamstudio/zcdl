//
//  InfoListTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/11.
//
//

#import "InfoListTableViewController.h"
#import "InfoViewTableViewCell.h"
#import "NetWorkClient.h"
#import "InfoDetailViewController.h"
#import "InfoViewController.h"
@interface InfoListTableViewController ()
@property (strong,nonatomic) NSMutableArray* newsArray;
@property (assign,nonatomic) NSInteger currentPage;
@end

@implementation InfoListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPullRefresh];
    [self addInfinitScorll];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pullRfresh
{
    self.currentPage = 1;
    [[NetWorkClient shareInstance]postUrl:SERVICE_WEBNEWS With:@{@"action":@"list",@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20",@"codeId":self.val} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.newsArray = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if (self.newsArray.count < 20) {
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
    [[NetWorkClient shareInstance]postUrl:SERVICE_WEBNEWS With:@{@"action":@"list",@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20",@"codeId":self.val} success:^(NSDictionary *responseObj, NSString *timeSp) {
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
        [self.newsArray addObjectsFromArray:array];
        NSMutableArray* indexPathArray = [NSMutableArray array];
        for (NSInteger index = self.newsArray.count-array.count; index < self.newsArray.count; index++) {
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
    return self.newsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  87;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadCell:self.newsArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.newsArray[indexPath.row];
    InfoDetailViewController* controller = [[InfoDetailViewController alloc]initWithNibName:@"InfoDetailViewController" bundle:nil];
    controller.htmlString = dic[@"newstext"];
    [self.controller.navigationController pushViewController:controller animated:YES];
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
