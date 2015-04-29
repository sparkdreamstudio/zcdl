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
    }
    return nil;
}

-(void)regWithName:(NSString*)name AndPassWord:(NSString*)password AndVerifyCode:(NSString*)verifyCode success:(void(^)(NSDictionary* responseObj,NSString* timeSp))success failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSDictionary* params = @{@"action":@"reg",
                             @"userName":name,
                             @"password":password};
    
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
            [[NSUserDefaults standardUserDefaults]synchronize];
            success(responseObj,timeSp);
        }
    } failure:^(NSDictionary *responseObj, NSString *timeSp){
        if (failure) {
            failure(responseObj,timeSp);
        }
    }];
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
    self.photoFile = [dic objectForKey:@"photoPath"];
    self.qq = [dic objectForKey:@"qq"];
    self.regTime = [dic objectForKey:@"regTime"];
    self.sex = [dic objectForKey:@"sex"];
    self.userName = [dic objectForKey:@"userName"];
    self.sessionid = [dic objectForKey:@"sessionid"];
    self.password = [dic objectForKey:@"password"];
}

-(void)getDetailSuccess:(void(^)(NSDictionary* responseObj,NSString* timeSp))success failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    NSDictionary* params = @{@"action":@"detail",
                             @"sessionid":self.sessionid};
    [[NetWorkClient shareInstance] postUrl:SERVICE_MEMBER With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
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
    if (username == nil || password == nil)
    {
        if(result)
        {
            result(NO);
        }
    }
    else
    {
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
}

-(void)changeInfo:(NSString*)property Value:(NSString*)value Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure
{
    [[NetWorkClient shareInstance]postUrl:SERVICE_MEMBER With:@{@"action":@"modify",@"sessionid":self.sessionid,property:value} success:^(NSDictionary *responseObj, NSString *timeSp) {
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
    [[NetWorkClient shareInstance]postUrl:SERVICE_MEMBER With:@{@"action":@"changePwd",@"sessionid":self.sessionid,@"oriPassword":oldPassword,@"newPassword":newPassword} success:^(NSDictionary *responseObj, NSString *timeSp) {
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

@end
