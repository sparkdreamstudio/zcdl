//
//  ForgetPasswordFirstViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/17.
//
//

#import "ForgetPasswordFirstViewController.h"
#import "NetWorkClient.h"
#import "ForgetPasswordSecViewController.h"
#define TIME_COUNT 60
@interface ForgetPasswordFirstViewController ()
{
    NSUInteger time;
}
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberInput;
@property (weak, nonatomic) IBOutlet UITextField *confirmCodeInput;
@property (weak, nonatomic) IBOutlet UIButton *getConfirmCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
@property (strong, nonatomic) NSTimer* timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getConfirmCodeBtnWidth;
@end

@implementation ForgetPasswordFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    // Do any additional setup after loading the view.
    self.getConfirmCodeBtn.layer.masksToBounds = YES;
    self.getConfirmCodeBtn.layer.cornerRadius = 2;
    
    self.nextStep.layer.masksToBounds = YES;
    self.nextStep.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getConfirmCode:(id)sender
{
    [self.getConfirmCodeBtn setEnabled:NO];
    time = TIME_COUNT;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(confirmTimer) userInfo:nil repeats:YES];
    [self getVerifiedCode:self.mobileNumberInput.text];
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
-(void)getVerifiedCode:(NSString*)mobile
{
    [[NetWorkClient shareInstance]postUrl:SERVICE_SMS With:@{@"action":@"send",@"userName":mobile,@"type":@"2"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self showNormalHudDimissWithString:@"已向您发送验证码"];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self showNormalHudDimissWithString:@"获取验证码失败"];
        time=0;
    }];
}


-(IBAction)getNextStep:(id)sender
{
    if (self.mobileNumberInput.text.length != 11) {
        [self showNormalHudDimissWithString:@"请输入11位手机号码"];
        return;
    }
    else if (self.confirmCodeInput.text.length != 6)
    {
        [self showNormalHudDimissWithString:@"请输入6位验证码"];
        return;
    }
    UIView* hud = [self showNormalHudNoDimissWithString:@"验证中"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_MEMBER With:@{@"action":@"findPwdStep1",@"userName":self.mobileNumberInput.text,@"code":self.confirmCodeInput.text} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud];
        [self performSegueWithIdentifier:@"forget_password_change" sender:self.mobileNumberInput.text];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithSuccessString:[responseObj objectForKey:@"message"]];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"forget_password_change"]) {
        ForgetPasswordSecViewController* controller = [segue destinationViewController];
        controller.mobile = sender;
        controller.loginController = self.loginController;
    }
}


@end
