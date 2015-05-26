//
//  AdWebViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/17.
//
//

#import "AdWebViewController.h"

@interface AdWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView* adWebView;

@end

@implementation AdWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addBackButton];
    self.title = self.adInfo[@"title"];
    [self.adWebView loadHTMLString:self.adInfo[@"intro"] baseURL:nil];
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
