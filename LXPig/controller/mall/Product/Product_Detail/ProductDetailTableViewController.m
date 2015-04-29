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

@interface ProductDetailTableViewController ()<UIWebViewDelegate,ImagePlayerViewDelegate>
{
    CGFloat labelheight;
    BOOL loaded;
    
}

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet LPLabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UIWebView *introWebView;
@property (weak, nonatomic) IBOutlet ImagePlayerView* imagePlayer;
@property (weak, nonatomic) IBOutlet SKTagView *tagView;
@property (strong,nonatomic)NSMutableArray *urlArray;

@end

@implementation ProductDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loaded = NO;
    self.marketPriceLabel.strikeThroughColor = self.marketPriceLabel.textColor;
    self.marketPriceLabel.strikeThroughEnabled = YES;
    self.introWebView.scrollView.scrollEnabled = NO;
    self.introWebView.scalesPageToFit = YES;
    self.imagePlayer.imagePlayerViewDelegate = self;
    self.imagePlayer.pageControlPosition = ICPageControlPosition_BottomCenter;
    self.imagePlayer.hidePageControl = NO;
    self.urlArray = [NSMutableArray array];
    __weak ProductDetailTableViewController* weakself = self;
    UIView* view = [self showNormalHudNoDimissWithString:@"加载中"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_PRODUCT With:@{@"action":@"detail",
               @"id":[NSNumber numberWithLongLong:self.productId]}
        success:^(NSDictionary *responseObj, NSString *timeSp) {
            NSDictionary* dic = [responseObj objectForKey:@"data"];
            weakself.productNameLabel.text = dic[@"name"];
            weakself.salePriceLabel.text = [dic[@"salePrice"] stringValue];
            weakself.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@", dic[@"marketPrice"]];
            [weakself.introWebView loadHTMLString:dic[@"intro"] baseURL:nil];
            
            [weakself dismissHUD:view];
            
            
            weakself.tagView.preferredMaxLayoutWidth = SCREEN_WIDTH;
            weakself.tagView.backgroundColor = UIColor.whiteColor;
            weakself.tagView.padding    = UIEdgeInsetsMake(1, 13, 15, 13);
            weakself.tagView.insets    = 15;
            weakself.tagView.lineSpace = 8;
            
            
            
            [weakself.tagView removeAllTags];

            //Add Tags
            [dic[@"imgList"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [weakself.urlArray addObject:[NSURL URLWithString:[obj objectForKey:@"val"]]];
            }];
            [weakself.imagePlayer reloadData];
            [dic[@"labelList"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
             {
                 
                 SKTag *tag = [SKTag tagWithText:[obj objectForKey:@"val"]];
                 tag.textColor = TextGrayColor;
                 tag.selectedTextColor = TextGrayColor;
                 tag.fontSize = 13;
                 tag.padding = UIEdgeInsetsMake(10, 3, 10, 3);
                 tag.bgImg = [Utils imageWithColor:[UIColor whiteColor]];
                 tag.selectedBgImg = [Utils imageWithColor:[UIColor whiteColor]];
                 tag.borderColor = [UIColor colorWithRed:0xd7/255.f green:0xd7/255.f blue:0xd7/255.f alpha:1];
                 tag.borderWidth = 1;
                 tag.cornerRadius = 5;
                 
                 [weakself.tagView addTag:tag];
             }];
            loaded = YES;
            [weakself.tableView reloadData];
        } failure:^(NSDictionary *responseObj, NSString *timeSp) {
            [weakself dismissHUD:view];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return loaded?1:0;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return loaded?6:0;
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
            
            
//            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
//            height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//            if (height <= 1) {
//                height = labelheight;
//            }
//            else
//            {
//                labelheight = height;
//            }
            height = [self.tagView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
            break;
        }
        case 4:
        {
            height = 40;
            break;
        }
        case 5:
        {
            height = self.introWebView.frame.size.height;
            
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
//    CGRect frame = webView.frame;
//    frame.size.height = 1;
//    frame.size.width = SCREEN_WIDTH;
//    webView.frame = frame;
//    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    frame.size = webView.scrollView.contentSize;
//    webView.frame = frame;
//    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];

    NSString *width_str = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"];
    int height = [height_str intValue];
    CGFloat width = [width_str floatValue];
    CGRect frame = CGRectMake(0,0,SCREEN_WIDTH,height*SCREEN_WIDTH/width);
    webView.frame = CGRectMake(0,0,SCREEN_WIDTH,height);
    NSLog(@"height: %@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"]);
    
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
