//
//  SetDetailInfoViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/28.
//
//

#import "SetDetailInfoViewController.h"
#import "UMSocial.h"
@interface SetDetailInfoViewController ()<UIWebViewDelegate,UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* webViewHeight;
@property (strong,nonatomic) UIView* hud;
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

    self.webView.hidden = YES;
    if([self.dic[@"shareurl"] length]>0)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_button"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareAction:(UIBarButtonItem*)sender
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"559f8b4f67e58ed786003993"
        shareText:self.dic[@"title"]
        shareImage:[UIImage imageNamed:@"shareImg"]
        shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,nil]
                                       delegate:self];
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if ([platformName isEqualToString:UMShareToQQ]) {
        socialData.extConfig.qqData.url = self.dic[@"shareurl"];
    }
    else if ([platformName isEqualToString:UMShareToWechatSession]) {
        socialData.extConfig.wechatSessionData.url = self.dic[@"shareurl"];
    }
    else if ([platformName isEqualToString:UMShareToWechatTimeline]) {
        socialData.extConfig.wechatTimelineData.url = self.dic[@"shareurl"];
    }
    else if ([platformName isEqualToString:UMShareToSina])
    {
        socialData.extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",self.dic[@"smalltext"],self.dic[@"shareurl"]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webViewHeight.constant = 0;
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    self.hud = [self showNormalHudNoDimissWithString:@"加载"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
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
