//
//  ProductDetailViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/21.
//
//

#import "ProductDetailViewController.h"
#import "VOSegmentedControl.h"
#import "ProductDetailTableViewController.h"
#import "ProductInfo.h"
#import "EnterpriseDetailController.h"
#import "ProductRelatedController.h"
#import "ReturnVisitController.h"
#import "ProductCommentController.h"
#import "PigCart.h"
#import "ConfirmOrdViewController.h"
#import "AddressManager.h"
@interface ProductDetailViewController ()

@property (strong, nonatomic) UIImageView* bottomLine;

@property (weak,nonatomic) IBOutlet UISegmentedControl* segmentcontrol;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint* imageLeft;
@property (weak,nonatomic) IBOutlet UIScrollView      * scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *addTochart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *buyImmediatelyBtn;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title = @"详情";
    if ([[UserManagerObject shareInstance]userType] != 0 &&
        [[UserManagerObject shareInstance]userType] != -1) {
        self.bottomViewHeight.constant = 0;
        self.bottomView.hidden = YES;
    }
    if ([[UserManagerObject shareInstance]userType] != 0 && [[UserManagerObject shareInstance]userType] != -1) {
        self.navigationItem.rightBarButtonItem = nil;
    }

    [self.segmentcontrol setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentcontrol setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentcontrol setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [self.segmentcontrol setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentcontrol setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentcontrol setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    self.buyNowBtn.layer.masksToBounds = YES;
    self.buyNowBtn.layer.cornerRadius = 5;
    self.addTochart.layer.masksToBounds = YES;
    self.addTochart.layer.cornerRadius = 5;
    self.buyImmediatelyBtn.layer.masksToBounds = YES;
    self.buyImmediatelyBtn.layer.cornerRadius = 5;
    if (self.type == 1) {
        self.buyImmediatelyBtn.hidden = NO;
        self.addTochart.hidden = YES;
        self.buyNowBtn.hidden = YES;
    }
    else
    {
        self.buyImmediatelyBtn.hidden = YES;
        self.addTochart.hidden = NO;
        self.buyNowBtn.hidden = NO;
    }
    
    
    if (SCREEN_WIDTH == 320) {
        [self.segmentcontrol setTitleTextAttributes:@{
                                                      NSForegroundColorAttributeName: TextGrayColor,
                                                      NSFontAttributeName: [UIFont systemFontOfSize:12]
                                                      }
                                           forState:UIControlStateNormal];
        [self.segmentcontrol setTitleTextAttributes:@{
                                                      NSForegroundColorAttributeName: NavigationBarColor,
                                                      NSFontAttributeName: [UIFont systemFontOfSize:12]}
                                           forState:UIControlStateSelected];
    }
    else
    {
        [self.segmentcontrol setTitleTextAttributes:@{
                                                      NSForegroundColorAttributeName: TextGrayColor,
                                                      NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                           forState:UIControlStateNormal];
        [self.segmentcontrol setTitleTextAttributes:@{
                                                      NSForegroundColorAttributeName: NavigationBarColor,
                                                      NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                           forState:UIControlStateSelected];
    }
    
    [self.segmentcontrol setSelectedSegmentIndex:0];
    [self.segmentcontrol addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segmentValueChanged:(UISegmentedControl*)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    POPSpringAnimation* animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.fromValue = @(self.imageLeft.constant);
    animation.toValue = @(index*SCREEN_WIDTH/5);
    [self.imageLeft pop_addAnimation:animation forKey:@"animation"];
    [self.scrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0)];
    if ([[UserManagerObject shareInstance]userType] == 0&&[[UserManagerObject shareInstance]userType] != -1) {
        if (index == 0 || index == 3 || index == 4) {
            self.bottomViewHeight.constant = 65;
            self.bottomView.hidden = NO;
        }
        else
        {
            self.bottomViewHeight.constant = 0;
            self.bottomView.hidden = YES;
        }
    }
    
}

-(IBAction)buyNow:(id)sender
{
//    __weak ProductDetailViewController *weakself = self;
//    UIView* hud = [self showNormalHudNoDimissWithString:@"添加到购物车"];
//    [[PigCart shareInstance]addProductToChart:self.info.keyId Success:^{
//        [weakself dismissHUD:hud];
//        [weakself performSegueWithIdentifier:@"product_show_chart" sender:nil];
//    } failure:^(NSString *message) {
//        [weakself dismissHUD:hud WithErrorString:message];
//    }];
    if ([[UserManagerObject shareInstance]userType]==-1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SHOW_LOGIN object:nil];
    }
    else
    {
        ConfirmOrdViewController* controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmOrdViewController"];
        controller.qianGouProduct =self.info;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
}

-(IBAction)addToCart:(id)sender
{
    __weak ProductDetailViewController *weakself = self;
    UIView* hud = [self showNormalHudNoDimissWithString:@"添加到购物车"];
    [[PigCart shareInstance]addProductToChart:self.info.keyId Success:^{
        [weakself dismissHUD:hud WithSuccessString:@"添加成功"];
    } failure:^(NSString *message) {
        [weakself dismissHUD:hud WithErrorString:message];
    }];
}

-(IBAction)buyImmediatelyBtnClick:(id)sender
{
    if ([[UserManagerObject shareInstance]userType]==-1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SHOW_LOGIN object:nil];
    }
    else
    {
        ConfirmOrdViewController* controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmOrdViewController"];
        controller.qianGouProduct =self.info;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"product_detail_tag"]) {
        ProductDetailTableViewController* controller = [segue destinationViewController];
        controller.productId = self.info.keyId;
        controller.detailViewController = self;
    }
    else if ([segue.identifier isEqualToString:@"enterprise_detail_tag"]) {
        EnterpriseDetailController* controller = [segue destinationViewController];
        self.enterPriseController =controller;
        controller.info = self.info.enterprise;
    }
    else if ([segue.identifier isEqualToString:@"product_related"]) {
        ProductRelatedController* controller = [segue destinationViewController];
        controller.enterpriseId = self.info.enterprise.keyId;
    }
    else if ([segue.identifier isEqualToString:@"product_visit"]) {
        ReturnVisitController* controller = [segue destinationViewController];
        controller.productId = self.info.keyId;
    }
    else if ([segue.identifier isEqualToString:@"product_comment"]) {
        ProductCommentController* controller = [segue destinationViewController];
        controller.productId = self.info.keyId;
    }
}


@end
