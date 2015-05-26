//
//  OrderDetailTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/3.
//
//

#import "OrderDetailTableViewController.h"
#import "NetWorkClient.h"
#import "BillTableViewCell.h"
#import "ViewPaperViewController.h"
@interface OrderDetailTableViewController ()<BillTableViewCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    BOOL showPager;
    BOOL showAddPager;
}
@property (strong,nonatomic) NSMutableArray* paperArray;
@end

@implementation OrderDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"BillTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"billCell"];
    NSInteger userType = [[UserManagerObject shareInstance]userType];
    NSInteger flag =  [[self.orderInfo objectForKey:@"flag"] integerValue];
    showPager =  ((userType == 0 && (flag == 2 || flag == 3 || flag == 4)) || (userType == 3 && flag == 2));
    showAddPager = (userType == 0 && flag == 2);
    
    
}

-(void)loadPaper
{
    [[NetWorkClient shareInstance]postUrl:SERVICE_PAPER With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"orderNum":[self.orderInfo objectForKey:@"orderNum"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        NSArray* array = [responseObj objectForKey:@"data"];
        if (array.count > 0) {
            self.paperArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4]  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else{
            self.paperArray = [NSMutableArray array];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4]  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (showPager) {
        [self loadPaper];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return showPager? 5:4;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 1;
        }
        case 1:
        {
            return 1;
        }
        case 2:
        {
            return 1;
        }
        case 3:
        {
            return [[self.orderInfo objectForKey:@"detailList"] count]+1;
        }
        case 4:
        {
            return 1;
        }
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return 50;
        }
        case 1:
        {
            return 72;
        }
        case 2:
        {
            return 83;
        }
        case 3:
        {
            if (indexPath.row == 0) {
                return 55;
            }
            else
            {
                return 84;
            }
        }
        case 4:
        {
            BillTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"billCell"];
            [cell loadCell:self.paperArray WithAddButton:showAddPager];
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        }
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
            UILabel* label = (UILabel*)[cell viewWithTag:1];
            NSInteger flag = [[self.orderInfo objectForKey:@"flag"] integerValue];
            switch (flag) {
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
            label = (UILabel*)[cell viewWithTag:2];
            label.text = [NSString stringWithFormat:@"￥%@",[self.orderInfo objectForKey:@"amount"]];
            return cell;
        }
        case 1:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            UILabel* label = (UILabel*)[cell viewWithTag:1];
            label.text = [self.orderInfo objectForKey:@"orderNum"];
            label = (UILabel*)[cell viewWithTag:2];
            label.text = [self.orderInfo objectForKey:@"createTime"];
            return cell;
        }
        case 2:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            
            UILabel* label = (UILabel*)[cell viewWithTag:1];
                label.text = [self.orderInfo objectForKey:@"contact"];
                label = (UILabel*)[cell viewWithTag:2];
                label.text = [self.orderInfo objectForKey:@"tel"];
                label = (UILabel*)[cell viewWithTag:3];
                label.text = [self.orderInfo objectForKey:@"address"];
            
            return cell;
        }
        case 3:
        {
            if (indexPath.row == 0) {
                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
                UILabel* label = (UILabel*)[cell viewWithTag:1];
                label.text = [[self.orderInfo objectForKey:@"enterprise"] objectForKey:@"name"];
                return cell;
            }
            else
            {
                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
                NSDictionary* dic = [self.orderInfo objectForKey:@"detailList"][indexPath.row-1];
                NSDictionary* product = [dic objectForKey:@"product"];
                UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[product objectForKey:@"smallImg"]] placeholderImage:nil];
                UILabel* label = (UILabel*)[cell viewWithTag:2];
                label.text = [product objectForKey:@"name"];
                label = (UILabel*)[cell viewWithTag:3];
                label.text = [[product objectForKey:@"salePrice"] stringValue];
                label = (UILabel*)[cell viewWithTag:4];
                label.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"num"]];
                return cell;
            }
        }
        case 4:
        {
            BillTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"billCell"];
            cell.delegate = self;
            [cell loadCell:self.paperArray WithAddButton:showAddPager];
            return cell;
        }
        default:
            return nil;
    }
}

-(void)billCellClick:(BillTableViewCell *)cell WithAddButton:(UIButton *)button
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"上传票据" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片库",@"相机", nil];
    sheet.tag = 2;
    [sheet showInView:self.view];
}

-(void)billCellClick:(BillTableViewCell *)cell WithBillButton:(UIButton *)button
{
    [self performSegueWithIdentifier:@"show_paper" sender:self.paperArray[button.tag]];
}

#pragma mark - action sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        switch (actionSheet.tag) {
            case 2:
            {
                
                UIImagePickerController* controller =[self showImagePickerByType:buttonIndex];
                controller.delegate = self;
                [self presentViewController:controller animated:YES completion:nil];
                
                break;
            }
            default:
                break;
        }
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData* data=UIImagePNGRepresentation(image);
    UIView* hud = [self.controller showNormalHudNoDimissWithString:@"上传票据"];
    [[NetWorkClient shareInstance] postUrl:SERVICE_PAPER With:@{@"action":@"save",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"orderNum":[self.orderInfo objectForKey:@"orderNum"]} AndFileName:@"imgFile" AndData:data success:^(NSDictionary *dic, NSString *timeSp) {
        [self.controller dismissHUD:hud WithSuccessString:@"上传成功"];
        [self loadPaper];
        NSLog(@"%@",[dic objectForKey:@"message"]);
    } failure:^(NSDictionary *dic, NSString *timeSp) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        [self.controller dismissHUD:hud WithSuccessString:[dic objectForKey:@"message"]];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_paper"]) {
        ViewPaperViewController* controller = [segue destinationViewController];
        controller.paperInfo = sender;
    }
}


@end
