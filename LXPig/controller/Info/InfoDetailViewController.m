//
//  InfoDetailViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/11.
//
//

#import "InfoDetailViewController.h"

@interface InfoDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* webViewHeight;
@property (strong,nonatomic) UIView* hud;

@end

@implementation InfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title =@"资讯详情";
    self.titleLabel.text = self.dic[@"title"];
    self.timeLabel.text = self.dic[@"newstime"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.webView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    self.webView.hidden = YES;
    self.hud = [self showNormalHudNoDimissWithString:@"加载"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismissHUD:self.hud];
    self.hud = nil;
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    NSInteger height = [height_str integerValue];
    self.webViewHeight.constant = height+20;
    self.webView.hidden = NO;
    
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
