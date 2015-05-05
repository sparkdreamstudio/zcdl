//
//  QAndAViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/6.
//
//

#import "QAndAViewController.h"

@interface QAndAViewController ()
@property (weak,nonatomic) IBOutlet UISegmentedControl* segmentControl;
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
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    self.tabBarController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    self.tabBarController.title = self.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
