//
//  QAndATableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/6.
//
//

#import "QAndATableViewController.h"
#import "NetWorkClient.h"
#import "QAndADetailViewController.h"
@interface QAndATableViewController ()
@property (nonatomic,strong) NSMutableArray * problemArray;
@property (assign,nonatomic) NSInteger currentPage;
@end

@implementation QAndATableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullRefresh];
    [self addInfinitScorll];
    [self startRefresh];
    [self.tableView setBackgroundColor:HEXCOLOR(@"f3f3f3")];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)pullRfresh
{
    self.currentPage = 1;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:@"10" forKey:@"pageSize"];
    [params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPageNo"];
//    [params setValue:[[UserManagerObject shareInstance]sessionid] forKey:@"sessionid"];
    if (self.codeId) {
        [params setValue:self.codeId forKey:@"codeId"];
    }
    if (self.isSolve) {
        [params setValue:self.isSolve forKey:@"isSolve"];
    }
    [[NetWorkClient shareInstance]postUrl:SERVICE_PROBLEM With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.problemArray = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if (self.problemArray.count <10) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        [self.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
    }];
}

-(void)infinitScorll
{
    self.currentPage++;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:@"10" forKey:@"pageSize"];
    [params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPageNo"];
//    [params setValue:[[UserManagerObject shareInstance]sessionid] forKey:@"sessionid"];
    if (self.codeId) {
        [params setValue:self.codeId forKey:@"codeId"];
    }
    if (self.isSolve) {
        [params setValue:self.isSolve forKey:@"isSolve"];
    }
    [[NetWorkClient shareInstance]postUrl:SERVICE_PROBLEM With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        NSMutableArray* array = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"data"]];
        if(array.count == 0)
        {
            [self setInfinitScorllHidden:YES];
            return ;
        }
        if (array.count <10) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        [self.problemArray addObjectsFromArray:array];
        NSMutableArray* indexPathArray = [NSMutableArray array];
        for (NSInteger index = (self.problemArray.count - array.count); index < self.problemArray.count; index++) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopPull];
        self.currentPage--;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.problemArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.problemArray[indexPath.row];
    return 130+[Utils getSizeOfString:dic[@"content"] WithSize:CGSizeMake(SCREEN_WIDTH-30, NSIntegerMax) AndSystemFontSize:13].height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    NSDictionary* dic = self.problemArray[indexPath.row];
    NSInteger isSolve = [dic[@"isSolve"] integerValue];
    if (isSolve == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
    }
    UIView* view = [cell viewWithTag:5];
    view.layer.borderWidth = 1;
    view.layer.borderColor = HEXCOLOR(@"cdcdcd").CGColor;
    view.layer.masksToBounds = YES;
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    if(dic[@"members"][@"nickName"] && [dic[@"members"][@"nickName"] length]>0 )
    {
        label.text = [NSString stringWithFormat:@"%@提问",dic[@"members"][@"nickName"]];
    }
    else{
        
        NSMutableString* userName = [NSMutableString  stringWithString:[NSString stringWithFormat:@"%@提问",dic[@"members"][@"userName"]]];
        if (userName.length > 7) {
            [userName replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        label.text = userName;
    }
    
    label = (UILabel*)[cell viewWithTag:2];
    label.text = dic[@"content"];
    label = (UILabel*)[cell viewWithTag:3];
    label.text = dic[@"createTime"];
    label = (UILabel*)[cell viewWithTag:4];
    label.text = [NSString stringWithFormat:@"有用 %@ | 回复 %@",dic[@"usefulCnt"],dic[@"replyCnt"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.problemArray[indexPath.row];
    [self performSegueWithIdentifier:@"show_problem_detail" sender:dic];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_problem_detail"]) {
        QAndADetailViewController* controller = [segue destinationViewController];
        controller.problem = sender;
        controller.qAndAType = self.qAndAType;
    }
}


@end
