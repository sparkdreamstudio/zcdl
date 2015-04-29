//
//  CartTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/27.
//
//

#import "CartTableViewController.h"
#import "PigCart.h"
#import "CartTableViewCell.h"
#import "CartTableViewCellBottom.h"
#import "CartTableViewCellHead.h"
#import "CartViewController.h"

@interface CartTableViewController ()<PigCartDelegate,CartTableViewCellDelegate,CartTableViewCellHeadDelegate>



@end

@implementation CartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PigCart shareInstance] setDelegate:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pigCartRefresh:(PigCart *)cart
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return [[PigCart shareInstance]itemsArray].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger count =[[[[PigCart shareInstance] itemsArray]objectAtIndex:section] itemlist].count;
    return  count==0?0:(count+2);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count =[[[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section] itemlist].count;
    if (indexPath.row == 0) {
        return 50;
    }
    else if (indexPath.row == count+1)
    {
        return 40;
    }
    else
    {
        return 82;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count =[[[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section] itemlist].count;
    CartItems* items = [[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        CartTableViewCellHead* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.delegate = self;
        cell.name.text = items.enterpriseName;
        if(self.editModel)
        {
            cell.checkBtn.selected = items.selectedToDelete;
        }
        else
        {
            cell.checkBtn.selected = items.selected;
        }
        
        return cell;
    }
    else if (indexPath.row == count+1)
    {
        CartTableViewCellBottom* cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.totalPrice.text = [items.totalPrice stringValue];
        return cell;
    }
    else
    {
        CartItem* item = [[[[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section] itemlist] objectAtIndex:indexPath.row-1];
        CartTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        cell.delegate = self;
        if (self.editModel) {
            [cell loadData:item WithSelected:item.selectedToDelete];
        }
        else{
            [cell loadData:item WithSelected:item.selected];
        }
        
        return cell ;
    }
}

#pragma mark -cell delegate
-(void)cartTableViewCellDecrease:(CartTableViewCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    CartItem* item = [[[[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section] itemlist] objectAtIndex:indexPath.row-1];
    CartItems* items = [[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section];
    NSInteger count = [item.num integerValue];
    NSInteger price = [item.salePrice integerValue];
    NSInteger totoalPrice = [items.totalPrice integerValue];
    if (count > 1) {
        item.num = [NSNumber numberWithInteger:--count];
        items.totalPrice = [NSNumber numberWithInteger:totoalPrice-price];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:[[[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section] itemlist].count+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        [self.cartViewController loadTotalPrice];
    }
}

-(void)cartTableViewCellIncrease:(CartTableViewCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    CartItem* item = [[[[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section] itemlist] objectAtIndex:indexPath.row-1];
    CartItems* items = [[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section];
    NSInteger count = [item.num integerValue];
    NSInteger price = [item.salePrice integerValue];
    NSInteger totoalPrice = [items.totalPrice integerValue];
    
    item.num = [NSNumber numberWithInteger:++count];
    items.totalPrice = [NSNumber numberWithInteger:totoalPrice+price];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:[[[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section] itemlist].count+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    [self.cartViewController loadTotalPrice];
}

-(void)cartTableViewCell:(CartTableViewCell *)cell isCheck:(BOOL)check
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    CartItem* item = [[[[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section] itemlist] objectAtIndex:indexPath.row-1];
    if (self.editModel) {
        item.selectedToDelete = check;
    }
    else
    {
        item.selected = check;
    }
}

-(void)cartTableViewCellHead:(CartTableViewCellHead *)head isCheck:(BOOL)checked
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:head];
    CartItems* items = [[[PigCart shareInstance] itemsArray]objectAtIndex:indexPath.section];
    if (self.editModel) {
        items.selectedToDelete = checked;
        [items.itemlist enumerateObjectsUsingBlock:^(CartItem* obj, NSUInteger idx, BOOL *stop) {
            obj.selectedToDelete = checked;
        }];
    }
    else
    {
        items.selected = checked;
        [items.itemlist enumerateObjectsUsingBlock:^(CartItem* obj, NSUInteger idx, BOOL *stop) {
            obj.selected = checked;
        }];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
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
