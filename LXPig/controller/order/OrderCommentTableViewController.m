//
//  OrderCommentTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/7.
//
//

#import "OrderCommentTableViewController.h"
#import "OrderCommentTableViewCell.h"
#import "NetWorkClient.h"
#import "OrderCommentViewController.h"
@interface OrderCommentTableViewController ()<OrderCommentTableViewCellDelegate,UIActionSheetDelegate,JGProgressHUDDelegate,UITextViewDelegate>
@property (strong,nonatomic)NSMutableArray *commentArray;
@property (strong,nonatomic)NSArray* labelArray;
@property (strong,nonatomic) IBOutlet UIButton* button;
@end

@implementation OrderCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 4;
    [self initCommentObjects];
    [[NetWorkClient shareInstance]postUrl:SERVICE_CODESERVICE With:@{@"action":@"listByParentId",@"parentId":@"2"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.labelArray = [responseObj objectForKey:@"data"];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];

}


-(void)initCommentObjects
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentArray = [NSMutableArray array];
    for (NSDictionary* detial in self.orderInfo[@"detailList"]) {
        CommentObject* object = [[CommentObject alloc]init];
        object.keyId = [[[detial objectForKey:@"product"]objectForKey:@"id"]longLongValue];
        object.name = [[detial objectForKey:@"product"]objectForKey:@"name"];
        object.salePrice = [[detial objectForKey:@"product"]objectForKey:@"salePrice"];
        object.smallImg = [[detial objectForKey:@"product"]objectForKey:@"smallImg"];
        object.saleCnt = [detial objectForKey:@"num"];
        [self.commentArray addObject:object];
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - cell delegate

-(void)orderCommentCell:(OrderCommentTableViewCell *)cell WithRatingTag:(NSInteger)tag AndRating:(CGFloat)rating
{
    [self.tableView endEditing:YES];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    CommentObject* object = [self.commentArray objectAtIndex:indexPath.row];
    switch (tag) {
        case 0:
            object.priceStar = rating;
            break;
        case 1:
            object.ruttingStar = rating;
            break;
        case 2:
            object.serviceStar = rating;
            break;
        default:
            break;
    }
}
-(void)orderCommentCell:(OrderCommentTableViewCell *)cell WithContent:(NSString *)content
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    CommentObject* object = [self.commentArray objectAtIndex:indexPath.row];
    object.content = content;
}

-(void)orderCommentCell:(OrderCommentTableViewCell *)cell WithTagButtonClick:(UIButton *)button
{
    [self.tableView endEditing:YES];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"选择标签" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    [self.labelArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        [sheet addButtonWithTitle:[obj objectForKey:@"name"]];
    }];
    sheet.tag = indexPath.row;
    [sheet showInView:self.controller.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        CommentObject* object = self.commentArray[actionSheet.tag];
        if(object.label.length == 0)
        {
            object.label = [self.labelArray[buttonIndex-1] objectForKey:@"name"];
        }
        else
        {
            object.label = [object.label stringByAppendingFormat:@",%@",[self.labelArray[buttonIndex-1] objectForKey:@"name"]];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:actionSheet.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.commentArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 440;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell loadData:[self.commentArray objectAtIndex:indexPath.row]];
    cell.comment.delegate = self;
    return cell;
}

#pragma mark - commit comment
-(IBAction)commitComment:(id)sender
{
    for (CommentObject* object in self.commentArray) {
        if (object.priceStar == 0) {
            [self.controller showNormalHudDimissWithString:[NSString stringWithFormat:@"请对%@的商品价格进行评价",object.name]];
            return;
        }
        if (object.ruttingStar == 0) {
            [self.controller showNormalHudDimissWithString:[NSString stringWithFormat:@"请对%@的发情率进行评价",object.name]];
            return;
        }
        if (object.serviceStar == 0) {
            [self.controller showNormalHudDimissWithString:[NSString stringWithFormat:@"请对%@的售后服务进行评价",object.name]];
            return;
        }
//        if (object.content.length == 0 || object.content == nil) {
//            [self.controller showNormalHudDimissWithString:[NSString stringWithFormat:@"请填写对%@的评论",object.name]];
//            return;
//        }
        if (object.label.length == 0 || object.label == nil) {
            [self.controller showNormalHudDimissWithString:[NSString stringWithFormat:@"请选择对%@的快速评论",object.name]];
            return;
        }
        
    }
    UIView* hud = [self.controller showNormalHudNoDimissWithString:@"提交评论"];
    [[NetWorkClient shareInstance] postUrl:SERVICE_COMMENT With:@{@"action":@"save",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"data":[self getCommentJson]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        hud.tag = 1;
        [self.controller dismissHUD:hud WithSuccessString:@"评论成功"];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self.controller dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
    }];
}

-(NSString*)getCommentJson
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    NSMutableArray* array = [NSMutableArray array];
    [self.commentArray enumerateObjectsUsingBlock:^(CommentObject* obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary* commentDic = [NSMutableDictionary dictionary];
        [commentDic setValue:[NSNumber numberWithLongLong:obj.keyId] forKey:@"productId"];
        [commentDic setValue:[NSNumber numberWithInteger:obj.serviceStar] forKey:@"serviceStar"];
        [commentDic setValue:[NSNumber numberWithInteger:obj.ruttingStar] forKey:@"ruttingStar"];
        [commentDic setValue:[NSNumber numberWithInteger:obj.priceStar] forKey:@"priceStar"];
        [commentDic setValue:obj.content forKey:@"content"];
        [commentDic setValue:obj.label forKey:@"label"];
        [array addObject:commentDic];
    }];
    [dic setValue:array forKey:@"list"];
    NSData* data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSMutableString *str =  [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.tableView reloadData];
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
