//
//  ConfirmOrderTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "ConfirmOrderTableViewController.h"
#import "PigCart.h"
#import "ConfirmOrderHeadCell.h"
#import "ConfirmOrderBottomCell.h"
#import "ConfirmOrderCell.h"
#import "ConfirmOrderAddressCell.h"
#import "AddressManager.h"
#import "AddressViewController.h"
#import "ProductInfo.h"
#import "SelectAddressViewController.h"
#import "ConfirmOrderContainerViewController.h"
@implementation ConfirmOrderItem
-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
@end

@implementation ConfirmOrderItems

-(id)init
{
    self = [super init];
    if (self) {
        self.itemlist = [NSMutableArray array];
        self.totalPrice = 0;
        self.totalNumber = 0;
        self.note = @"";
    }
    return self;
}

@end

@interface ConfirmOrderTableViewController ()<ConfirmOrderBottomCellDelegate,ConfirmOrderCellDelegate>

@end

@implementation ConfirmOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setAddressNtf:) name:NTF_SETORDERADDRESS object:nil];
    self.arrayProduct = [NSMutableArray array];
    if([[[AddressManager shareInstance] addressArray] count] == 0)
    {
        self.address = nil;
    }
    else{
       self.address = [[AddressManager shareInstance] addressArray][0]; 
    }
    
    if (self.qianGouProduct) {
        ConfirmOrderItems* orderItems = [[ConfirmOrderItems alloc]init];
        ConfirmOrderItem* orderItem = [[ConfirmOrderItem alloc]init];
        orderItem.keyId = self.qianGouProduct.keyId;
        orderItem.marketPrice = @(self.qianGouProduct.marketPrice);
        orderItem.salePrice = @(self.qianGouProduct.salePrice);
        orderItem.productImage = self.qianGouProduct.smallImg;
        orderItem.num = @(1);
        orderItem.name  = self.qianGouProduct.name;
        orderItems.totalPrice = self.qianGouProduct.salePrice*1;
        orderItems.totalNumber = 1;
        orderItems.enterpriseKeyId = @(self.qianGouProduct.enterprise.keyId);
        orderItems.enterpriseName = self.qianGouProduct.enterprise.name;
        [orderItems.itemlist addObject:orderItem];
        [self.arrayProduct addObject:orderItems];
        
    }
    else
    {
        for (CartItems* items in [[PigCart shareInstance]itemsArray]) {
            ConfirmOrderItems* orderItems = [[ConfirmOrderItems alloc]init];
            for (CartItem *item in items.itemlist) {
                if (item.selected) {
                    ConfirmOrderItem* orderItem = [[ConfirmOrderItem alloc]init];
                    orderItem.keyId = item.keyId;
                    orderItem.marketPrice = item.marketPrice;
                    orderItem.salePrice = item.salePrice;
                    orderItem.productImage = item.productImage;
                    orderItem.num = item.num;
                    orderItem.name  = item.name;
                    orderItems.totalPrice += [item.salePrice integerValue]*[item.num integerValue];
                    orderItems.totalNumber += [item.num integerValue];
                    [orderItems.itemlist addObject:orderItem];
                }
            }
            if (orderItems.totalNumber > 0) {
                orderItems.enterpriseKeyId = items.enterpriseKeyId;
                orderItems.enterpriseName = items.enterpriseName;
                [self.arrayProduct addObject:orderItems];
            }
        }
    }
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setAddressNtf:(NSNotification*)ntf
{
    self.address = ntf.object;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setOrderAddress:(NSNotification*)ntf
{
    if ([ntf.name isEqualToString:NTF_SETORDERADDRESS]) {
        self.address = ntf.object;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)confirmOrderCell:(ConfirmOrderCell *)cell SetNum:(NSInteger)num
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    ConfirmOrderItem* item = [self.arrayProduct[indexPath.section-1] itemlist][indexPath.row-1];
    ConfirmOrderItems *items = self.arrayProduct[indexPath.section - 1];
    if (num >= 1 && num <= 9999) {
        item.num = @(num);
        items.totalNumber = num;
        items.totalPrice = num*item.salePrice.integerValue;
        [self.confirmOrdController reloadQiangGouPrice:item.num.integerValue*item.salePrice.integerValue];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

-(void)confirmOrderCellDecrease:(ConfirmOrderCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    ConfirmOrderItem* item = [self.arrayProduct[indexPath.section-1] itemlist][indexPath.row-1];
    ConfirmOrderItems *items = self.arrayProduct[indexPath.section - 1];
    if (item.num.integerValue == 1) {
        return;
    }
    item.num = [NSNumber numberWithInteger:item.num.integerValue-1];
    items.totalNumber = item.num.integerValue;
    items.totalPrice = item.num.integerValue*item.salePrice.integerValue;
    [self.confirmOrdController reloadQiangGouPrice:item.num.integerValue*item.salePrice.integerValue];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)confirmOrderCellIncrease:(ConfirmOrderCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    ConfirmOrderItem* item = [self.arrayProduct[indexPath.section-1] itemlist][indexPath.row-1];
    ConfirmOrderItems *items = self.arrayProduct[indexPath.section - 1];
    if (item.num.integerValue == 9999) {
        return;
    }
    item.num = [NSNumber numberWithInteger:item.num.integerValue+1];
    items.totalNumber = item.num.integerValue;
    items.totalPrice = item.num.integerValue*item.salePrice.integerValue;
    [self.confirmOrdController reloadQiangGouPrice:item.num.integerValue*item.salePrice.integerValue];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return [[self.arrayProduct[section-1]itemlist] count]+2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayProduct.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ConfirmOrderAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_address" forIndexPath:indexPath];
        [cell loadAddress:self.address];
        return cell;
    }
    else
    {
        NSInteger count = [self.arrayProduct[indexPath.section-1] itemlist].count;
        if (indexPath.row == 0) {
            ConfirmOrderHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_head" forIndexPath:indexPath];
            [cell loadItem:self.arrayProduct[indexPath.section-1]];
            return cell;
        }
        else if(indexPath.row == (count+1))
        {
            ConfirmOrderBottomCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellBottom" forIndexPath:indexPath];
            [cell loadItem:self.arrayProduct[indexPath.section - 1]];
            cell.delegate = self;
            return cell;
        }
        else
        {
            NSString *identifier = @"";
            if (self.qianGouProduct) {
                identifier = @"cell_item0";
            }
            else
            {
                identifier = @"cell_item";
            }
            ConfirmOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            [cell loadItem:[self.arrayProduct[indexPath.section-1] itemlist][indexPath.row-1]];
            cell.delegate = self;
            return cell;
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SelectAddressViewController* selectedAddressController = [[SelectAddressViewController alloc]initWithNibName:@"SelectAddressViewController" bundle:nil];
        [self.navigationController pushViewController:selectedAddressController animated:YES];
    }
}

-(void)ConfirmOrderBottomCell:(ConfirmOrderBottomCell *)cell isTest:(BOOL)test
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    ConfirmOrderItems* items = self.arrayProduct[indexPath.section-1];
    items.isTestService = test;
}


-(void)ConfirmOrderBottomCell:(ConfirmOrderBottomCell *)cell theString:(NSString *)string
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    ConfirmOrderItems* items = self.arrayProduct[indexPath.section-1];
    items.note = string;
}
-(void)ConfirmOrderBottomCell:(ConfirmOrderBottomCell *)cell shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    ConfirmOrderItems* items = self.arrayProduct[indexPath.section-1];
    NSMutableString* tempStr = [NSMutableString stringWithString:items.note];
    [tempStr replaceCharactersInRange:range withString:string];
    items.note = tempStr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 83;
    }
    else
    {
        NSInteger count = [self.arrayProduct[indexPath.section-1] itemlist].count;
        if(indexPath.row == 0)
        {
            return 50;
        }
        else if (indexPath.row == (count + 1))
        {
            return 91;
        }
        else
        {
            return 82;
        }
    }
    
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        
//    }
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"order_select_address"])
    {
        AddressViewController* controller = [segue destinationViewController];
        controller.model = 1;
    }
}


@end
