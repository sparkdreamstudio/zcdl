//
//  OrderDetailViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/3.
//
//

#import "OrderDetailViewController.h"
#import "OrderDetailTableViewController.h"
#import "NetWorkClient.h"
#import "OrderCommentViewController.h"
#import "AddServiceViewController.h"
@interface OrderDetailViewController ()<JGProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIButton *canelOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn2;
@property (weak, nonatomic) IBOutlet UIButton *acceptOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *addServiceBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) OrderDetailTableViewController* controller;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    [self loadBottom];
    
}

-(void)loadBottom
{
    NSInteger userType = [[UserManagerObject shareInstance]userType];
    switch (userType) {
        case 0:
        {
            [self loadMemberBtn];
            break;
        }
        case 2:
        {
            [self loadServiceBtn];
            break;
        }
        case 3:
        {
            [self loadEnterpriseBtn];
            break;
        }
        default:
            break;
    }
}

-(void)loadMemberBtn
{
    NSInteger flag  = [self.orderInfo[@"flag"]integerValue];
    switch (flag) {
        case 1:
            self.canelOrderBtn.hidden = false;
            break;
        case 2:
            self.bottomViewHeight.constant = 0;
            break;
        case 3:
        case 4:
            self.commentOrderBtn.hidden = false;
            break;
        default:
            break;
    }
}

-(void)loadEnterpriseBtn
{
    NSInteger flag  = [self.orderInfo[@"flag"]integerValue];
    switch (flag) {
        case 1:
            self.cancelOrderBtn2.hidden = false;
            self.acceptOrderBtn.hidden = false;
            break;
        case 2:
            self.canelOrderBtn.hidden = false;
            break;
        default:
            break;
    }
}

-(void)loadServiceBtn
{
    NSInteger flag  = [self.orderInfo[@"flag"]integerValue];
    switch (flag) {
        case 3:
        case 4:
            self.addServiceBtn.hidden = false;
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelOrder1:(UIButton *)sender {
    UIView* hud = [self showNormalHudNoDimissWithString:@"取消订单中"];
    [[NetWorkClient shareInstance] postUrl:SERVICE_ORDER With:@{@"action":@"cancel",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"orderNum":[self.orderInfo objectForKey:@"orderNum"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        hud.tag = 1;
        [self dismissHUD:hud WithSuccessString:@"取消成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_REMOVE_ORDER object:nil userInfo:@{@"order":self.orderInfo}];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
    }];
}
- (IBAction)commentOrder:(UIButton *)sender {
    [self performSegueWithIdentifier:@"show_comment" sender:self.orderInfo];
}

-(IBAction)addService:(id)sender
{
    [self performSegueWithIdentifier:@"show_service" sender:self.orderInfo];
}

- (IBAction)cancelOrder2:(UIButton *)sender {
    UIView* hud = [self showNormalHudNoDimissWithString:@"取消订单中"];
    [[NetWorkClient shareInstance] postUrl:SERVICE_ORDER With:@{@"action":@"cancel",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"orderNum":[self.orderInfo objectForKey:@"orderNum"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_REMOVE_ORDER object:nil userInfo:@{@"order":self.orderInfo}];
        hud.tag = 1;
        [self dismissHUD:hud WithSuccessString:@"取消成功"];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
    }];
}
- (IBAction)acceptOrder:(UIButton *)sender {
    UIView* hud = [self showNormalHudNoDimissWithString:@"受理订单中"];
    [[NetWorkClient shareInstance] postUrl:SERVICE_ORDER With:@{@"action":@"accept",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"orderNum":[self.orderInfo objectForKey:@"orderNum"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_REMOVE_ORDER object:nil userInfo:@{@"order":self.orderInfo}];
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:self.orderInfo];
        [dic setValue:[NSNumber numberWithInteger:2] forKey:@"flag"];
        self.orderInfo = dic;
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_ADD_ORDER object:nil userInfo:@{@"order":self.orderInfo}];
        [self dismissHUD:hud WithSuccessString:@"受理成功"];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
    }];
}

#pragma mark - jghud delegate
-(void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    if (progressHUD.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"embed_order_table"]) {
        self.controller = [segue destinationViewController];
        self.controller.orderInfo = self.orderInfo;
        self.controller.controller = self;
    }
    else if ([segue.identifier isEqualToString:@"show_comment"])
    {
        OrderCommentViewController* controller = [segue destinationViewController];
        controller.orderInfo = sender;
    }
    else if ([segue.identifier isEqualToString:@"show_service"])
    {
        AddServiceViewController* controller = [segue destinationViewController];
        controller.orderInfo = self.orderInfo;
    }
}


@end
