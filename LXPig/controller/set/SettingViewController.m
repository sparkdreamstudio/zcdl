//
//  SettingViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/14.
//
//

#import "SettingViewController.h"
#import "NetWorkClient.h"
#import "SetListTableViewController.h"
#import "PSYCounterTableViewController.h"
#import "ExhibitionListTableViewController.h"
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
//    if (IOS_SYSTEM_VERSION < 8.0f) {
        self.topContraint.constant = 44;
//    }
    // Do any additional setup after loading the view.
//    if(IOS_SYSTEM_VERSION >= 8.f)
//    {
//        [self setEdgesForExtendedLayout:UIRectEdgeNone];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    }
//    else
//    {
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:44]];
//    }
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.title = @"工具";
    
    [self.tabBarController.navigationController.view setNeedsLayout];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)infoButtonClick:(UIButton*)btn
{
    SetListTableViewController *controller = [[SetListTableViewController alloc]init];
    controller.codeId = btn.tag;
    switch (btn.tag) {
        case 5:
        {
            controller.title =@"养猪宝典";
        }
            break;
        case 6:
        {
            controller.title =@"PSY应用研究学院";
        }
            break;
        case 7:
        {
            controller.title =@"种猪参考标准";
        }
            break;
        case 8:
        {
            controller.title =@"检测服务";
        }
            break;
            
        default:
            break;
    }
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
}

- (IBAction)psyCounterShow:(id)sender
{
    [self.tabBarController.navigationController pushViewController:[[PSYCounterTableViewController alloc]init] animated:YES];
}


- (IBAction)showZhanhui:(id)sender
{
    [self.navigationController pushViewController:[[ExhibitionListTableViewController alloc]init] animated:YES];
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
