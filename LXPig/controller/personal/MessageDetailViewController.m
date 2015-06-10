//
//  MessageDetailViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/2.
//
//

#import "MessageDetailViewController.h"
#import "NetWorkClient.h"
@interface MessageDetailViewController ()
@property (weak,nonatomic) IBOutlet UILabel* time;
@property (weak,nonatomic) IBOutlet UILabel* content;
@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.time.text = @"";
    self.content.text = @"";
    [[NetWorkClient shareInstance]postUrl:SERVICE_MESSAGE With:@{@"action":@"view",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"id":self.message[@"id"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        NSDictionary* data= [responseObj objectForKey:@"data"];
        self.time.text = data[@"createTime"];
        self.content.text = data[@"content"];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
    
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
