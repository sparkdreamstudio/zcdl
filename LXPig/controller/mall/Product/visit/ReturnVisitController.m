//
//  ReturnVisitController.m
//  LXPig
//
//  Created by leexiang on 15/4/22.
//
//

#import "ReturnVisitController.h"
#import "ReturnVisitCell.h"
#import "NetWorkClient.h"
@interface ReturnVisitController ()
@property (nonatomic,strong) NSMutableArray* infoArray;
@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation ReturnVisitController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addPullRefresh];
    [self addInfinitScorll];
    [self startRefresh];
}

-(void)pullRfresh
{
    _currentPage = 1;
    __weak ReturnVisitController* weakself = self;
    [[NetWorkClient shareInstance] postUrl:SERVICE_VISIT With:@{@"action":@"list",@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20",@"productId":[NSNumber numberWithLongLong:self.productId]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [weakself stopPull];
        weakself.infoArray = [responseObj objectForKey:@"data"];
        if (weakself.infoArray.count < 20) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        [weakself.tableView reloadData];
        
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [weakself stopPull];
    }];
}

-(void)infinitScorll
{
    _currentPage++;
    __weak ReturnVisitController* weakself = self;
    [[NetWorkClient shareInstance] postUrl:SERVICE_VISIT With:@{@"action":@"list",@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20",@"productId":[NSNumber numberWithLongLong:self.productId]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [weakself stopInfinitScorll];
        NSArray* array = [responseObj objectForKey:@"data"];
        if (array.count < 20) {
            [self setInfinitScorllHidden:YES];
        }
        else
        {
            [self setInfinitScorllHidden:NO];
        }
        if (array.count == 0) {
            weakself.currentPage--;
            return ;
        }
        [weakself.infoArray addObjectsFromArray:array];
        NSMutableArray* arrayIndexPath = [NSMutableArray array];
        for (NSUInteger i = weakself.infoArray.count-array.count-1; i < array.count; i++) {
            [arrayIndexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:arrayIndexPath withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        weakself.currentPage--;
        [weakself stopInfinitScorll];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    NSDictionary* dic = self.infoArray[indexPath.row];
    height = 53 + [Utils getSizeOfString:dic[@"content"] WithSize:CGSizeMake(SCREEN_WIDTH - 22, 1) AndSystemFontSize:15].height;
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReturnVisitCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary* dic = self.infoArray[indexPath.row];
    cell.dateLabel.text = dic[@"date"];
    cell.commentLabel.text = dic[@"content"];
    return cell;
}
@end
