//
//  ProductDetailTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/21.
//
//

#import "ProductDetailTableViewController.h"
#import "SKTagView.h"
#import "NetWorkClient.h"
#import "LPLabel.h"
#import "ProductDetailViewController.h"
#import "EnterpriseDetailController.h"
#import "ProductInfo.h"
@interface ProductDetailTableViewController ()<UIWebViewDelegate,ImagePlayerViewDelegate>
{
    CGFloat labelheight;
    BOOL loaded;
    CGFloat webViewHeight;
}

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet LPLabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UIWebView *introWebView;
@property (weak, nonatomic) IBOutlet ImagePlayerView* imagePlayer;
@property (weak, nonatomic) IBOutlet SKTagView *tagView;
@property (weak, nonatomic) IBOutlet UILabel  *tagLabel;
@property (strong,nonatomic)NSMutableArray *urlArray;
@property (weak, nonatomic) IBOutlet UILabel *kefuMobile;
@property (weak, nonatomic) IBOutlet UILabel *kefuQQ;

@end

@implementation ProductDetailTableViewController

- (void)initAshen {
    self.productNameLabel.font = [UIFont systemFontOfSize:15];
    self.salePriceLabel.font = [UIFont systemFontOfSize:15];
    self.marketPriceLabel.font = [UIFont systemFontOfSize:13];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loaded = NO;
    webViewHeight = 5;
    self.introWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    self.marketPriceLabel.strikeThroughColor = self.marketPriceLabel.textColor;
    self.marketPriceLabel.strikeThroughEnabled = YES;
    self.introWebView.scrollView.scrollEnabled = NO;
    self.imagePlayer.imagePlayerViewDelegate = self;
    self.imagePlayer.pageControlPosition = ICPageControlPosition_BottomCenter;
    self.imagePlayer.hidePageControl = NO;
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.cornerRadius = 2;
    
    [self initAshen];
    
    self.urlArray = [NSMutableArray array];
    __weak ProductDetailTableViewController* weakself = self;
    UIView* view = [self.detailViewController showNormalHudNoDimissWithString:@"加载中"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_PRODUCT With:@{@"action":@"detail",
                                                                 @"id":[NSNumber numberWithLongLong:self.productId]}
                                  success:^(NSDictionary *responseObj, NSString *timeSp) {
                                      NSDictionary* dic = [responseObj objectForKey:@"data"];
                                      weakself.productNameLabel.text = dic[@"name"];
                                      weakself.salePriceLabel.text = [dic[@"salePrice"] stringValue];
                                      weakself.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@", dic[@"marketPrice"]];
                                      
                                      [weakself.introWebView loadHTMLString:dic[@"intro"] baseURL:nil];
                                      NSString* tag = [dic objectForKey:@"tag"];
                                      if (tag && tag.length > 0) {
                                          self.tagLabel.text = [NSString stringWithFormat:@" %@ ",tag];
                                      }
                                      else
                                      {
                                          self.tagLabel.hidden = YES;
                                      }
                                      weakself.detailViewController.enterPriseController.info.intro = dic[@"enterprise"][@"intro"];
                                      [weakself.detailViewController.enterPriseController reloadHtml];
                                      [weakself.detailViewController dismissHUD:view];
                                      
                                      
                                      weakself.tagView.preferredMaxLayoutWidth = SCREEN_WIDTH;
                                      weakself.tagView.backgroundColor = UIColor.whiteColor;
                                      //<<<<<<< Updated upstream
                                      weakself.tagView.padding    = UIEdgeInsetsMake(2, 13, 15, 13);
                                      weakself.tagView.insets    = 6;
                                      weakself.tagView.lineSpace = 8;
                                      //=======
                                      //            weakself.tagView.padding    = UIEdgeInsetsMake(1, 13, 15, 13);
                                      //            weakself.tagView.insets    = 5;
                                      //            weakself.tagView.lineSpace = 5;
                                      //>>>>>>> Stashed changes
                                      
                                      
                                      
                                      [weakself.tagView removeAllTags];
                                      
                                      //Add Tags
                                      [dic[@"imgList"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                          [weakself.urlArray addObject:[NSURL URLWithString:[obj objectForKey:@"val"]]];
                                      }];
                                      [weakself.imagePlayer reloadData];
                                      [dic[@"labelList"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                                       {
                                           
                                           SKTag *tag = [SKTag tagWithText:[obj objectForKey:@"val"]];
                                           tag.fontSize = 10;
                                           tag.textColor = TextGrayColor;
                                           tag.selectedTextColor = TextGrayColor;
                                           /*****************Ashen*************************/
                                           tag.padding = UIEdgeInsetsMake(7, 10, 7, 10);
                                           
                                           /*****************Ashen*************************/
                                           tag.bgImg = [Utils imageWithColor:[UIColor whiteColor]];
                                           tag.selectedBgImg = [Utils imageWithColor:[UIColor whiteColor]];
                                           tag.borderColor = [UIColor colorWithRed:0xd7/255.f green:0xd7/255.f blue:0xd7/255.f alpha:1];
                                           tag.borderWidth = 1;
                                           /*****************Ashen*************************/
                                           tag.cornerRadius = 4;
                                           /*****************Ashen*************************/
                                           
                                           [weakself.tagView addTag:tag];
                                       }];
                                      loaded = YES;
                                      [weakself.tableView reloadData];
                                  } failure:^(NSDictionary *responseObj, NSString *timeSp) {
                                      [weakself.detailViewController dismissHUD:view];
                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return loaded?7:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
        {
            height = SCREEN_WIDTH*0.547;
            break;
        }
        case 1:
        {
            height = 30;
            break;
        }
        case 2:
        {
            height = 45;
            break;
        }
        case 3:
        {
            height = [self.tagView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
            break;
        }
        case 4:
        {
            height = 60;
            break;
        }
        case 5:
        {
            height = 40;
            break;
        }
        case 6:
        {
            height = webViewHeight;
            
            break;
        }
        default:
            break;
    }
    return height;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    webViewHeight = [height_str floatValue];
    
    [self.tableView reloadData];
}
#pragma mark -ImagePlayerViewDelegate-
- (NSInteger)numberOfItems
{
    return self.urlArray.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
    //    [imageView setImageWithURL:[self.imageURLs objectAtIndex:index] placeholderImage:nil];
    __weak UIImageView* weakImageView = imageView;
    [[SDWebImageManager sharedManager]downloadImageWithURL:self.urlArray[index] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (finished) {
            weakImageView.image = image;
        }
    }];
    
}
@end
