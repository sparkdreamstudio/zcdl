//
//  LoginTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/11.
//
//

#import "LoginTableViewController.h"
#import "AddressManager.h"
#import "PigCart.h"
#import "ForgetPasswordFirstViewController.h"
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
    self.userNameInput.tintColor = [UIColor whiteColor];
    self.userNameInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号即为会员号" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.userNameInput.textColor = [UIColor whiteColor];
    self.passwordInput.textColor = [UIColor whiteColor];
    self.passwordInput.tintColor = [UIColor whiteColor];
    self.passwordInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
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
    
    NSString* username = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"];
    NSString* password = [[NSUserDefaults standardUserDefaults]objectForKey:@"PASSWORD"];
    if (username != nil && password != nil) {
        self.userNameInput.text = username;
        self.passwordInput.text = password;
        [self showNormalHudDimissWithString:@"登录超时，请重新登陆"];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
        [[PigCart shareInstance] refreshCartListSuccess:nil failure:nil];
        [[AddressManager shareInstance]getAddressArraySuccess:nil failure:nil];
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
- (IBAction)userLogin:(id)sender {
    NSString* userName = self.userNameInput.text;
    NSString* password = self.passwordInput.text;
    
    if (![Utils validateMobile:userName]) {
        [self showErrorHudDimissWithString:@"错误手机号码"];
        return;
    }
    UIView* hud = [self showNormalHudNoDimissWithString:@"登录中"];
    [[UserManagerObject shareInstance]loginOtherWithName:userName AndPassWord:password success:^(NSDictionary *responseObj, NSString *timeSp) {
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
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_LOGIN_OK object:nil];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"show_forget_password"]) {
        ForgetPasswordFirstViewController* controller = [segue destinationViewController];
        controller.loginController = self;
    }
}


@end
