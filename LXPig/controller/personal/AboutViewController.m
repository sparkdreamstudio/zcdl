//
//  AboutViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import "AboutViewController.h"
#import "NetWorkClient.h"
@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self addBackButton];
    [[NetWorkClient shareInstance]postUrl:SERVICE_OTHERSERVICE With:@{@"action":@"detail",@"type":@"4"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self.webView loadHTMLString:[[responseObj objectForKey:@"data"]objectForKey:@"intro"] baseURL:nil];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
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
