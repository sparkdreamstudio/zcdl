//
//  Manager.h
//  LXPig
//
//  Created by leexiang on 15/4/13.
//
//

#import <Foundation/Foundation.h>

@interface NetWorkClient : NSObject

+(id)shareInstance;

-(BOOL)cancelWithTimeSp:(NSString*)timeSp;
-(void)cancelAll;
-(void)postUrl:(NSString*)urlString With:(NSDictionary*)param success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;
-(void)syncPostUrl:(NSString*)urlString With:(NSDictionary*)param success:(void(^)(NSDictionary* responseObj,NSString* timeSp))sucess failure:(void(^)(NSDictionary* responseObj,NSString* timeSp))failure;

-(void)postUrl:(NSString *)urlString With:(NSDictionary *)param AndFileName:(NSString*)fileName AndData:(NSData*)data  success:(void (^)(NSDictionary *, NSString *))sucess failure:(void (^)(NSDictionary *, NSString *))failure;

@end
