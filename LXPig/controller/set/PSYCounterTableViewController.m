//
//  PSYCounterTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/16.
//
//

#import "PSYCounterTableViewController.h"
#import "PSYButtonTableViewCell.h"
#import "PSYCountIntputTableViewCell.h"
#import "PSYResultViewController.h"
#import "NetWorkClient.h"
#import "PSYCountHeadTableViewCell.h"
@interface PSYCounterTableViewController ()<PSYButtonTableViewCellDelegate,PSYCountIntputTableViewCellDelegate,UIActionSheetDelegate,UIWebViewDelegate>
{
    NSInteger param0;
    NSInteger param1;
    NSInteger param2;
    NSInteger param3;
    NSInteger param4;
}
@property (weak,nonatomic)UIButton *btn;
@property (strong,nonatomic) NSString* str;
@property (assign,nonatomic) CGFloat webViewHeight;
@end

@implementation PSYCounterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    param0 = param1 = param2 = param3 = param4 = -1;
    
    [self addBackButton];
    self.title = @"PSY即时计算器";
    self.tableView.backgroundColor = HEXCOLOR(@"f7f7f7");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    UIView* headerView = [[[NSBundle mainBundle] loadNibNamed:@"PSYCounterHeaderAndFooter" owner:nil options:nil] objectAtIndex:0];
//    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 178.f*375.f/SCREEN_WIDTH);
//    self.tableView.tableHeaderView = headerView;
    
    UIView* footerView = [[[NSBundle mainBundle] loadNibNamed:@"PSYCounterHeaderAndFooter" owner:nil options:nil] objectAtIndex:1];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    UIButton *resultButton =(UIButton*)[footerView viewWithTag:1];
    resultButton.layer.masksToBounds = YES;
    resultButton.layer.cornerRadius = 4;
    [resultButton addTarget:self action:@selector(getResult:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = footerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PSYButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"PSYButtonTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PSYCountIntputTableViewCell" bundle:nil] forCellReuseIdentifier:@"PSYCountIntputTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PSYCountHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"headCell"];
    [self.tableView reloadData];
    
    [[NetWorkClient shareInstance]postUrl:SERVICE_OTHERSERVICE With:@{@"action":@"detail",@"type":@"5"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.str = [[responseObj objectForKey:@"data"] objectForKey:@"intro"];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)psyButtonClickCell:(PSYButtonTableViewCell *)cell
{
    [self.tableView endEditing:YES];
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"选择测定周期" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"一周",@"一月",@"3个月",@"半年",@"一年", nil];
    [sheet showInView:self.view];
}

-(void)psyCountInputCell:(PSYCountIntputTableViewCell *)cell text:(NSString *)text
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 1:
            param1 = [text integerValue];
            break;
        case 2:
            param3 = [text integerValue];
            
            break;
        case 3:
            param2 = [text integerValue];
            break;
        case 4:
            param4 = [text integerValue];
            break;
        default:
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        NSArray* array = @[@"一周",@"一月",@"3个月",@"半年",@"一年"];
        [self.btn setTitle:[array objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        param0 = buttonIndex;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return self.webViewHeight;
    else
        return 67;
}

-(void)getResult:(UIButton*)btn
{
    [self.tableView endEditing:YES];
//    if (param0 == -1) {
//        [self showNormalHudDimissWithString:@"请选择测定周期"];
//        return;
//    }
    if (param1 == -1) {
        [self showNormalHudDimissWithString:@"请填写存栏母猪数"];
    }
    if (param2 == -1) {
        [self showNormalHudDimissWithString:@"请填写总产活仔数"];
        return;
    }
    if (param3 == -1) {
        [self showNormalHudDimissWithString:@"请填写总产窝数"];
        return;
    }
    if (param4 == -1) {
        [self showNormalHudDimissWithString:@"请填写总断奶仔猪数"];
        return;
    }
    NSInteger count = 0;
    switch (param0) {
        case 0:
            count = 52;
            break;
        case 1:
            count = 12;
            break;
        case 2:
            count = 4;
            break;
        case 3:
            count = 2;
            break;
        case 4:
            count = 1;
            break;
        default:
            break;
    }
    CGFloat result1 = 0;
    CGFloat result2 = 0;
    CGFloat result3 = 0;
    CGFloat result4 = 0;
    if (param1!=0&&param2!=0&&param3!=0) {
        result1 = ((CGFloat)param2)/((CGFloat)param3);
        result2 = 365.f/(((CGFloat)param3)/((CGFloat)param1))-114-25;
        result3 = ((CGFloat)param4)/((CGFloat)param2);
        result4 = ((CGFloat)param3)/((CGFloat)param1)*result1*result3;
    }
    
    PSYResultViewController* controller = [[PSYResultViewController alloc]initWithNibName:@"PSYResultViewController" bundle:nil];
    controller.r1 = result1;
    controller.r2 = result2;
    controller.r3 = result3;
    controller.r4 = result4;
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
    {
        PSYCountHeadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"headCell" forIndexPath:indexPath];
        cell.webView.delegate =self;
        cell.webView.scrollView.scrollEnabled = NO;
        cell.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
        if (self.str) {
            [cell.webView loadHTMLString:self.str baseURL:nil];
        }
       
        return  cell;
    }
//    else if (indexPath.row == 1) {
//        PSYButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PSYButtonTableViewCell" forIndexPath:indexPath];
//        cell.delegate = self;
//        self.btn = cell.textButton;
//        return cell;
//    }
    else{
        PSYCountIntputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PSYCountIntputTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        switch (indexPath.row) {
            case 1:
                cell.title.text = @"存栏母猪数";
                cell.textField.placeholder = @"此项必须大于0";
                break;
            case 2:
                cell.title.text = @"总产仔窝数";
                cell.textField.placeholder = @"此项必须大于0";
                break;
            case 3:
                cell.title.text = @"总产活仔数";
                break;
            case 4:
                cell.title.text = @"总断奶仔猪数";
                break;
            default:
                break;
        }
        return cell ;
    }
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.webViewHeight == 0) {
        NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
        CGFloat height = [height_str floatValue];
        self.webViewHeight = height;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
}

@end
