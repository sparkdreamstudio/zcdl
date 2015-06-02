//
//  EnterpriseDetailController.m
//  LXPig
//
//  Created by leexiang on 15/4/22.
//
//

#import "EnterpriseDetailController.h"
#import "ProductInfo.h"
@interface EnterpriseDetailController ()<UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *fax;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@end

@implementation EnterpriseDetailController


-(void)viewDidLoad
{
    [super viewDidLoad];
    /*******Ashen*********/
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, self.nameLabel.frame.origin.y, SCREEN_WIDTH, self.nameLabel.frame.size.height)];
    
    label.text = self.info.name;
    self.nameLabel.hidden = YES;
    //self.nameLabel.text = self.info.name;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    /*******Ashen*********/
    
    self.phone.text = self.info.tel;
    self.fax.text = self.info.fax;
    self.address.text = self.info.address;
    self.infoWebView.scrollView.scrollEnabled = NO;
}

-(void)reloadHtml
{
    [self.infoWebView loadHTMLString:self.info.intro baseURL:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.infoWebView loadHTMLString:self.info.intro baseURL:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
        {
            height = 50;
            break;
        }
        case 1:
        {
            height = 54;
            break;
        }
        case 2:
        {
            height = 50;
            break;
        }
        case 3:
        {
            height = 50;
            break;
        }
        case 4:
        {
            height = 59;
            break;
        }
        case 5:
        {
            height = self.infoWebView.frame.size.height;
            break;
        }
        default:
            break;
    }
    return height;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (SCREEN_WIDTH >= 375) {
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
        [webView stringByEvaluatingJavaScriptFromString:str];
    } else if (SCREEN_WIDTH <= 320) {
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'";
        [webView stringByEvaluatingJavaScriptFromString:str];
    }


    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    
    NSString *width_str = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
    int height = [height_str intValue];
    CGFloat width = [width_str floatValue];
    CGRect frame = CGRectMake(0,0,SCREEN_WIDTH,height);
    webView.frame = frame;
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadData];
    
    

//    CGFloat webViewHeight = 0.0f;
//    
//    
//        
//        UIView *scrollerView = webView.scrollView;
//        
//        if (scrollerView.subviews.count > 0)
//            
//        {
//            
//            for (UIView* webDocView in scrollerView.subviews) {
//                if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]])
//                    
//                {
//                    
//                    webViewHeight = webDocView.frame.size.height;
//                    break;
//                    
//                }
//            }
//            UIView *webDocView = scrollerView.subviews.lastObject;
//            
//            
//            
//        }
//        
//
//    webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight);
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

-(IBAction)callEnterprise:(id)sender
{
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"拨打电话%@",self.info.fax] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.info.fax]]];
    }
}
@end
