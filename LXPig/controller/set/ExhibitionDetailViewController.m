//
//  ExhibitionDetailViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import "ExhibitionDetailViewController.h"
#import "EhibitionDetailTitleTableViewCell.h"
#import "WebCellTableViewCell.h"
#import "EnListTableViewController.h"
@interface ExhibitionDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic) NSInteger webHeight;
@property (assign,nonatomic) BOOL loadedWeb;
@end

@implementation ExhibitionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title =@"活动详情";
    self.loadedWeb = NO;
    // Do any additional setup after loading the view from its nib.
    self.webHeight = 0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.544)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.info[@"img"]] placeholderImage:[UIImage imageNamed:@"info_null"]];
    self.tableView.tableHeaderView = imageView;
    [self.tableView registerNib:[UINib nibWithNibName:@"EhibitionDetailTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WebCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)callUs:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否拨打电话%@",self.info[@"tel"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.info[@"tel"]]]];
    }
}

- (IBAction)enList:(id)sender {
    EnListTableViewController* controller = [[EnListTableViewController alloc]initWithNibName:@"EnListTableViewController" bundle:nil];
    controller.info = self.info;
    [self.navigationController pushViewController:controller animated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }
    else
    {
        return self.webHeight;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EhibitionDetailTitleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        cell.titleLabel.text = self.info[@"title"];
        cell.endTime.text = [NSString stringWithFormat:@"活动日期：至%@截止报名",self.info[@"endDate"]];
        return cell;
    }
    else
    {
        WebCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.webView.delegate = self;
        [cell.webView loadHTMLString:self.info[@"intro"] baseURL:nil];
        return cell;
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.loadedWeb == NO) {
        NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
        NSInteger height = [height_str integerValue];
        self.webHeight = height+20;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        self.loadedWeb = YES;
    }
    
}

@end
