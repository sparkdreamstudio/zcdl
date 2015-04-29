//
//  ProductInfoList.h
//  LXPig
//
//  Created by leexiang on 15/4/19.
//
//

#import <Foundation/Foundation.h>
@class ProductInfoList;
@class ProductInfo;
@protocol ProductInfoListDelegate <NSObject>

-(void)productInfoListRefreshSuccess:(ProductInfoList*)list;
-(void)productInfoList:(ProductInfoList*)list NextInfos:(NSRange)range;
-(void)productInfoList:(ProductInfoList *)list failureMessage:(NSString*)message;

@end

@interface ProductInfoList : NSObject


@property (nonatomic,weak)id<ProductInfoListDelegate> delegate;



-(void)refreshProductWithSearchKeyWord:(NSString*)keyWord enterpriseId:(NSNumber*)enterpriseId codeId:(NSNumber*)numberId orderList:(NSNumber*)orderListId;
-(void)getNextPage;

-(ProductInfo*)getProductInfo:(NSInteger)index;
-(NSInteger)getCount;
@end
