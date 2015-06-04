//
//  PersonalContainerViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import "PersonalContainerViewController.h"
#import "PersonalViewController.h"
@interface PersonalContainerViewController ()
@property (nonatomic, assign)NSInteger userType;
@property (nonatomic, strong)PersonalViewController* personalController;
@end

@implementation PersonalContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userType = -2;
    [self loadPersonView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPersonView:) name:NTF_LOGIN_OK object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)reloadPersonView:(NSNotification*)ntf
{
    [self loadPersonView];
}

-(void)loadPersonView
{
    if (self.userType != [[UserManagerObject shareInstance]userType]) {
        if (self.personalController) {
            [self.personalController.view removeFromSuperview];
            [self.personalController removeFromParentViewController];
            self.personalController = nil;

        }
        self.userType = [[UserManagerObject shareInstance]userType];
        NSString *storyboardId = @"";
        if (self.userType == 0) {
            storyboardId = @"person_individual";
        }
        else
        {
            storyboardId = @"person_enterprise";
        }
        self.personalController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:storyboardId];
        [self addChildViewController:self.personalController];
        self.personalController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.personalController.view];
        [self.view  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.personalController.view}]];
        [self.view  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.personalController.view}]];
    }
    
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
