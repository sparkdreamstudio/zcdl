//
//  PSYResultViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/16.
//
//

#import "PSYResultViewController.h"

@interface PSYResultViewController ()
@property (weak,nonatomic) IBOutlet UILabel* result1;
@property (weak,nonatomic) IBOutlet UILabel* result2;
@property (weak,nonatomic) IBOutlet UILabel* result3;
@property (weak,nonatomic) IBOutlet UILabel* result4;
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
    self.result1.text = [NSString stringWithFormat:@"%ld",(long)self.r1];
    self.result2.text = [NSString stringWithFormat:@"%ld",(long)self.r2];
    self.result3.text = [NSString stringWithFormat:@"%.1f%%",self.r3*100];
    self.result4.text = [NSString stringWithFormat:@"%ld",(long)self.r4];
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
