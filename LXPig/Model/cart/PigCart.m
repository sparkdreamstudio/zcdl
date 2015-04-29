//
//  PigChart.m
//  LXPig
//
//  Created by leexiang on 15/4/27.
//
//

#import "PigCart.h"
#import "NetWorkClient.h"
#import "UserManagerObject.h"

@implementation CartItem
-(id)init
{
    self = [super init];
    if (self) {
        self.selected = YES;
        self.selectedToDelete = NO;
    }
    return self;
}
@end

@implementation CartItems

-(id)init
{
    self = [super init];
    if (self) {
        self.itemlist = [NSMutableArray array];
        self.selected = YES;
        self.selectedToDelete = NO;
    }
    return self;
}

@end

@implementation PigCart
static PigCart* singleton = nil;

+(id)shareInstance
{
    if (singleton == nil) {
        [[self alloc]init];
    }
    return singleton;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (singleton == nil) {
            singleton = [super allocWithZone:zone];
            return singleton;
        }
    }
    return nil;
}

-(void)refreshCartListSuccess:(void(^)(void))sucess failure:(void(^)(NSString* message))failure
{
    if (self.itemsArray) {
        [self.itemsArray removeAllObjects];
    }
    
    [[NetWorkClient shareInstance]postUrl:SERVICE_CART With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.itemsArray = [NSMutableArray array];
        [[responseObj objectForKey:@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CartItems *items = [[CartItems alloc] init];
            items.enterpriseName = [[obj objectForKey:@"enterprise"] objectForKey:@"name"];
            items.totalNumber = [obj objectForKey:@"totalNum"];
            items.totalPrice = [obj objectForKey:@"totalPrice"];
            [[obj objectForKey:@"list"] enumerateObjectsUsingBlock:^(id subObj, NSUInteger idx, BOOL *stop) {
                CartItem* item = [[CartItem alloc]init];
                item.name = [[subObj objectForKey:@"product"] objectForKey:@"name"];
                item.keyId = [[subObj objectForKey:@"id"] longLongValue];
                item.num = [subObj objectForKey:@"num"];
                item.productImage = [[subObj objectForKey:@"product"] objectForKey:@"smallImg"];
                item.salePrice = [[subObj objectForKey:@"product"] objectForKey:@"salePrice"];
                item.marketPrice = [[subObj objectForKey:@"product"] objectForKey:@"marketPrice"];
                [items.itemlist addObject:item];
            }];
            [self.itemsArray addObject:items];
            if (sucess) {
                sucess();
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(pigCartRefresh:)]) {
                [self.delegate pigCartRefresh:self];
            }
        }];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (failure) {
            failure([responseObj objectForKey:@"message"]);
        }
    }];
}

-(void)addProductToChart:(long long)productId Success:(void(^)(void))sucess failure:(void(^)(NSString* message))failure
{
    [[NetWorkClient shareInstance] postUrl:SERVICE_CART With:@{@"action":@"save",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"num":@"1",@"productId":[NSNumber numberWithLongLong:productId]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        if (sucess) {
            sucess();
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (failure) {
            failure([responseObj objectForKey:@"message"]);
        }
    }];
}
-(void)removeCartItemListSuccess:(void(^)(void))sucess failure:(void(^)(NSString* message))failure
{
    __block NSString *productIds = @"";
    [self.itemsArray enumerateObjectsUsingBlock:^(CartItems* obj, NSUInteger idx, BOOL *stop) {
        [obj.itemlist enumerateObjectsUsingBlock:^(CartItem* obj, NSUInteger idx, BOOL *stop) {
            if (obj.selectedToDelete == YES) {
                if (productIds.length == 0) {
                    productIds = [NSString stringWithFormat:@"%lld",obj.keyId];
                }
                else
                {
                    productIds = [productIds stringByAppendingString:[NSString stringWithFormat:@",%lld",obj.keyId]];
                }
            }
        }];
    }];
    [[NetWorkClient shareInstance]postUrl:SERVICE_CART With:@{@"action":@"delete",@"sessionid":[[UserManagerObject shareInstance] sessionid],@"productIds":productIds} success:^(NSDictionary *responseObj, NSString *timeSp) {
        if (sucess) {
            sucess();
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (failure) {
            failure([responseObj objectForKey:@"message"]);
        }
    }];
}

-(void)setChartItem:(long long)productId number:(NSInteger)count
{
    
}

@end
