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
@property (assign, nonatomic) BOOL personalLogin;
@property (weak,nonatomic) IBOutlet UIButton* signUpBtn;
@property (weak,nonatomic) IBOutlet UIButton* forgetPassword;
@property (weak,nonatomic) IBOutlet UIButton* enterpriseBtn;
@property (weak,nonatomic) IBOutlet UIButton* personalBtn;
@property (weak,nonatomic) IBOutlet UIView*   seperatorLine;
@property (weak,nonatomic) IBOutlet UIButton* iphone4PersonalSign;
@property (weak,nonatomic) IBOutlet UIButton* iphone4SignUp;
@property (weak,nonatomic) IBOutlet UIButton* iphone4ForgetBtn;
@property (weak,nonatomic) IBOutlet UIImageView* titleImageView;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint* titleTop;
@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 20, 44, 44);
    [button setImage:[UIImage imageNamed:BackButtomImageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.personalLogin = YES;
    self.userNameInput.tintColor = [UIColor whiteColor];
    self.userNameInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号即为会员号" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.userNameInput.textColor = [UIColor whiteColor];
    self.passwordInput.textColor = [UIColor whiteColor];
    self.passwordInput.tintColor = [UIColor whiteColor];
    self.passwordInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageView setImage:[UIImage imageNamed:@"login_bg.jpg"]];

    if (SCREEN_HEIGHT == 480) {
        self.titleImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        self.titleTop.constant = 50;
    }
    [self.tableView setBackgroundView:imageView];
    
    self.passwordBgView.layer.masksToBounds = YES;
    self.passwordBgView.layer.cornerRadius = 3;
    
    self.userBgView.layer.masksToBounds = YES;
    self.userBgView.layer.cornerRadius = 3;
    
    self.signInPersonal.layer.masksToBounds = YES;
    self.signInPersonal.layer.cornerRadius = 3;
    
    self.signInEnterprise.layer.masksToBounds = YES;
    self.signInEnterprise.layer.cornerRadius = 3;
    self.iphone4PersonalSign.layer.masksToBounds = YES;
    self.iphone4SignUp.layer.masksToBounds = YES;
    self.iphone4PersonalSign.layer.cornerRadius = 3;
    self.iphone4SignUp.layer.cornerRadius = 3;

    [self showPersonalBtn];
    
    NSString* username = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"];
    NSString* password = [[NSUserDefaults standardUserDefaults]objectForKey:@"PASSWORD"];
    if (username != nil && password != nil) {
        self.userNameInput.text = username;
        self.passwordInput.text = password;
        [self showNormalHudDimissWithString:@"登录超时，请重新登陆"];
    }
    
}

-(void)showPersonalBtn
{
    if (SCREEN_HEIGHT == 480) {
        self.signInEnterprise.hidden = YES;
        self.iphone4SignUp.hidden = NO;
        self.iphone4PersonalSign.hidden = NO;
        self.iphone4ForgetBtn.hidden = NO;
        self.forgetPassword.hidden = YES;
        self.signUpBtn.hidden = YES;
        self.seperatorLine.hidden = YES;
        [self.tableView reloadData];
    }
    else{
        self.signInEnterprise.hidden = NO;
        self.iphone4SignUp.hidden = YES;
        self.iphone4PersonalSign.hidden = YES;
        self.iphone4ForgetBtn.hidden = YES;
        self.forgetPassword.hidden = NO;
        self.signUpBtn.hidden = NO;
        self.seperatorLine.hidden = NO;
    }
}

-(void)hiddenPersonalBtn
{
//    self.signInEnterprise.hidden = YES;
    self.iphone4SignUp.hidden = YES;
    self.iphone4PersonalSign.hidden = YES;
    self.iphone4ForgetBtn.hidden = YES;
    self.forgetPassword.hidden = YES;
    self.signUpBtn.hidden = YES;
    self.seperatorLine.hidden = YES;
    if (SCREEN_HEIGHT == 480) {
        [self.tableView reloadData];
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

- (IBAction)login:(id)sender {
    NSString* userName = self.userNameInput.text;
    NSString* password = self.passwordInput.text;
    
    if (![Utils validateMobile:userName]) {
        [self showErrorHudDimissWithString:@"错误手机号码"];
        return;
    }
    if (self.passwordInput.text.length == 0) {
        [self showErrorHudDimissWithString:@"请输入密码"];
        return;
    }
    if (self.personalLogin) {
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
    else{
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
    
}

-(IBAction)changeLoginModel:(UIButton*)sender
{
    switch (sender.tag) {
        case 0:
            if (self.personalBtn.selected == NO) {
                self.personalBtn.selected = YES;
                self.enterpriseBtn.selected = NO;
                self.personalLogin = YES;
                self.signUpBtn.hidden = NO;
                self.forgetPassword.hidden = NO;
                self.seperatorLine.hidden = NO;
                [self showPersonalBtn];
            }
            
            break;
        case 1:
            if (self.enterpriseBtn.selected == NO) {
                self.enterpriseBtn.selected = YES;
                self.personalBtn.selected = NO;
                self.personalLogin = NO;
                self.signUpBtn.hidden = YES;
                self.signInEnterprise.hidden = NO;
                self.forgetPassword.hidden = YES;
                self.seperatorLine.hidden = YES;
                [self hiddenPersonalBtn];
            }
            
            break;
        default:
            break;
    }
}

-(void)dismissSelf:(UIButton*)btn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_DISMISS_LOGIN object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
        {
            return 0;
//            return self.view.bounds.size.height * (546.f/1334.f)-40;

        }
            
        case 1:
            return 1;
        case 2:
            return 23;
        case 3:
            if(SCREEN_HEIGHT == 480&&self.personalLogin)
            {
                return 0;
            }
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
            return 100 + self.view.bounds.size.height * (546.f/1334.f)-40;
        case 1:
            return 45;
        case 2:
            return 45;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                    if(SCREEN_HEIGHT == 480&&self.personalLogin)
                    {
                        return 76;
                    }
                    return 49;
                case 1:
                {
//                    CGFloat height = self.view.bounds.size.height;
//                    return height = (height - 90 - 49 - 50 - height*(546.f/1334.f))-40;
                    return 49;
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
