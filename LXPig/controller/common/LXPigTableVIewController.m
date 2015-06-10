//
//  LXPigTableVIewController.m
//  LXPig
//
//  Created by leexiang on 15/4/11.
//
//

#import "LXPigTableVIewController.h"
#import "NetWorkClient.h"
#import "SVPullToRefresh.h"
@interface LXPigTableVIewController ()
@property (nonatomic,strong)NSMutableArray* operationTimeSpArray;
@end

@implementation LXPigTableVIewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.operationTimeSpArray = [NSMutableArray array];
    if(IOS_SYSTEM_VERSION >= 7.f)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)addPullRefresh
{
    __weak LXPigTableVIewController* weakself = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakself pullRfresh];
    }];
}

-(void)addInfinitScorll
{
    __weak LXPigTableVIewController* weakself = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakself infinitScorll];
    }];
    [self setInfinitScorllHidden:YES];
}
-(void)pullRfresh
{
    
}

-(void)infinitScorll
{
    
}
-(void)startRefresh
{
    [self.tableView triggerPullToRefresh];
}
-(void)stopPull
{
    [[self.tableView pullToRefreshView] stopAnimating];
}

-(void)stopInfinitScorll
{
    [[self.tableView infiniteScrollingView] stopAnimating];
}

-(void)addBackButton
{
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 30, 44)];
    [backButton setImage:[UIImage imageNamed:BackButtomImageName] forState:UIControlStateNormal];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton addTarget:self action:@selector(popBackController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    [self.navigationItem setLeftItemsSupplementBackButton:YES];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = -10;
    [self.navigationItem setLeftBarButtonItems:@[flexSpacer,backItem]];
    
    
}

-(void)addCancelButton
{
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissController:)];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
}

-(IBAction)popBackController:(id)sender
{
    [self cancelAllOperation];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dismissController:(id)sender
{
    [self cancelAllOperation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelAllOperation
{
    for (NSString* timeSp in self.operationTimeSpArray) {
        [[NetWorkClient shareInstance]cancelWithTimeSp:timeSp];
    }
}

-(void)setPullViewHidden:(BOOL)hidden
{
    [self.tableView setShowsPullToRefresh:!hidden];
}
-(void)setInfinitScorllHidden:(BOOL)hidden
{
    [self.tableView setShowsInfiniteScrolling:!hidden];
}
-(BOOL)showInfinitScorll
{
    return [self.tableView showsInfiniteScrolling];
}


@end
