//
//  c.m
//  LXPig
//
//  Created by leexiang on 15/4/11.
//
//

#import "SignUpController.h"
#import "AddressManager.h"
#import "PigCart.h"
#define JG_LOGIN_SUCCESS_TAG 1
#define TIME_COUNT 60

@interface SignUpController ()<JGProgressHUDDelegate>
{
    NSUInteger time;
}
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberInput;
@property (weak, nonatomic) IBOutlet UITextField *confirmCodeInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *getConfirmCodeBtn;
@property (strong, nonatomic) NSTimer* timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getConfirmCodeBtnWidth;

@end

@implementation SignUpController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackButton];
    
    self.getConfirmCodeBtn.layer.masksToBounds = YES;
    self.getConfirmCodeBtn.layer.cornerRadius = 2;
}

- (IBAction)registerUser:(id)sender {
    NSString* mobile = self.mobileNumberInput.text;
    NSString* verifyCode = self.confirmCodeInput.text;
    NSString* password = self.passwordInput.text;

    if (![Utils validateMobile:mobile]) {
        [self showErrorHudDimissWithString:@"错误手机号码!"];
        return;
    }
    else if(![Utils validateVerifyCode:verifyCode])
    {
        [self showErrorHudDimissWithString:@"错误验证码!"];
        return;
    }
    UIView* hud = [self showNormalHudNoDimissWithString:@"正在注册"];
    [[UserManagerObject shareInstance]regWithName:mobile AndPassWord:password AndVerifyCode:verifyCode success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self dismissHUD:hud WithSuccessString:@"注册成功"];
        [[PigCart shareInstance] refreshCartListSuccess:nil failure:nil];
        [[AddressManager shareInstance]getAddressArraySuccess:nil failure:nil];
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

-(IBAction)getConfirmCode:(id)sender
{
    [self.getConfirmCodeBtn setEnabled:NO];
    time = TIME_COUNT;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(confirmTimer) userInfo:nil repeats:YES];
}

-(void)confirmTimer
{
    if (time ==0) {
        time = TIME_COUNT;
        [self.timer invalidate];
        [self.getConfirmCodeBtn setEnabled:YES];
        [self.getConfirmCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getConfirmCodeBtnWidth setConstant:60];
    }
    else
    {
        NSString *btnString =[NSString stringWithFormat:@"%ld秒后重新获取",(unsigned long)time];
        [self.getConfirmCodeBtn setTitle:btnString forState:UIControlStateNormal];
        [self.getConfirmCodeBtnWidth setConstant:[Utils getSizeOfString:btnString WithSize:CGSizeMake(SCREEN_WIDTH, 30) AndSystemFontSize:10].width+10];
        time--;
    }
}

#pragma mark jgpogress delegate
-(void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    if (progressHUD.tag == JG_LOGIN_SUCCESS_TAG) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
