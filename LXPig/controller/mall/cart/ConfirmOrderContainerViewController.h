//
//  ConfirmOrderContainerViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "LxPigViewController.h"
@class ProductInfo;
@interface ConfirmOrderContainerViewController : LxPigViewController

@property (assign,nonatomic) ProductInfo* qianGouProduct;
-(void)reloadQiangGouPrice:(NSInteger)price;
@end
