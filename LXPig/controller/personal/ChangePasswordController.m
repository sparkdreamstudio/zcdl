//
//  ChangePasswordController.m
//  LXPig
//
//  Created by leexiang on 15/4/29.
//
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()<JGProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *thtnewPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePassword:(id)sender {
    if (self.oldPassWord.text.length == 0) {
        [self showNormalHudDimissWithString:@"请输入您的旧密码"];
    }
    else if (self.thtnewPassword.text.length == 0)
    {
        [self showNormalHudDimissWithString:@"请输入您的新密码"];
    }
    else if (self.confirmPassword.text.length == 0)
    {
        [self showNormalHudDimissWithString:@"请输入您的确认密码"];
    }
    else if (![self.thtnewPassword.text isEqualToString:self.confirmPassword.text])
    {
        [self showNormalHudDimissWithString:@"请重新输入您确认新密码"];
    }
    else
    {
        UIView* hud = [self showNormalHudNoDimissWithString:@"提交新密码"];
        [[UserManagerObject shareInstance]changePassword:self.thtnewPassword.text OldPassWord:self.oldPassWord.text Success:^(NSDictionary *responseObj, NSString *timeSp) {
            hud.tag = 1;
            [self dismissHUD:hud WithSuccessString:@"修改密码成功"];
        } failure:^(NSDictionary *responseObj, NSString *timeSp) {
            if (responseObj) {
                [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
            }
            else
            {
                [self dismissHUD:hud WithErrorString:@"网络不给力哦"];
            }
        }];
    }
    
}

-(void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    switch (progressHUD.tag) {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
