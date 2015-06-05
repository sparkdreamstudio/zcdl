//
//  UserManagerObject.m
//  LXPig
//
//  Created by leexiang on 15/4/13.
//
//

#import "UserManagerObject.h"
#import "NetWorkClient.h"
@implementation UserManagerObject
static UserManagerObject* singleton = nil;

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
        else
        {
            return singleton;
        }
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        self.userType = -1;
        self.sessionid = @"";
    }
    return self;
}

-(void)regWithName:(NSString*)name AndPassWord:(NSString*)password AndVerifyCode:(NSString*)verifyCode success:(void(^)(NSDictionary* responseObj,NSString* timeSp))success failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSDictionary* params = @{@"action":@"reg",
                             @"userName":name,
                             @"password":password,
                             @"code":verifyCode};
    
    [[NetWorkClient shareInstance] postUrl:SERVICE_MEMBER With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self getUserInfo:[responseObj objectForKey:@"data"]];
        if(success)
        {
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"USERNAME"];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"PASSWORD"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            success(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp){
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
}

-(void)loginWithName:(NSString*)name AndPassWord:(NSString*)password success:(void(^)(NSDictionary* responseObj,NSString* timeSp))success failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSDictionary* params = @{@"action":@"login",
                             @"userName":name,
                             @"password":password};
    
    [[NetWorkClient shareInstance] postUrl:SERVICE_MEMBER With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self getUserInfo:[responseObj objectForKey:@"data"]];
        if(success)
        {
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"USERNAME"];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"PASSWORD"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.userType] forKey:@"USERTYPE"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            success(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp){
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
}

-(void)logOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERTYPE"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.address = nil;
    self.province = nil;
    self.city = nil;
    self.district = nil;
    self.email = nil;
    self.userId = -1;
    self.integral = -1;
    self.name = nil;
    self.nickName = nil;
    self.photoFile = nil;
    self.qq = nil;
    self.regTime = nil;
    self.sex = nil;
    self.userName = nil;
    self.sessionid = @"";
    self.userType = -1;
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SHOW_LOGIN object:nil];
}

-(void)getUserInfo:(NSDictionary*)dic
{
    self.address = [dic objectForKey:@"address"];
    self.province = [dic objectForKey:@"province"];
    self.city = [dic objectForKey:@"city"];
    self.district = [dic objectForKey:@"district"];
    self.email = [dic objectForKey:@"email"];
    self.userId = [[dic objectForKey:@"id"] longLongValue];
    self.integral = [[dic objectForKey:@"integral"] integerValue];
    self.name = [dic objectForKey:@"name"];
    self.nickName = [dic objectForKey:@"nickName"];
    self.photoFile = [NSString stringWithFormat:@"http:/112.74.98.66:8080%@",[dic objectForKey:@"photoPath"]];
    self.qq = [dic objectForKey:@"qq"];
    self.regTime = [dic objectForKey:@"regTime"];
    self.sex = [dic objectForKey:@"sex"];
    self.userName = [dic objectForKey:@"userName"];
    if([dic objectForKey:@"sessionid"]&&[[dic objectForKey:@"sessionid"] length] > 0)
    {
        self.sessionid = [dic objectForKey:@"sessionid"];
    }
    self.password = [dic objectForKey:@"password"];
    if ([dic objectForKey:@"type"]) {
        self.userType = [[dic objectForKey:@"type"]integerValue];
    }
    else
    {
        self.userType = 0;
    }
}

-(void)getDetailSuccess:(void(^)(NSDictionary* responseObj,NSString* timeSp))success failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSString *url;
    if (self.userType == 0) {
        url = SERVICE_MEMBER;
    }
    else
    {
        url = SERVICE_USER;
    }
    NSDictionary* params = @{@"action":@"detail",
                             @"sessionid":self.sessionid};
    [[NetWorkClient shareInstance] postUrl:url With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self getUserInfo:[responseObj objectForKey:@"data"]];
        if(success)
        {
            success(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
}

-(void)autoLoginResult:(void(^)(BOOL))result
{
    NSString* username = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"];
    NSString* password = [[NSUserDefaults standardUserDefaults]objectForKey:@"PASSWORD"];
    NSInteger type = [[[NSUserDefaults standardUserDefaults]objectForKey:@"USERTYPE"]integerValue];
    if (username == nil || password == nil)
    {
        if(result)
        {
            result(NO);
        }
    }
    else
    {
        if (type == 0) {
            [self loginWithName:username AndPassWord:password success:^(NSDictionary *responseObj, NSString *timeSp) {
                if(result)
                {
                    result(YES);
                }
            } failure:^(NSDictionary *responseObj, NSString *timeSp) {
                if(result)
                {
                    result(NO);
                }
            }];
        }
        else{
            [self loginOtherWithName:username AndPassWord:password success:^(NSDictionary *responseObj, NSString *timeSp) {
                if(result)
                {
                    result(YES);
                }
            } failure:^(NSDictionary *responseObj, NSString *timeSp) {
                if(result)
                {
                    result(NO);
                }
            }];
        }
        
    }
}

-(void)changeInfo:(NSString*)property Value:(NSString*)value Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSString *url;
    if (self.userType == 0) {
        url = SERVICE_MEMBER;
    }
    else
    {
        url = SERVICE_USER;
    }
    [[NetWorkClient shareInstance]postUrl:url With:@{@"action":@"modify",@"sessionid":self.sessionid,property:value} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self setValue:value forKey:property];
        if (sucess) {
            sucess(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
}

-(void)changePassword:(NSString*)newPassword OldPassWord:(NSString*)oldPassword Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSString *url;
    if (self.userType == 0) {
        url = SERVICE_MEMBER;
    }
    else
    {
        url = SERVICE_USER;
    }
    [[NetWorkClient shareInstance]postUrl:url With:@{@"action":@"changePwd",@"sessionid":self.sessionid,@"oriPassword":oldPassword,@"newPassword":newPassword} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [[NSUserDefaults standardUserDefaults] setObject:newPassword forKey:@"PASSWORD"];
        self.password = newPassword;
        if (sucess) {
            sucess(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
}

-(void)changeHeadImage:(UIImage*)image Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSString *url;
    if (self.userType == 0) {
        url = SERVICE_MEMBER;
    }
    else
    {
        url = SERVICE_USER;
    }
    [[NetWorkClient shareInstance]postUrl:url With:@{@"action":@"modify",@"sessionid":[[UserManagerObject shareInstance]sessionid]} AndFileName:@"photoFile" AndData:UIImagePNGRepresentation(image) success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self getUserInfo:[responseObj objectForKey:@"data"]];
        if (sucess) {
            sucess(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
}

-(void)loginOtherWithName:(NSString *)name AndPassWord:(NSString *)password success:(void (^)(NSDictionary *, NSString *))success failure:(void (^)(NSDictionary *, NSString *))failure
{
    NSDictionary* params = @{@"action":@"login",
                             @"userName":name,
                             @"password":password};
    
    [[NetWorkClient shareInstance] postUrl:SERVICE_USER With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self getUserInfo:[responseObj objectForKey:@"data"]];
        if(success)
        {
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"USERNAME"];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"PASSWORD"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.userType] forKey:@"USERTYPE"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            success(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp){
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
}

@end
