//
//  ProductDetailTableViewController.h
//  LXPig
//
//  Created by leexiang on 15/4/21.
//
//

#import "LXPigTableVIewController.h"
@class ProductDetailViewController;
@interface ProductDetailTableViewController : LXPigTableVIewController

@property (nonatomic,assign)long long productId;
@property (nonatomic,weak) ProductDetailViewController *detailViewController;
@end
