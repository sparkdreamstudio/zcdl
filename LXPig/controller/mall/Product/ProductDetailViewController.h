//
//  ProductDetailViewController.h
//  LXPig
//
//  Created by leexiang on 15/4/21.
//
//

#import "LXPigTableVIewController.h"
@class ProductInfo;
@interface ProductDetailViewController : LxPigViewController
@property (strong,nonatomic)ProductInfo* info;
@property (assign, nonatomic)NSInteger type;
@end
