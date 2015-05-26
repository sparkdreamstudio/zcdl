//
//  OrderViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/2.
//
//

#import "OrderViewController.h"
#import "UserManagerObject.h"
#import "OrderListTableViewController.h"
@interface OrderViewController ()
{
    CGFloat flagCount;
}
@property (strong,nonatomic) UISegmentedControl* segmentcontrol;
@property (strong,nonatomic) NSMutableArray* controllerArray;
@property (strong,nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong,nonatomic) NSLayoutConstraint* bottomImageLeft;
@property (weak,nonatomic) IBOutlet UIView* parentView;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    switch ([[UserManagerObject shareInstance] userType]) {
        case 0:
        {
            self.segmentcontrol = [[UISegmentedControl alloc]initWithItems:@[@"全部",@"待受理",@"已受理",@"已交易",@"已服务"]];
            self.segmentcontrol.translatesAutoresizingMaskIntoConstraints = NO;
            [self.segmentcontrol addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            flagCount = 5;
            break;
        }
        case 2:
        {
            flagCount = 2;
            self.segmentcontrol = [[UISegmentedControl alloc]initWithItems:@[@"已交易",@"已服务"]];
            self.segmentcontrol.translatesAutoresizingMaskIntoConstraints = NO;
            [self.segmentcontrol addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
            [self.scrollView setContentOffset:CGPointMake(3*SCREEN_WIDTH, 0)];
            break;
        }
        case 3:
        {
            flagCount = 2;
            self.segmentcontrol = [[UISegmentedControl alloc]initWithItems:@[@"待受理",@"已受理"]];
            self.segmentcontrol.translatesAutoresizingMaskIntoConstraints = NO;
             [self.segmentcontrol addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
            break;
        }
            
        default:
            return;
            break;
    }
    [self.parentView addSubview:self.segmentcontrol];
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentcontrol attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentcontrol attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:49]];
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentcontrol attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    UIImageView* imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mall_segment_bottom"]];
    imageview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.parentView addSubview:imageview];
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:2]];
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.segmentcontrol attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    self.bottomImageLeft = [NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self.parentView addConstraint:self.bottomImageLeft];
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:SCREEN_WIDTH/flagCount]];
    
    
    [self.segmentcontrol setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentcontrol setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentcontrol setBackgroundImage:[UIImage imageNamed:@"segment_bg"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [self.segmentcontrol setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentcontrol setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentcontrol setDividerImage:[UIImage imageNamed:@"segment_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    if (SCREEN_WIDTH == 320) {
        [self.segmentcontrol setTitleTextAttributes:@{
                                                      UITextAttributeTextColor: TextGrayColor,
                                                      UITextAttributeFont: [UIFont systemFontOfSize:12],
                                                      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] }
                                           forState:UIControlStateNormal];
        [self.segmentcontrol setTitleTextAttributes:@{
                                                      UITextAttributeTextColor: NavigationBarColor,
                                                      UITextAttributeFont: [UIFont systemFontOfSize:12],
                                                      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] }
                                           forState:UIControlStateSelected];
    }
    else
    {
        [self.segmentcontrol setTitleTextAttributes:@{
                                                      UITextAttributeTextColor: TextGrayColor,
                                                      UITextAttributeFont: [UIFont systemFontOfSize:15],
                                                      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] }
                                           forState:UIControlStateNormal];
        [self.segmentcontrol setTitleTextAttributes:@{
                                                      UITextAttributeTextColor: NavigationBarColor,
                                                      UITextAttributeFont: [UIFont systemFontOfSize:15],
                                                      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] }
                                           forState:UIControlStateSelected];
    }
//    [self.scrollView needsUpdateConstraints];
//    for (OrderListTableViewController* controller  in self.controllerArray) {
//        [controller startRefresh];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)makeContraint:(NSArray*)array
{
    NSString* horiLayoutString = @"H:|-0-";
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for (NSDictionary* d in array) {
        horiLayoutString = [horiLayoutString stringByAppendingString:[NSString stringWithFormat:@"[%@]-0-",d.allKeys[0]]];
        [dic setObject:[d objectForKey:d.allKeys[0]] forKey:d.allKeys[0]];
    }
    horiLayoutString = [horiLayoutString stringByAppendingString:@"|"];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horiLayoutString options:0 metrics:nil views:dic]];
    for (UIView* view in dic.allValues) {
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
//        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
}
-(void)segmentValueChanged:(UISegmentedControl*)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    POPSpringAnimation* animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.fromValue = @(self.bottomImageLeft.constant);
    animation.toValue = @(index*SCREEN_WIDTH/flagCount);
    [self.bottomImageLeft pop_addAnimation:animation forKey:@"animation"];
    switch ([[UserManagerObject shareInstance]userType]) {
        case 2:
            index +=3;
            break;
        case 3:
            index +=1;
            break;
        default:
            break;
    }
    [self.scrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0)];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (self.controllerArray == nil) {
        self.controllerArray = [NSMutableArray array];
    }
    if ([segue.identifier isEqualToString:@"showorder_list1"]) {
        OrderListTableViewController* controller = [segue destinationViewController];
        controller.orderFlag = 0;
        if ([[UserManagerObject shareInstance]userType]==0) {
            [self.controllerArray addObject:controller];
        }
    }
    else if ([segue.identifier isEqualToString:@"showorder_list2"]) {
        OrderListTableViewController* controller = [segue destinationViewController];
        controller.orderFlag = 1;
        if ([[UserManagerObject shareInstance]userType]!=2) {
            [self.controllerArray addObject:controller];
        }
    }
    else if ([segue.identifier isEqualToString:@"showorder_list3"]) {
        OrderListTableViewController* controller = [segue destinationViewController];
        controller.orderFlag = 2;
        if ([[UserManagerObject shareInstance]userType]!=2) {
            [self.controllerArray addObject:controller];
        }
    }
    else if ([segue.identifier isEqualToString:@"showorder_list4"]) {
        OrderListTableViewController* controller = [segue destinationViewController];
        controller.orderFlag = 3;
        if ([[UserManagerObject shareInstance]userType]!=3) {
            [self.controllerArray addObject:controller];
        }
    }
    else if ([segue.identifier isEqualToString:@"showorder_list5"]) {
        OrderListTableViewController* controller = [segue destinationViewController];
        controller.orderFlag = 4;
        if ([[UserManagerObject shareInstance]userType]!=3) {
            [self.controllerArray addObject:controller];
        }
    }
        
}


@end
