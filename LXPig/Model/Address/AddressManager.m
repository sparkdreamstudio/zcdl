//
//  AddressManager.m
//  LXPig
//
//  Created by leexiang on 15/4/30.
//
//

#import "AddressManager.h"
#import "NetWorkClient.h"
@implementation Address



@end

@interface AddressManager ()
@property (nonatomic,strong) NSMutableArray* addressArray;
@end

@implementation AddressManager
static AddressManager* singleton = nil;
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


-(void)getAddressArraySuccess:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    [[NetWorkClient shareInstance]postUrl:SERVICE_SHIPADDRESS With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid]} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.addressArray = [self parseData:[responseObj objectForKey:@"data"]];
        if (sucess) {
            sucess(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
}


-(NSMutableArray*)parseData:(NSArray*)array
{
    NSMutableArray* mutableArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        Address *address = [[Address alloc]init];
        address.keyId = [[obj valueForKey:@"id"]longLongValue];
        address.contact = [obj valueForKey:@"contact"];
        address.tel = [obj valueForKey:@"tel"];
        address.zipcode = [obj valueForKey:@"ziocode"];
        address.province = [obj valueForKey:@"province"];
        address.city = [obj valueForKey:@"city"];
        address.district = [obj valueForKey:@"district"];
        address.isDefault = [[obj valueForKey:@"isDefault"] integerValue];
        [mutableArray addObject:address];
    }];
    return mutableArray;
}

@end
