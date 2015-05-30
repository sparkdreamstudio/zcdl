//
//  ProductInfoList.m
//  LXPig
//
//  Created by leexiang on 15/4/19.
//
//

#import "ProductInfoList.h"
#import "NetWorkClient.h"
#import "ProductInfo.h"
@interface ProductInfoList ()

@property (nonatomic,assign)    NSInteger currentPage;
@property (nonatomic,strong)     NSString* keyWord;
@property (nonatomic,strong)    NSNumber* enterpriseId;
@property (nonatomic,strong)    NSNumber* codeId;
@property (nonatomic,strong)    NSNumber* orderList;

@property (nonatomic,strong)    NSMutableArray* infos;


@end

@implementation ProductInfoList
static ProductInfoList* singleton = nil;




-(void)refreshProductWithSearchKeyWord:(NSString*)keyWord enterpriseId:(NSNumber*)enterpriseId codeId:(NSNumber*)codeId orderList:(NSNumber*)orderListId
{
    _currentPage = 1;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:[NSNumber numberWithInteger:_currentPage] forKey:@"currentPageNo"];
    [params setValue:@"10" forKey:@"pageSize"];
    if (keyWord) {
        [params setValue:keyWord forKey:@"keyword"];
        _keyWord = keyWord;
    }
    if (enterpriseId) {
        [params setValue:[enterpriseId stringValue] forKey:@"enterpriseId"];
        _enterpriseId = enterpriseId;
    }
    if (codeId) {
        [params setValue:[codeId stringValue] forKey:@"codeId"];
        _codeId = codeId;
    }
    if (orderListId) {
        [params setValue:[orderListId stringValue] forKey:@"orderlist"];
        _orderList = orderListId;
    }
    __weak ProductInfoList* weakself = self;
    [[NetWorkClient shareInstance]postUrl:SERVICE_PRODUCT With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        weakself.infos = [weakself getDataArray:[responseObj objectForKey:@"data"]];
        if (weakself.delegate) {
            if ([weakself.delegate respondsToSelector:@selector(productInfoListRefreshSuccess:)]) {
                
                [weakself.delegate productInfoListRefreshSuccess:weakself];
            }
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(productInfoList:failureMessage:)]) {
                [self.delegate productInfoList:self failureMessage:[responseObj objectForKey:@"message"]];
            }
        }
    }];
}
-(void)getNextPage
{
    _currentPage++;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:[NSNumber numberWithInteger:_currentPage] forKey:@"currentPageNo"];
    [params setValue:@"10" forKey:@"pageSize"];
    if (_keyWord) {
        [params setValue:_keyWord forKey:@"keyword"];
    }
    if (_enterpriseId) {
        [params setValue:[_enterpriseId stringValue] forKey:@"enterpriseId"];
    }
    if (_codeId) {
        [params setValue:[_codeId stringValue] forKey:@"codeId"];
    }
    if (_orderList) {
        [params setValue:[_orderList stringValue] forKey:@"orderlist"];
    }
    __weak ProductInfoList* weakself = self;
    [[NetWorkClient shareInstance]postUrl:SERVICE_PRODUCT With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        NSArray* array = [self getDataArray:[responseObj objectForKey:@"data"]];
        if(array.count == 0)
        {
            weakself.currentPage--;
            return ;
        }
        [weakself.infos addObjectsFromArray:array];
        if (weakself.delegate) {
            if ([weakself.delegate respondsToSelector:@selector(productInfoListRefreshSuccess:)]) {
                
                [weakself.delegate productInfoList:self NextInfos:NSMakeRange(weakself.infos.count-array.count, array.count)];
            }
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        weakself.currentPage--;
        if (weakself.delegate) {
            if ([weakself.delegate respondsToSelector:@selector(productInfoList:failureMessage:)]) {
                [weakself.delegate productInfoList:weakself failureMessage:[responseObj objectForKey:@"message"]];
            }
        }
    }];
}

-(NSMutableArray*)getDataArray:(NSArray*)dataArray
{
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dic in dataArray) {
        ProductInfo* info = [[ProductInfo alloc]init];
        info.keyId = [[dic objectForKey:@"id"]longLongValue];
        info.enterprise = [[EnterpriseInfo alloc]init];
//        for (NSDictionary* enterDic in [dic objectForKey:@"enterprise"]) {
            info.enterprise.keyId = [[[dic objectForKey:@"enterprise"] objectForKey:@"id"]longLongValue];
            info.enterprise.name = [[dic objectForKey:@"enterprise"] objectForKey:@"name"];
            info.enterprise.tel = [[dic objectForKey:@"enterprise"] objectForKey:@"tel"];
            info.enterprise.fax = [[dic objectForKey:@"enterprise"] objectForKey:@"fax"];
            info.enterprise.address = [[dic objectForKey:@"enterprise"] objectForKey:@"address"];
            info.enterprise.intro = [[dic objectForKey:@"enterprise"] objectForKey:@"intro"];
//        }
        info.name = [dic objectForKey:@"name"];
        info.marketPrice = [[dic objectForKey:@"marketPrice"] integerValue];
        info.salePrice = [[dic objectForKey:@"salePrice"]integerValue];
        info.smallImg = [dic objectForKey:@"smallImg"];
        info.unit = [dic objectForKey:@"unit"];
        info.intro = [dic objectForKey:@"intro"];
        info.status = [[dic objectForKey:@"status"] integerValue];
        info.seq = [[dic objectForKey:@"seq"] integerValue];
        info.praise =[dic objectForKey:@"praise"];
        info.orderCnt = [[dic objectForKey:@"orderCnt"] integerValue];
        [array addObject:info];
    }
    return array;
}
-(ProductInfo*)getProductInfo:(NSInteger)index
{
    if (index >= self.infos.count) {
        return nil;
    }
    else{
        return self.infos[index];
    }
}

-(NSInteger)getCount
{
    return self.infos.count;
}
@end
