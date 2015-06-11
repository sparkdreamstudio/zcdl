//
//  PSYResultViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/16.
//
//

#import "PSYResultViewController.h"
#import "NetWorkClient.h"
#import "PSYImproveViewController.h"

@interface PSYResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *upOne;
@property (weak, nonatomic) IBOutlet UIButton *upTwo;
@property (weak, nonatomic) IBOutlet UIButton *upThree;
@property (weak,nonatomic) IBOutlet UILabel* result1;
@property (weak,nonatomic) IBOutlet UILabel* result2;
@property (weak,nonatomic) IBOutlet UILabel* result3;
@property (weak,nonatomic) IBOutlet UILabel* result4;

@property (weak,nonatomic) IBOutlet UILabel* changeLabel;
@end

@implementation PSYResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(IOS_SYSTEM_VERSION >= 7.f)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self addBackButton];
    self.title = @"您的计算结果";
    self.result1.text = [NSString stringWithFormat:@"%.2f",self.r1];
    if (self.r1 >= 12) {
        [self.result1 setTextColor:HEXCOLOR(@"01cc1a")];
    }
    else if (self.r1 < 12 && self.r1>9)
    {
        [self.result1 setTextColor:HEXCOLOR(@"FF7C06")];
    }
    else
    {
        [self.result1 setTextColor:NavigationBarColor];
    }
    self.result2.text = [NSString stringWithFormat:@"%.2f",self.r2];
    if (self.r2 <= 40) {
        [self.result2 setTextColor:HEXCOLOR(@"01cc1a")];
    }
    else if (self.r2 > 40 && self.r2 < 50)
    {
        [self.result2 setTextColor:HEXCOLOR(@"FF7C06")];
    }
    else
    {
        [self.result2 setTextColor:NavigationBarColor];
    }
    self.result3.text = [NSString stringWithFormat:@"%.2f%%",self.r3*100];
    if (self.r3 >= 0.96) {
        [self.result3 setTextColor:HEXCOLOR(@"01cc1a")];
    }
    else if (self.r3 < 0.96 && self.r3>0.94)
    {
        [self.result3 setTextColor:HEXCOLOR(@"FF7C06")];
    }
    else
    {
        [self.result3 setTextColor:NavigationBarColor];
    }
    self.result4.text = [NSString stringWithFormat:@"%.2f",self.r4];
    if (self.r4 >= 25) {
        [self.result4 setTextColor:HEXCOLOR(@"01cc1a")];
    }
    else if (self.r4 < 25 && self.r4>20)
    {
        [self.result4 setTextColor:HEXCOLOR(@"FF7C06")];
    }
    else
    {
        [self.result4 setTextColor:NavigationBarColor];
    }
    self.upOne.hidden = self.r1>=12;
    self.upTwo.hidden = self.r2<40;
    self.upThree.hidden = self.r3>=0.96;
    self.upOne.layer.masksToBounds = YES;
    self.upOne.layer.cornerRadius = 3;
    self.upTwo.layer.masksToBounds = YES;
    self.upTwo.layer.cornerRadius = 3;
    self.upThree.layer.masksToBounds = YES;
    self.upThree.layer.cornerRadius = 3;
    if (SCREEN_WIDTH == 320) {
        self.changeLabel.font = [UIFont systemFontOfSize:9];
    }
    else
    {
        self.changeLabel.font = [UIFont systemFontOfSize:12];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)upClick:(id)sender {
    PSYImproveViewController* controller = [[PSYImproveViewController alloc]init];
    controller.type = [sender tag];
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
