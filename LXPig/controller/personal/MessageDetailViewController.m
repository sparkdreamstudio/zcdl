//
//  MessageDetailViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/2.
//
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()
@property (weak,nonatomic) IBOutlet UILabel* time;
@property (weak,nonatomic) IBOutlet UILabel* content;
@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time.text = self.message[@"createTime"];
    self.content.text = self.message[@"content"];
    // Do any additional setup after loading the view.
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
