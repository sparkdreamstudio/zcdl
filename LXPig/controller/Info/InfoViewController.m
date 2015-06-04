//
//  InfoViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import "InfoViewController.h"
#import "NetWorkClient.h"
#import "InfoViewTypeCustomTableViewController.h"
#import "InfoListTableViewController.h"
#import "NetWorkClient.h"
#import "InfoDetailViewController.h"
@interface InfoViewController ()<UIScrollViewDelegate,ImagePlayerViewDelegate>
@property (strong,nonatomic)NSArray *newsView;
@property (strong,nonatomic)UIScrollView* topScrollView;
@property (strong,nonatomic)UIScrollView* newsScrollView;
@property (strong,nonatomic)UISegmentedControl* segmentedControll;
@property (strong,nonatomic)NSMutableArray* controllerArray;
@property (strong,nonatomic)NSMutableArray* infoArray;
@property (strong,nonatomic)NSLayoutConstraint* topScrollHeightConstraint;
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ImagePlayerView* playerView = [[ImagePlayerView alloc]init];
    playerView.translatesAutoresizingMaskIntoConstraints = NO;
    playerView.imagePlayerViewDelegate = self;
    [self.view addSubview:playerView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[playerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(playerView)]];
    if (IOS_SYSTEM_VERSION<8.0) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:44]];
    }
    else
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:SCREEN_WIDTH*0.36]];
    self.controllerArray = [NSMutableArray array];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.image = [[UIImage imageNamed:@"segment_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:imageView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:playerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:48]];
    
    
    self.topScrollView = [[UIScrollView alloc]init];
    [self.topScrollView setBackgroundColor:[UIColor clearColor]];
    self.topScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.topScrollView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topScrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topScrollView)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:playerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:48]];
    
    self.newsScrollView = [[UIScrollView alloc]init];
    self.newsScrollView.pagingEnabled = YES;
    self.newsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.newsScrollView.delegate = self;
    [self.view addSubview:self.newsScrollView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_newsScrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_newsScrollView)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.newsScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topScrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.newsScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self loadNews];
    
    [[NetWorkClient shareInstance]postUrl:SERVICE_WEBNEWS With:@{@"action":@"list",} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.infoArray = [responseObj objectForKey:@"data"];
        [playerView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {

    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"资讯";

    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_item_count"] style:UIBarButtonItemStylePlain target:self action:@selector(showCustomView:)];
    item.tintColor = [UIColor whiteColor];
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = item;
}

-(void)showCustomView:(id)sender
{
    InfoViewTypeCustomTableViewController* controller = [[InfoViewTypeCustomTableViewController alloc]initWithStyle:UITableViewStylePlain];
    controller.controller = self;
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectType:(UISegmentedControl*)segmented
{
    NSInteger index = self.segmentedControll.selectedSegmentIndex;
    [self.newsScrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0)];
    [self.controllerArray[index] startRefresh];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.segmentedControll.selectedSegmentIndex = index;
}

-(void)loadNews
{
    NSDictionary* params;
    if ([[UserManagerObject shareInstance]sessionid]&&[[UserManagerObject shareInstance]sessionid].length!=0) {
        params = @{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid]};
    }
    else
    {
        params = @{@"action":@"list"};
    }
    [[NetWorkClient shareInstance]postUrl:SERVICE_FOCUSNEWS With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.newsView = [responseObj objectForKey:@"data"];
        [self loadNewsView];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

-(void)loadNewsView
{
    if (self.segmentedControll != nil) {
        [self.segmentedControll removeFromSuperview];
    }
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dic in self.newsView) {
        [array addObject:dic[@"name"]];
    }
    
    self.segmentedControll = [[UISegmentedControl alloc]initWithItems:array];
    if (array.count > 0) {
        self.segmentedControll.selectedSegmentIndex = 0;
    }
    [self.segmentedControll addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControll setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControll setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentedControll setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControll setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControll setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControll setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentedControll setTitleTextAttributes:@{
                                                  NSForegroundColorAttributeName: TextGrayColor,
                                                  NSFontAttributeName: [UIFont systemFontOfSize:15] }
                                       forState:UIControlStateNormal];
    [self.segmentedControll setTitleTextAttributes:@{
                                                  NSForegroundColorAttributeName: NavigationBarColor,
                                                  NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                       forState:UIControlStateSelected];
    self.segmentedControll.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topScrollView addSubview:self.segmentedControll];
    [self.topScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_segmentedControll]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_segmentedControll)]];
    [self.topScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_segmentedControll]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_segmentedControll)]];
    [self.topScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.topScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];

    [self.topScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControll attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:array.count*75]];

    for (InfoListTableViewController* controller in self.controllerArray) {
        [controller.view removeFromSuperview];
    }
    [self.controllerArray removeAllObjects];
    
    NSMutableDictionary *containersDic = [NSMutableDictionary dictionary];
    for (NSDictionary* dic in self.newsView) {
        NSInteger index = [self.newsView indexOfObject:dic];
        InfoListTableViewController* controller = [[InfoListTableViewController alloc]init];
        controller.controller = self;
        controller.val = [dic objectForKey:@"val"];
        [self.controllerArray addObject:controller];
        [self.newsScrollView addSubview:controller.view];
        controller.view.translatesAutoresizingMaskIntoConstraints = NO;
        [containersDic setValue:controller.view forKey:[NSString stringWithFormat:@"view%ld",(long)index]];
        [self.newsScrollView addConstraint:[NSLayoutConstraint constraintWithItem:controller.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.newsScrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.newsScrollView addConstraint:[NSLayoutConstraint constraintWithItem:controller.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.newsScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [self.newsScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[controllerView]-0-|" options:0 metrics:nil views:@{@"controllerView":controller.view}]];
    }
    if(self.controllerArray.count>0)
    {
        NSString* formateString = @"H:|-(0)-[view0]";
        for (NSInteger index = 1; index < self.newsView.count; index++) {
            formateString = [formateString stringByAppendingString:[NSString stringWithFormat:@"-(0)-[view%ld]",(long)index]];
        }
        formateString = [formateString stringByAppendingString:@"-(0)-|"];
        [self.newsScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formateString options:0 metrics:nil views:containersDic]];
    }
    
//    for (InfoListTableViewController* controller in self.controllerArray) {
//        [controller startRefresh];
//    }
    if(self.controllerArray.count>0)
    {
        [self.controllerArray[0] startRefresh];
    }
}

-(NSInteger)numberOfItems
{
    return self.infoArray.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    NSDictionary* dic = [self.infoArray objectAtIndex:index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"titlepic"]] placeholderImage:nil];
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSDictionary* dic = self.infoArray[index];
    InfoDetailViewController* controller = [[InfoDetailViewController alloc]initWithNibName:@"InfoDetailViewController" bundle:nil];
    controller.htmlString = dic[@"newstext"];
    controller.dic = dic;
    [self.navigationController pushViewController:controller animated:YES];

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
