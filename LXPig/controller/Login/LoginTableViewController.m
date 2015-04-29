//
//  LoginTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/11.
//
//

#import "LoginTableViewController.h"
#define JG_LOGIN_SUCCESS_TAG 1


@interface LoginTableViewController ()<UITextFieldDelegate>

@end

@interface LoginTableViewController ()<JGProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *signInPersonal;
@property (weak, nonatomic) IBOutlet UIButton *signInEnterprise;

@property (weak, nonatomic) IBOutlet UIView *passwordBgView;

@property (weak, nonatomic) IBOutlet UIView *userBgView;
@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageView setImage:[UIImage imageNamed:@"login_bg.jpg"]];
    UIImageView* title = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-166)/2, 75, 166, 106)];
    [title setImage:[UIImage imageNamed:@"login_title"]];
    [imageView addSubview:title];
    [self.tableView setBackgroundView:imageView];
    
    self.passwordBgView.layer.masksToBounds = YES;
    self.passwordBgView.layer.cornerRadius = 3;
    
    self.userBgView.layer.masksToBounds = YES;
    self.userBgView.layer.cornerRadius = 3;
    
    self.signInPersonal.layer.masksToBounds = YES;
    self.signInPersonal.layer.cornerRadius = 3;
    
    self.signInEnterprise.layer.masksToBounds = YES;
    self.signInEnterprise.layer.cornerRadius = 3;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
//    UIGraphicsBeginImageContext(self.userBgView.bounds.size);
//    [self.userBgView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.userBgImageView.image = [image applyBlurWithRadius: 20
//                                           tintColor: nil
//                               saturationDeltaFactor: 1.5
//                                           maskImage: nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)memberLogin:(id)sender {
    NSString* userName = self.userNameInput.text;
    NSString* password = self.passwordInput.text;
    
    if (![Utils validateMobile:userName]) {
        [self showErrorHudDimissWithString:@"错误手机号码"];
        return;
    }
    UIView* hud = [self showNormalHudNoDimissWithString:@"登录中"];
    [[UserManagerObject shareInstance]loginWithName:userName AndPassWord:password success:^(NSDictionary *responseObj, NSString *timeSp) {
        hud.tag = JG_LOGIN_SUCCESS_TAG;
        [self dismissHUD:hud WithSuccessString:@"登陆成功"];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        NSString* message;
        if (responseObj) {
            message = [responseObj objectForKey:@"message"];
        }
        else
        {
            message = @"取消登录";
        }
        [self dismissHUD:hud WithErrorString:message];
    }];
}

#pragma mark jgpogress delegate
-(void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    if (progressHUD.tag == JG_LOGIN_SUCCESS_TAG) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

//#pragma mark - textfield delegate
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == self.passwordInput) {
//        if ((range.length + textField.text.length) >= 6) {
//            [self.signInPersonal setEnabled:YES];
//        }
//        else
//        {
//            [self.signInPersonal setEnabled:NO];
//        }
//    }
//    return YES;
//}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.view.bounds.size.height * (546.f/1334.f)-20;
        case 1:
            return 23;
        case 2:
            return 27;
        default:
            break;
    }
    return 0;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 45;
        case 1:
            return 45;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                    return 49;
                case 1:
                {
                    CGFloat height = self.view.bounds.size.height;
                    return height = (height - 90 - 49 - 50 - height*(546.f/1334.f))-20;
                }
                default:
                    break;
            }
        }
        default:
            break;
    }
    return 0;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
