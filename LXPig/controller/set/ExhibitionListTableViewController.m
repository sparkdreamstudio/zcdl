//
//  ExhibitionListTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import "ExhibitionListTableViewController.h"
#import "NetWorkClient.h"
#import "ExhibitionListTableViewCell.h"
#import "ExhibitionDetailViewController.h"
#define PULL_PAGE_SIZE 20
@interface ExhibitionListTableViewController ()
@property (strong,nonatomic) NSMutableArray* exhibitionArray;
@property (assign,nonatomic) NSInteger       currentPage;
@end

@implementation ExhibitionListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动报名";
    [self addBackButton];
    [self addPullRefresh];
    [self addInfinitScorll];
    [self startRefresh];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ExhibitionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pullRfresh
{
    self.currentPage = 1;
    [[NetWorkClient shareInstance]postUrl:SERVICE_EXHIBIT With:@{@"action":@"list",@"currentPageNo":@(self.currentPage),@"pageSize":@(PULL_PAGE_SIZE)} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.exhibitionArray = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if (self.exhibitionArray.count < PULL_PAGE_SIZE) {
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
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.exhibitionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExhibitionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary* dic = self.exhibitionArray[indexPath.row];
    [cell.exhibitionImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:@"info_null"]];
    cell.titleLabel.text = dic[@"title"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:dic[@"overview"]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [dic[@"overview"] length])];
    cell.subTitleLabel.attributedText = attributedString;
    
    cell.timeLabel.text = [[dic[@"createTime"] componentsSeparatedByString:@" "] objectAtIndex:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.exhibitionArray[indexPath.row];
    ExhibitionDetailViewController* controller = [[ExhibitionDetailViewController alloc]initWithNibName:@"ExhibitionDetailViewController"bundle:nil];
    controller.info = dic;
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
