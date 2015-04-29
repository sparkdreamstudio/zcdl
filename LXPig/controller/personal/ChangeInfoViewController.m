//
//  ChangeInfoViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/29.
//
//

#import "ChangeInfoViewController.h"

@interface ChangeInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
//@property (weak, nonatomic) IBOutlet UIView *bottomView;
//@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title = self.controllerTitle;
//    self.tableView.tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
//    self.doneButton.layer.masksToBounds = YES;
//    self.doneButton.layer.cornerRadius = 5;
    self.textField.placeholder = [[UserManagerObject shareInstance] valueForKey:self.property];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)send:(id)sender {
    if (self.textField.text.length == 0) {
        [self showNormalHudDimissWithString:@"不能输入空值"];
        return;
    }
    UIView* hud = [self showNormalHudNoDimissWithString:@"提交信息中"];
    [[UserManagerObject shareInstance]changeInfo:self.property Value:self.textField.text Success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud];
        [self.navigationController popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
