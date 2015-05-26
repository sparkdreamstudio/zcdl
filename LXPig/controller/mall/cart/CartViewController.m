//
//  CartViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/27.
//
//

#import "CartViewController.h"
#import "PigCart.h"
#import "CartTableViewController.h"
#import "AddressManager.h"
@interface CartViewController ()
{
    BOOL editModel;
}
@property (weak,nonatomic) IBOutlet UIButton* checkAllButton;
@property (weak,nonatomic) IBOutlet UILabel*  allItemPrice;
@property (weak,nonatomic) IBOutlet UIButton* button;

@property (weak,nonatomic) CartTableViewController * tableController;

@property (strong, nonatomic) UIBarButtonItem* editButton;
@property (strong, nonatomic) UIBarButtonItem* doneButton;
@end

@implementation CartViewController

- (void)viewDidLoad {
    editModel = NO;
    [super viewDidLoad];
    [self addBackButton];
    self.editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editBtnClick:)];
    self.editButton.tag = 0;
    self.navigationItem.rightBarButtonItem = self.editButton;
    self.doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editBtnClick:)];
    self.doneButton.tag = 1;
    [self.checkAllButton addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak CartViewController* weakself = self;
    UIView* hud = [self showNormalHudNoDimissWithString:@"加载中"];
    [[PigCart shareInstance ]refreshCartListSuccess:^{
        [weakself dismissHUD:hud];
        [weakself loadTotalPrice];
    } failure:^(NSString *message) {
        [weakself dismissHUD:hud WithErrorString:@"加载失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkBtnClick:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.tableController checkAll];
    }
    else
    {
        [self.tableController unCheckAll];
    }
}

-(void)editBtnClick:(UIBarButtonItem*)sender
{
    if (sender.tag == 0) {
        self.navigationItem.rightBarButtonItem = self.doneButton;
        self.tableController.editModel = YES;
        self.button.tag = 1;
        [self.button setTitle:@"删除" forState:UIControlStateNormal];
        [self.tableController.tableView reloadData];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = self.editButton;
        self.tableController.editModel = NO;
        self.button.tag = 0;
        [self.button setTitle:@"结算" forState:UIControlStateNormal];
        [self.tableController.tableView reloadData];
 
    }
}

-(IBAction)buttonClick:(UIButton*)sender
{
    if(sender.tag == 0)
    {
        if ([[AddressManager shareInstance] addressArray].count == 0) {
            [self showNormalHudDimissWithString:@"请先完善收货地址"];
            return;
        }
        [self performSegueWithIdentifier:@"show_confirm_order" sender:nil];
    }
    else if (sender.tag == 1)
    {
        __weak CartViewController* weakself = self;
        UIView* hud = [self showNormalHudNoDimissWithString:@"删除中"];
        [[PigCart shareInstance] removeCartItemListSuccess:^{
            [[PigCart shareInstance ]refreshCartListSuccess:^{
                [weakself dismissHUD:hud WithSuccessString:@"完成"];
                [weakself loadTotalPrice];
            } failure:^(NSString *message) {
                [weakself dismissHUD:hud WithErrorString:@"加载失败"];
            }];
        } failure:^(NSString *message) {
            [weakself dismissHUD:hud WithErrorString:@"失败"];
        }];
    }
}

-(void)loadTotalPrice
{
    NSInteger total = 0;
    for (CartItems* items in [[PigCart shareInstance]itemsArray]) {
        for (CartItem *item in items.itemlist) {
            if (item.selected) {
                total += item.salePrice.integerValue*item.num.integerValue;
            }
        }
    }
    if(total == 0)
    {
        [self.button setEnabled:NO];
        [self.button setBackgroundColor:[UIColor lightGrayColor]];
    }
    else
    {
        [self.button setEnabled:YES];
        [self.button setBackgroundColor:NavigationBarColor];
    }
    self.allItemPrice.text =[NSString stringWithFormat:@"%ld",(long)total];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"cart_table"]) {
        self.tableController = [segue destinationViewController];
        self.tableController.editModel = editModel;
        self.tableController.cartViewController = self;
    }
}


@end
