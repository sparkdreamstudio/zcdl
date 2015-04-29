//
//  ProductRelatedCell.h
//  LXPig
//
//  Created by leexiang on 15/4/22.
//
//

#import <UIKit/UIKit.h>

@class ProductInfo;
@class LPLabel;
@interface ProductRelatedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *praise;
@property (weak, nonatomic) IBOutlet UILabel *salePrice;
@property (weak, nonatomic) IBOutlet LPLabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;

-(void)loadProductInfo:(ProductInfo*)info;

@end
