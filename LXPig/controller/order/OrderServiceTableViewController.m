//
//  OrderServiceTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/8.
//
//

#import "OrderServiceTableViewController.h"
#import "NetWorkClient.h"
#import "OrderServiceTableViewCell.h"
@interface OrderServiceTableViewController ()
@property (strong,nonatomic)NSMutableArray* serviceArray;
@property (assign,nonatomic)NSInteger currentPage;
@end

@implementation OrderServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullRefresh];
    [self addInfinitScorll];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pullRfresh
{
    self.currentPage = 1;
    [[NetWorkClient shareInstance]postUrl:SERVICE_SERVICE With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"currentPageNo":@"1",@"pageSize":@"20",@"oderNum":[self.orderInfo objectForKey:@"orderNum"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.serviceArray = [responseObj objectForKey:@"data"];
        if (self.serviceArray.count < 20) {
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
    [[NetWorkClient shareInstance]postUrl:SERVICE_SERVICE With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        NSArray* array = [responseObj objectForKey:@"data"];
        if(array.count == 0)
        {
            [self setInfinitScorllHidden:YES];
            return ;
        }
        if (array.count < 20) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        [self.serviceArray addObjectsFromArray:array];
        NSMutableArray *indexPathArray = [NSMutableArray array];
        for (NSInteger index = self.serviceArray.count - array.count; index < self.serviceArray.count; index++) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        self.currentPage--;
        [self stopPull];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.serviceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.serviceArray.count == 0) {
//        return 90;
//    }
//    OrderServiceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[OrderServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    CGFloat height = [[self loadCell:cell WithData:self.serviceArray[indexPath.row]].contentView  systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height +1;
//    return height;
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return [self loadCell:cell WithData:self.serviceArray[indexPath.row]];
}

-(UITableViewCell*)loadCell:(OrderServiceTableViewCell*)cell WithData:(NSDictionary*)data
{
    cell.time.text = [data objectForKey:@"createTime"];
    cell.content.text = [data objectForKey:@"content"];
    cell.contentHeight.constant = [Utils getSizeOfString:[data objectForKey:@"content"] WithSize:CGSizeMake(SCREEN_WIDTH-24, 1) AndSystemFontSize:15].height;
    return cell;
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
