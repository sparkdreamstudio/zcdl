//
//  UserManagerObject.h
//  LXPig
//
//  Created by leexiang on 15/4/13.
//
//

#import <Foundation/Foundation.h>

@interface UserManagerObject : NSObject

@property (strong,nonatomic) NSString* address;
@property (strong,nonatomic) NSString* province;
@property (strong,nonatomic) NSString* city;
@property (strong,nonatomic) NSString* district;
@property (strong,nonatomic) NSString* email;
@property (assign,nonatomic) long long userId;
@property (assign,nonatomic) NSInteger integral;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* nickName;
@property (strong,nonatomic) NSString* photoFile;
@property (strong,nonatomic) NSString* qq;
@property (strong,nonatomic) NSString* regTime;
@property (strong,nonatomic) NSString* sex;
@property (strong,nonatomic) NSString* userName;
@property (strong,nonatomic) NSString* sessionid;
@property (strong,nonatomic) NSString* password;



+(id)shareInstance;

-(void)regWithName:(NSString*)name AndPassWord:(NSString*)password AndVerifyCode:(NSString*)verifyCode success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;
-(void)loginWithName:(NSString*)name AndPassWord:(NSString*)password success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;
-(void)getDetailSuccess:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;
-(void)changeInfo:(NSString*)property Value:(NSString*)value Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;
-(void)autoLoginResult:(void(^)(BOOL))result;
-(void)changePassword:(NSString*)newPassword OldPassWord:(NSString*)oldPassword Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;
@end
