//
//  EnListTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import "EnListTableViewController.h"
#import "EnListTableViewCell.h"
#import "NetWorkClient.h"
@interface EnListTableViewController ()<JGProgressHUDDelegate>
@property (weak,nonatomic)UITextField* nameText;
@property (weak,nonatomic)UITextField* phoneText;
@end

@implementation EnListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title = @"我要报名";
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    UIButton *enlistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [enlistBtn setTitle:@"报名" forState:UIControlStateNormal];
    enlistBtn.titleLabel.textColor = [UIColor whiteColor];
    enlistBtn.backgroundColor = NavigationBarColor;
    enlistBtn.layer.masksToBounds = YES;
    enlistBtn.layer.cornerRadius = 4;
    enlistBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [enlistBtn addTarget:self action:@selector(enlistClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:enlistBtn];
    [footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[enlistBtn]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(enlistBtn)]];
    [footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-66-[enlistBtn]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(enlistBtn)]];
    self.tableView.tableFooterView = footerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"EnListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EnListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"姓名";
        cell.infoTextField.keyboardType = UIKeyboardTypeDefault;
        self.nameText = cell.infoTextField;
    }
    else
    {
        cell.titleLabel.text = @"联系方式";
        cell.infoTextField.placeholder = @"请填写11位手机号码";
        cell.infoTextField.keyboardType = UIKeyboardTypePhonePad;
        self.phoneText = cell.infoTextField;
    }
    
    return cell;
}

-(void)enlistClick:(UIButton*)btn
{
    [self.tableView endEditing:YES];
    if (self.nameText.text.length == 0 ) {
        [self showNormalHudDimissWithString:@"姓名不能为空"];
        return;
    }
    if (self.phoneText.text.length != 11) {
        [self showNormalHudDimissWithString:@"请填写11位手机号码"];
        return;
    }
    UIView* hud = [self showNormalHudNoDimissWithString:@"提交报名信息"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_EXHIBIT With:@{@"action":@"signup",@"id":self.info[@"id"],@"name":self.nameText.text,@"tel":self.phoneText.text} success:^(NSDictionary *responseObj, NSString *timeSp) {
        hud.tag = 1;
        [self dismissHUD:hud WithSuccessString:[responseObj objectForKey:@"message"]];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
    }];
}

-(void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    if (progressHUD.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
