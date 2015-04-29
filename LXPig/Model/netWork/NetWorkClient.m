//
//  Manager.m
//  LXPig
//
//  Created by leexiang on 15/4/13.
//
//

#import "NetWorkClient.h"

@interface NetWorkClient ()

@property (nonatomic,strong)NSMutableDictionary* operationDic;
@property (nonatomic,strong)AFHTTPRequestOperationManager *networkManager;
@property (nonatomic,strong)UserManagerObject *userObject;

@end

@implementation NetWorkClient

static NetWorkClient* singleton = nil;

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

-(id)init{
    self = [super init];
    if (self) {
        self.operationDic = [NSMutableDictionary dictionary];
        self.networkManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
        self.networkManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    }
    return self;
}

-(BOOL)cancelWithTimeSp:(NSString*)timeSp
{
    AFHTTPRequestOperation* operation = [self.operationDic objectForKey:timeSp];
    if (operation != nil) {
        [operation cancel];
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)cancelAll
{
    for (AFHTTPRequestOperation* operation in self.operationDic) {
        [operation cancel];
    }
}

-(void)postUrl:(NSString*)urlString With:(NSDictionary*)params success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString*timeSp))failure
{
    NSString* timeSp = [Utils getTimeSp];
    AFHTTPRequestOperation* operation = [self.networkManager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
        if (result == 0) {
            NSLog(@"×××××××post request failed %@×××××××\nparams:%@\nresponse:%@",urlString,params,responseObject);
            if (failure) {
                failure(responseObject,timeSp);
            }
        }
        else
        {
            NSLog(@"√√√√√√√post request succeed %@√√√√√√√\nparams:%@\nresponse:%@",urlString,params,responseObject);
            if (sucess) {
                sucess(responseObject,timeSp);
            }
        }
        [self.operationDic removeObjectForKey:timeSp];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.operationDic removeObjectForKey:timeSp];
        if (error.code != NSURLErrorCancelled) {
            NSLog(@"√√√√√√√post request succeed %@√√√√√√√\nparams:%@\nerror:%@",urlString,params,error);
            NSDictionary *dic = @{@"message":@"请求超时"};
            if (failure) {
                failure(dic,timeSp);
            }
        }
        else
        {
            if (failure) {
                failure(nil,timeSp);
            }
        }
    }];
    [self.operationDic setObject:operation forKey:timeSp];
}

-(void)syncPostUrl:(NSString*)urlString With:(NSDictionary*)param success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    
}
@end
