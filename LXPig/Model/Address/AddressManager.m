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

-(id)init
{
    self = [super init];
    if (self) {
        self.keyId = -1;
        self.contact = @"";
        self.tel = @"";
//        self.zipcode = @"";
        self.province = @"";
        self.city = @"";
        self.district =@"";
        self.address = @"";
        self.isDefault = 0;
    }
    return self;
}

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


-(id)init
{
    if (self=[super init]) {
        self.addressArray = [NSMutableArray array];
    }
    return self;
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

-(void)setAddressInfo:(Address*)address Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"save",@"sessionid":[[UserManagerObject shareInstance]sessionid]}];
    if (address.keyId != -1) {
        [params setValue:[NSNumber numberWithLongLong:address.keyId] forKey:@"id"];
        [params setValue:@"modify" forKey:@"action"];
    }
    [params setValue:address.contact forKey:@"contact"];
    [params setValue:address.tel forKey:@"tel"];
//    [params setValue:address.zipcode forKey:@"zipcode"];
    [params setValue:address.province forKey:@"province"];
    [params setValue:address.city forKey:@"city"];
    [params setValue:address.district forKey:@"district"];
    [params setValue:address.address forKey:@"address"];
    [params setValue:[NSNumber numberWithInteger:address.isDefault] forKey:@"isDefault"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_SHIPADDRESS With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        if (address.keyId == -1) {
            address.keyId = [[[responseObj valueForKey:@"data"] valueForKey:@"id"]longLongValue];
            
            if(address.isDefault == 0)
            {
                [self.addressArray addObject:address];
            }
            else
            {
                for (Address* addr in self.addressArray) {
                    addr.isDefault = 0;
                }
                [self.addressArray insertObject:address atIndex:0];
            }
        }
        else
        {
            __block NSInteger index = -1;
            [self.addressArray enumerateObjectsUsingBlock:^(Address* obj, NSUInteger idx, BOOL *stop) {
                if(obj.keyId == address.keyId)
                {
                    index = idx;
//                    obj.contact = [responseObj valueForKey:@"contact"];
//                    obj.tel = [responseObj valueForKey:@"tel"];
//                    obj.zipcode = [responseObj valueForKey:@"ziocode"];
//                    obj.province = [responseObj valueForKey:@"province"];
//                    obj.city = [responseObj valueForKey:@"city"];
//                    obj.district = [responseObj valueForKey:@"district"];
//                    obj.address = [responseObj valueForKey:@"address"];
//                    obj.isDefault = [[responseObj valueForKey:@"isDefault"] integerValue];
                    *stop = YES;
                }
                
            }];
            if (index >= 0) {
                if(address.isDefault == 0)
                {
                    [self.addressArray replaceObjectAtIndex:index withObject:address];
                }
                else
                {
                    [self.addressArray removeObjectAtIndex:index];
                    for (Address* addr in self.addressArray) {
                        addr.isDefault = 0;
                    }
                    [self.addressArray insertObject:address atIndex:0];
                }
                
            }
            
        }
        
        if (sucess) {
            sucess(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
}

-(void)deleteAddress:(Address*)address Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"delete",@"sessionid":[[UserManagerObject shareInstance]sessionid]}];
    
    [params setValue:[NSNumber numberWithLongLong:address.keyId] forKey:@"id"];

    [[NetWorkClient shareInstance]postUrl:SERVICE_SHIPADDRESS With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self.addressArray removeObject:address];
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
//        address.zipcode = [obj valueForKey:@"zipcode"];
        address.province = [obj valueForKey:@"province"];
        address.city = [obj valueForKey:@"city"];
        address.district = [obj valueForKey:@"district"];
        address.address = [obj valueForKey:@"address"];
        address.isDefault = [[obj valueForKey:@"isDefault"] integerValue];
        [mutableArray addObject:address];
    }];
    return mutableArray;
}

@end
