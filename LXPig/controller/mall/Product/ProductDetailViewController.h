//
//  ProductDetailViewController.h
//  LXPig
//
//  Created by leexiang on 15/4/21.
//
//

#import "LXPigTableVIewController.h"
@class ProductInfo;
@class EnterpriseDetailController;
@interface ProductDetailViewController : LxPigViewController
@property (strong,nonatomic)ProductInfo* info;
@property (assign, nonatomic)NSInteger type;
@property (weak, nonatomic)EnterpriseDetailController* enterPriseController;
@end
