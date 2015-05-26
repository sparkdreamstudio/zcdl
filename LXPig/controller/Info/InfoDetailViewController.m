//
//  InfoDetailViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/11.
//
//

#import "InfoDetailViewController.h"

@interface InfoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation InfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title =@"资讯详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
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
