//
//  PigChart.h
//  LXPig
//
//  Created by leexiang on 15/4/27.
//
//

#import <Foundation/Foundation.h>


@class PigCart;

@protocol PigCartDelegate <NSObject>

-(void)pigCartRefresh:(PigCart*)cart;

@end

@interface CartItem : NSObject

@property (assign,nonatomic) long long keyId;
@property (strong,nonatomic) NSNumber* num;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSNumber* marketPrice;
@property (strong,nonatomic) NSNumber* salePrice;
@property (strong,nonatomic) NSString* productImage;
@property (assign,nonatomic) BOOL      selected;
@property (assign,nonatomic) BOOL      selectedToDelete;
@end

@interface CartItems : NSObject
@property (strong,nonatomic) NSNumber* enterpriseKeyId;
@property (strong,nonatomic) NSString* enterpriseName;
@property (strong,nonatomic) NSMutableArray* itemlist;
@property (strong,nonatomic) NSNumber* totalPrice;
@property (strong,nonatomic) NSNumber* totalNumber;
@property (assign,nonatomic) BOOL      selected;
@property (assign,nonatomic) BOOL      selectedToDelete;

@end



@interface PigCart : NSObject

@property (strong,nonatomic) NSMutableArray* itemsArray;
@property (weak,nonatomic) id<PigCartDelegate> delegate;

+(id)shareInstance;

-(void)refreshCartListSuccess:(void(^)(void))sucess failure:(void(^)(NSString* message))failure;
-(void)addProductToChart:(long long)productId Success:(void(^)(void))sucess failure:(void(^)(NSString* message))failure;
-(void)removeCartItemListSuccess:(void(^)(void))sucess failure:(void(^)(NSString* message))failure;

@end
