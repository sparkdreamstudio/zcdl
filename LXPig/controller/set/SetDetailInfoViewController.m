//
//  SetDetailInfoViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/28.
//
//

#import "SetDetailInfoViewController.h"

@interface SetDetailInfoViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* webViewHeight;
@end

@implementation SetDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title =@"内容详情";
    self.titleLabel.text = self.dic[@"title"];
    self.timeLabel.text = self.dic[@"createTime"];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = false;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.webView loadHTMLString:self.htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    NSInteger height = [height_str integerValue];
    self.webViewHeight.constant = height+20;
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
