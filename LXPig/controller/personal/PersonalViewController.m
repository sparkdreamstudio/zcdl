//
//  PersonalViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/29.
//
//

#import "PersonalViewController.h"

@interface PersonalViewController ()
@property (weak, nonatomic) IBOutlet ImagePlayerView *adImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 35;
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[[UserManagerObject shareInstance]photoFile]] placeholderImage:nil];
    self.userName.text = [[UserManagerObject shareInstance]name];
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
