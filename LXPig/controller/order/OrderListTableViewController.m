//
//  OrderListTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/2.
//
//

#import "OrderListTableViewController.h"
#import "NetWorkClient.h"
#import "UserManagerObject.h"
#import "OrderDetailViewController.h"
#import "LPLabel.h"
@interface OrderListTableViewController ()
@property (assign,nonatomic)NSInteger currentPage;
@property (strong,nonatomic)NSMutableArray * orderArray;
@end

@implementation OrderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self addPullRefresh];
    [self addInfinitScorll];
    
    if ([[UserManagerObject shareInstance]userType] == 0 && self.orderFlag == 1) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeOrder:) name:NTF_REMOVE_ORDER object:nil];
    }
    if ([[UserManagerObject shareInstance]userType] == 3 && (self.orderFlag == 1 || self.orderFlag == 2))
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeOrder:) name:NTF_REMOVE_ORDER object:nil];
    }
    if ([[UserManagerObject shareInstance]userType] == 3 &&  self.orderFlag == 2)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addOrder:) name:NTF_ADD_ORDER object:nil];
    }
    
    [self startRefresh];
 
}

-(void)dealloc
{
    if ([[UserManagerObject shareInstance]userType] == 0 && self.orderFlag == 1) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NTF_REMOVE_ORDER object:nil];
    }
    if ([[UserManagerObject shareInstance]userType] == 3 && (self.orderFlag == 1 || self.orderFlag == 2))
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NTF_REMOVE_ORDER object:nil];
    }
    if ([[UserManagerObject shareInstance]userType] == 3 &&  self.orderFlag == 2)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NTF_ADD_ORDER object:nil];
    }
}

-(void)removeOrder:(NSNotification*)ntf
{
    if ([self.orderArray indexOfObject:[ntf.userInfo objectForKey:@"order"]]!= NSNotFound) {
        NSInteger index = [self.orderArray indexOfObject:[ntf.userInfo objectForKey:@"order"]];
        [self.orderArray removeObjectAtIndex:index];
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

-(void)addOrder:(NSNotification*)ntf
{
    [self.orderArray insertObject:[ntf.userInfo objectForKey:@"order"] atIndex:0];
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pull & scroll 
-(void)pullRfresh
{
    self.currentPage = 1;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:[[UserManagerObject shareInstance]sessionid] forKey:@"sessionid"];
    [params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPageNo"];
    [params setValue:@"10" forKey:@"pageSize"];
    if (self.orderFlag != 0) {
        [params setValue:[NSNumber numberWithInteger:self.orderFlag] forKey:@"flag"];
    }
    
    [[NetWorkClient shareInstance]postUrl:SERVICE_ORDER With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.orderArray = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if (self.orderArray.count < 10) {
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
    [params setValue:[[UserManagerObject shareInstance]sessionid] forKey:@"sessionid"];
    [params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPageNo"];
    [params setValue:@"10" forKey:@"pageSize"];
    if (self.orderFlag != 0) {
        [params setValue:[NSNumber numberWithInteger:self.orderFlag] forKey:@"flag"];
    }
    
    [[NetWorkClient shareInstance]postUrl:SERVICE_ORDER With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
        NSArray* array = [responseObj objectForKey:@"data"];
        [self.orderArray addObjectsFromArray:array];
        if (array.count < 10) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        if (array.count != 0) {
            [self.tableView beginUpdates];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.orderArray.count-array.count,array.count)] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
        
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.orderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.orderArray[section] objectForKey:@"detailList"] count]+2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 45;
    }
    else if (indexPath.row == 1)
    {
        return 38;
    }
    else
    {
        return 84;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        UILabel* label = (UILabel*)[cell viewWithTag:1];
        label.text = [NSString stringWithFormat:@"订单：%@",[self.orderArray[indexPath.section] objectForKey:@"orderNum"]];
        label = (UILabel*)[cell viewWithTag:2];
        NSInteger flag = [[self.orderArray[indexPath.section] objectForKey:@"flag"] integerValue];
        switch (flag) {
            case 0:
            {
                label.text = @"已取消";
                break;
            }
            case 1:
            {
                label.text = @"待受理";
                break;
            }
            case 2:
            {
                label.text = @"已受理";
                break;
            }
            case 3:
            {
                label.text = @"已交易";
                break;
            }
            case 4:
            {
                label.text = @"已服务";
                break;
            }
            default:
                break;
        }
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        UILabel* label = (UILabel*)[cell viewWithTag:1];
        if ([[self.orderArray[indexPath.section] objectForKey:@"enterprise"] isKindOfClass:[NSDictionary class]]) {
            label.text = [[self.orderArray[indexPath.section] objectForKey:@"enterprise"] objectForKey:@"name"];
        }
        
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        NSDictionary* dic = [self.orderArray[indexPath.section] objectForKey:@"detailList"][indexPath.row-2];
        NSDictionary* product = [dic objectForKey:@"product"];
        UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[product objectForKey:@"smallImg"]] placeholderImage:nil];
        UILabel* label = (UILabel*)[cell viewWithTag:2];
        label.text = [product objectForKey:@"name"];
        label = (UILabel*)[cell viewWithTag:3];
        label.text = [[product objectForKey:@"salePrice"] stringValue];
        label = (UILabel*)[cell viewWithTag:4];
        label.text = [NSString stringWithFormat:@"数量：   %@",[dic objectForKey:@"num"]];
        LPLabel* lplabel = (LPLabel*)[cell viewWithTag:5];
        lplabel.text = [NSString stringWithFormat:@"￥%@",[product objectForKey:@"marketPrice"]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.orderArray[indexPath.section];
    [self performSegueWithIdentifier:@"show_order_detail" sender:dic];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_order_detail"]) {
        OrderDetailViewController* controller = [segue destinationViewController];
        controller.orderInfo = sender;
    }
}


@end
