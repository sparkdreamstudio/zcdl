//
//  ProductInfo.h
//  LXPig
//
//  Created by leexiang on 15/4/19.
//
//

#import <Foundation/Foundation.h>
@interface EnterpriseInfo : NSObject

@property (nonatomic,assign) long long keyId;//主键id
@property (nonatomic,strong) NSString* name;// 企业名称
@property (nonatomic,strong) NSString* tel;// 联系电话
@property (nonatomic,strong) NSString* fax;// 传真
@property (nonatomic,strong) NSString* address;// 地址
@property (nonatomic,strong) NSString* intro;// 详细介绍(html格式)

@end

@interface ProductInfo : NSObject

@property (nonatomic,assign) long long keyId;//主键id
@property (nonatomic,strong) EnterpriseInfo* enterprise;//所属企业(具体见企业列表实体类)
@property (nonatomic,strong) NSString* name;//名称
@property (nonatomic,assign) NSInteger marketPrice;//市场价
@property (nonatomic,assign) NSInteger salePrice;//销售价
@property (nonatomic,strong) NSString* smallImg;//列表小图
@property (nonatomic,strong) NSString* unit;//单位
@property (nonatomic,strong) NSString* intro;// 详细介绍(html格式)
@property (nonatomic,assign) NSInteger status;//状态 0上架  1下架
@property (nonatomic,assign) NSInteger seq;//排序
@property (nonatomic,strong) NSNumber* praise;//好评率
@property (nonatomic,assign) NSInteger orderCnt;//已售笔数

@end


