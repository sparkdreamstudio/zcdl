//
//  ProductRelatedController.m
//  LXPig
//
//  Created by leexiang on 15/4/22.
//
//

#import "ProductRelatedController.h"
#import "ProductInfoList.h"
#import "ProductRelatedCell.h"
@interface ProductRelatedController ()<ProductInfoListDelegate>
@property (strong,nonatomic) ProductInfoList* productInfoList;
@end

@implementation ProductRelatedController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.productInfoList = [[ProductInfoList alloc]init];
    self.productInfoList.delegate = self;
    [self addPullRefresh];
    [self addInfinitScorll];
    [self startRefresh];
}
-(void)pullRfresh
{
    [self.productInfoList refreshProductWithSearchKeyWord:nil enterpriseId:[NSNumber numberWithLongLong:self.enterpriseId] codeId:nil orderList:nil];
}
-(void)infinitScorll
{
    [self.productInfoList getNextPage];
}

#pragma mark -productinfolist delegate-
-(void)productInfoListRefreshSuccess:(ProductInfoList *)list
{
    [self stopPull];
    if ([list getCount] < 10) {
        [self setInfinitScorllHidden:YES];
    }
    [self.tableView reloadData];
}
-(void)productInfoList:(ProductInfoList *)list NextInfos:(NSRange)range
{
    [self stopInfinitScorll];
    if (range.length < 10)
    {
        [self setInfinitScorllHidden:YES];
    }
    NSMutableArray* array = [NSMutableArray array];
    for (NSUInteger i = range.location; i < range.length; i++) {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
-(void)productInfoList:(ProductInfoList *)list failureMessage:(NSString *)message
{
    [self stopPull];
    [self stopInfinitScorll];
}

#pragma mark -tableview delegate-

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productInfoList getCount];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductRelatedCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadProductInfo:[self.productInfoList getProductInfo:indexPath.row]];
    return cell;
}

@end
