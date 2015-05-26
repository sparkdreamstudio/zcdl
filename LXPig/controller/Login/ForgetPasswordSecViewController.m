//
//  ForgetPasswordSecViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/17.
//
//

#import "ForgetPasswordSecViewController.h"
#import "NetWorkClient.h"
@interface ForgetPasswordSecViewController ()<JGProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton* doneButton;
@end

@implementation ForgetPasswordSecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackButton];
    self.doneButton.layer.masksToBounds = YES;
    self.doneButton.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changePassword:(id)sender
{
    if (self.password.text.length < 6) {
        [self showNormalHudDimissWithString:@"请输入6位及以上新密码"];
        return;
    }
    if (![self.password.text isEqualToString:self.confirmPassword.text]) {
        [self showNormalHudDimissWithString:@"请确认您的新密码"];
        return;
    }
    UIView* hud = [self showNormalHudNoDimissWithString:@"修改密码中"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_MEMBER With:@{@"action":@"findPwdStep2",@"userName":self.mobile,@"newPassword":self.password.text} success:^(NSDictionary *responseObj, NSString *timeSp) {
        hud.tag = 1;
        [self dismissHUD:hud WithSuccessString:@"修改成功"];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
    }];
}

-(void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    if (progressHUD.tag == 1) {
        [self.navigationController popToViewController:self.loginController animated:YES];
    }
}

@end
