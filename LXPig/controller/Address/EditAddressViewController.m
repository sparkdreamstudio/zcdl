//
//  EditAddressViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "EditAddressViewController.h"
#import "EditAddressTableViewController.h"

@interface EditAddressViewController ()<JGProgressHUDDelegate>

@property (weak,nonatomic)EditAddressTableViewController* controller;
@property (weak,nonatomic) IBOutlet UIButton* deleteAddressBtn;
@property (weak,nonatomic) IBOutlet UIButton* addAddressButton;
@property (weak,nonatomic) IBOutlet UIButton* saveAddressBtn;
@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.saveAddressBtn.layer.masksToBounds = YES;
    self.saveAddressBtn.layer.cornerRadius = 5;
    self.addAddressButton.layer.masksToBounds = YES;
    self.addAddressButton.layer.cornerRadius = 5;
    
    if (self.address) {
        self.addAddressButton.hidden = YES;
        self.title = @"编辑收货地址";
    }
    else
    {
        self.title = @"新增收货地址";
        self.saveAddressBtn.hidden = YES;
        self.deleteAddressBtn.hidden = YES;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.controller loadAddress];
}

-(IBAction)btnClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 0:
        {
            if (self.controller.temp.contact.length == 0) {
                [self showNormalHudDimissWithString:@"请输入联系人"];
                return;
            }
            if (self.controller.temp.tel.length != 11)
            {
                [self showNormalHudDimissWithString:@"请输入11位手机号码"];
                return;
            }
            if (self.controller.temp.province.length == 0) {
                [self showNormalHudDimissWithString:@"请选择省市区"];
                return;
            }
            if (self.controller.temp.address.length == 0) {
                [self showNormalHudDimissWithString:@"请输入详细地址"];
                return;
            }
            if (self.controller.temp.zipcode.length != 6) {
                [self showNormalHudDimissWithString:@"请输入6位邮政编码"];
                return;
            }
            
            UIView* hud = [self showNormalHudNoDimissWithString:@"提交信息"];
            [[AddressManager shareInstance]setAddressInfo:self.controller.temp Success:^(NSDictionary *responseObj, NSString *timeSp) {
                [self dismissHUD:hud WithSuccessString:[responseObj objectForKey:@"message"]];
            } failure:^(NSDictionary *responseObj, NSString *timeSp) {
                [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
            }];
            break;
        }
        case 1:
        {
            UIView* hud = [self showNormalHudNoDimissWithString:@"正在删除"];
            [[AddressManager shareInstance] deleteAddress:self.controller.address Success:^(NSDictionary *responseObj, NSString *timeSp) {
                hud.tag = 1;
                [self dismissHUD:hud WithSuccessString:[responseObj objectForKey:@"message"]];
            } failure:^(NSDictionary *responseObj, NSString *timeSp) {
                [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
            }];
            break;
        }
            
        default:
            break;
    }
}

-(void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    if (progressHUD.tag == 1 && view == self.view) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"edit_address_table"]) {
        self.controller = [segue destinationViewController];
        self.controller.address = self.address;
    }
}


@end
