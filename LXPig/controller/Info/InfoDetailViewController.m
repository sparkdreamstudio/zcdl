//
//  InfoDetailViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/11.
//
//

#import "InfoDetailViewController.h"
#import "UMSocial.h"
@interface InfoDetailViewController ()<UIWebViewDelegate,UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* webViewHeight;
@property (strong,nonatomic) UIView* hud;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) UIImage* shareImg;
@end

@implementation InfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title =@"资讯详情";
    self.titleLabel.text = self.dic[@"title"];
    self.timeLabel.text = self.dic[@"newstime"];
    self.authorLabel.text = [NSString stringWithFormat:@"作者:%@",self.dic[@"author"]];
    self.sourceLabel.text = [NSString stringWithFormat:@"来源:%@",self.dic[@"source"]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.webView.delegate = self;
    if([self.dic[@"shareurl"] length]>0)
    {
        SDWebImageManager* manager = [SDWebImageManager sharedManager];
        [manager.imageDownloader downloadImageWithURL:[NSURL URLWithString:self.dic[@"titlepic"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (error) {
                self.shareImg = [UIImage imageNamed:@"shareImg"];
            }
            else
            {
                self.shareImg = image;
            }
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_button"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        }];
        
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
                                     shareImage:self.shareImg
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,nil]
                                       delegate:self];
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if ([platformName isEqualToString:UMShareToQQ]) {
        socialData.extConfig.qqData.url = self.dic[@"shareurl"];
        socialData.extConfig.qqData.shareImage = self.shareImg;
        socialData.extConfig.qqData.shareText = self.dic[@"smalltext"];
    }
    else if ([platformName isEqualToString:UMShareToWechatSession]) {
        socialData.extConfig.wechatSessionData.url = self.dic[@"shareurl"];
        socialData.extConfig.wechatSessionData.shareImage = self.shareImg;
        socialData.extConfig.wechatSessionData.shareText = self.dic[@"smalltext"];
    }
    else if ([platformName isEqualToString:UMShareToWechatTimeline]) {
        socialData.extConfig.wechatTimelineData.url = self.dic[@"shareurl"];
        socialData.extConfig.wechatTimelineData.shareImage = self.shareImg;
        socialData.extConfig.wechatTimelineData.shareText = self.dic[@"smalltext"];
    }
    else if ([platformName isEqualToString:UMShareToSina])
    {
        socialData.extConfig.sinaData.shareImage = self.shareImg;
        socialData.extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",self.dic[@"smalltext"],self.dic[@"shareurl"]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);

    [self.webView loadHTMLString:self.htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];
    self.webView.hidden = YES;
    self.hud = [self showNormalHudNoDimissWithString:@"加载"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismissHUD:self.hud];
    self.hud = nil;
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    NSInteger height = [height_str integerValue];
    self.webViewHeight.constant = height;
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
