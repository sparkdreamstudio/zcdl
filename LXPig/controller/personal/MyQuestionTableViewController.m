//
//  MyQuestionTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import "MyQuestionTableViewController.h"
#import "MyQuestionTableViewCell.h"
#import "NetWorkClient.h"
#import "MyQuestionDetailTableViewController.h"

@interface MyQuestionTableViewController ()
@property (nonatomic,strong) NSMutableArray * problemArray;
@property (strong,nonatomic) NSArray* qAndAType;
@property (assign,nonatomic) NSInteger currentPage;
@end

@implementation MyQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的问答";
    [self addBackButton];
    [self addPullRefresh];
    [self addInfinitScorll];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NetWorkClient shareInstance]postUrl:SERVICE_CODESERVICE With:@{@"action":@"listByParentId",@"parentId":@"4"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.qAndAType = [responseObj objectForKey:@"data"];
        [self startRefresh];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

-(void)pullRfresh
{
    self.currentPage = 1;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:@"10" forKey:@"pageSize"];
    [params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPageNo"];
    [params setValue:[[UserManagerObject shareInstance]sessionid] forKey:@"sessionid"];

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
    [[NetWorkClient shareInstance]postUrl:SERVICE_PROBLEM With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
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
        [self stopPull];
        self.currentPage--;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.problemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.problemArray[indexPath.row];
    return 130+[Utils getSizeOfString:dic[@"content"] WithSize:CGSizeMake(SCREEN_WIDTH-30, NSIntegerMax) AndSystemFontSize:13].height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dic = self.problemArray[indexPath.row];
    MyQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
    NSString* type = @"";
    for (NSDictionary* typeObject in self.qAndAType) {
        if([[dic objectForKey:@"code"] isKindOfClass:[NSDictionary class]])
        {
            if ([[[dic objectForKey:@"code"] objectForKey:@"id"]integerValue] == [[typeObject objectForKey:@"id"] integerValue]) {
                type = [typeObject objectForKey:@"name"];
                break;
            }
        }
        
    }
    cell.typeLabel.text = [NSString stringWithFormat:@" %@ ",type];
    [cell loadCell:dic];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyQuestionDetailTableViewController* controller = [[MyQuestionDetailTableViewController alloc]initWithStyle:UITableViewStylePlain];
    controller.problem = self.problemArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
