//
//  QAndAViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/6.
//
//

#import "QAndAViewController.h"
#import "NetWorkClient.h"
#import "QAndATableViewController.h"
#import "Q&ASearchViewController.h"
#import "PostQuestionViewController.h"
@interface QAndAViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic) IBOutlet UISegmentedControl* segmentControl;
@property (weak,nonatomic) QAndATableViewController* controller ;
@property (strong,nonatomic) NSArray* qAndAType;
@property (weak,nonatomic) IBOutlet UIButton* typeBtn;

@end

@implementation QAndAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"你问我答";
    self.segmentControl.selectedSegmentIndex = -1;
    [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [self.segmentControl setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControl setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControl setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self.segmentControl setTitleTextAttributes:@{
                                                  UITextAttributeTextColor: TextGrayColor,
                                                  UITextAttributeFont: [UIFont systemFontOfSize:15],
                                                  UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] }
                                       forState:UIControlStateNormal];
    [self.segmentControl setTitleTextAttributes:@{
                                                  UITextAttributeTextColor: NavigationBarColor,
                                                  UITextAttributeFont: [UIFont systemFontOfSize:15],
                                                  UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] }
                                       forState:UIControlStateSelected];
    if ([[UserManagerObject shareInstance]userType]==0) {
        UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"提问" style:UIBarButtonItemStylePlain target:self action:@selector(showPostQestion:)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    [[NetWorkClient shareInstance]postUrl:SERVICE_CODESERVICE With:@{@"action":@"listByParentId",@"parentId":@"4"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.qAndAType = [responseObj objectForKey:@"data"];
        self.controller.qAndAType = self.qAndAType;
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    self.tabBarController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    self.tabBarController.title = self.title;
}

-(IBAction)showSearchBar:(id)sender
{
    Q_ASearchViewController* controller = [[Q_ASearchViewController alloc]initWithNibName:@"Q&ASearchViewController" bundle:nil];
    controller.qAndAType = self.qAndAType;
    [self.tabBarController.navigationController pushViewController:controller animated:NO];
}

-(void)showPostQestion:(id)sender
{
    PostQuestionViewController* controller = [[PostQuestionViewController alloc]initWithNibName:@"PostQuestionViewController" bundle:nil];
    controller.qAndAType = self.qAndAType;
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
}

-(IBAction)showTypeTable
{
    self.typeBtn.enabled = NO;
    self.segmentControl.enabled =NO;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.segmentControl attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
}

-(IBAction)segmentedValueChanged:(UISegmentedControl*)segmented
{
    if (segmented.selectedSegmentIndex == 0) {
        self.controller.isSolve = @(1);
    }
    else
    {
        self.controller.isSolve = @(0);
    }
    [self.controller startRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.qAndAType.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"全部";
    }
    else
    {
        cell.textLabel.text = self.qAndAType[indexPath.row-1][@"name"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.controller.codeId = nil;
    }
    else{
        self.controller.codeId = self.qAndAType[indexPath.row-1][@"id"];
    }
    self.controller.isSolve = nil;
    self.typeBtn.enabled = YES;
    self.segmentControl.enabled =YES;
    self.segmentControl.selectedSegmentIndex = -1;
    [self.controller startRefresh];
    [tableView removeFromSuperview];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_qanda_table"]) {
        QAndATableViewController* controller = [segue destinationViewController];
        self.controller = controller;
    }
}


@end
