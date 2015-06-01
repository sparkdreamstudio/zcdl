//
//  ProductInfoTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/4/20.
//
//

#import <UIKit/UIKit.h>

@class ProductInfo;
@class LPLabel;

@interface ProductInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet LPLabel *marketPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleCount;
@property (weak, nonatomic) IBOutlet UILabel* zeroGetProduct;

@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
-(void)loadProductInfo:(ProductInfo*)info;
@end
