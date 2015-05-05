//
//  AddressManager.h
//  LXPig
//
//  Created by leexiang on 15/4/30.
//
//

#import <Foundation/Foundation.h>
@interface Address : NSObject

@property (nonatomic,assign)long long keyId;
@property (nonatomic,strong) NSString* contact;
@property (nonatomic,strong) NSString* tel;
@property (nonatomic,strong) NSString* zipcode;
@property (nonatomic,strong) NSString* province;
@property (nonatomic,strong) NSString* city;
@property (nonatomic,strong) NSString* district;
@property (nonatomic,strong) NSString* address;
@property (nonatomic,assign) NSInteger isDefault;

@end
@interface AddressManager : NSObject

@property (nonatomic,readonly) NSMutableArray* addressArray;
+(id)shareInstance;
-(void)getAddressArraySuccess:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;
-(void)setAddressInfo:(Address*)address Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;
-(void)deleteAddress:(Address*)address Success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;
@end
