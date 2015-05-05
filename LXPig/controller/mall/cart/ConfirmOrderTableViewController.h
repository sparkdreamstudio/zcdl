//
//  ConfirmOrderTableViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "LXPigTableVIewController.h"


@class Address;
@interface ConfirmOrderItem : NSObject

@property (assign,nonatomic) long long keyId;
@property (strong,nonatomic) NSNumber* num;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSNumber* marketPrice;
@property (strong,nonatomic) NSNumber* salePrice;
@property (strong,nonatomic) NSString* productImage;
@end

@interface ConfirmOrderItems : NSObject
@property (strong,nonatomic) NSNumber* enterpriseKeyId;
@property (strong,nonatomic) NSString* enterpriseName;
@property (strong,nonatomic) NSMutableArray* itemlist;
@property (assign,nonatomic) NSInteger totalPrice;
@property (assign,nonatomic) NSInteger totalNumber;
@property (strong,nonatomic) NSString* note;
@property (assign,nonatomic) NSInteger isTestService;
@end

@interface ConfirmOrderTableViewController : LXPigTableVIewController
@property (strong,nonatomic) NSMutableArray* arrayProduct;
@property (assign,nonatomic) Address *address;
@end
