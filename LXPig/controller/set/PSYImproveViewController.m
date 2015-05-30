//
//  PSYImproveViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import "PSYImproveViewController.h"
#import "NetWorkClient.h"
@interface PSYImproveViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PSYImproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    switch (self.type) {
        case 1:
            self.title =@"提升窝均产活仔数";
            break;
        case 2:
            self.title =@"降低非生产天数";
            break;
        case 3:
            self.title =@"提升断奶存货率";
            break;
        default:
            break;
    }
    [[NetWorkClient shareInstance]postUrl:SERVICE_OTHERSERVICE With:@{@"action":@"detail",@"type":@(self.type)} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self.webView loadHTMLString:[[responseObj objectForKey:@"data"] objectForKey:@"intro"] baseURL:nil];
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
