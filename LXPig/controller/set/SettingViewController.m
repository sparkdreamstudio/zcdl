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
    // Do any additional setup after loading the view.
    if(IOS_SYSTEM_VERSION >= 7.f)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.title = @"工具";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)infoButtonClick:(UIButton*)btn
{
    SetListTableViewController *controller = [[SetListTableViewController alloc]init];
    controller.codeId = btn.tag;
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
