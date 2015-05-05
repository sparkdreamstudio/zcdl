//
//  ProductRelatedCell.m
//  LXPig
//
//  Created by leexiang on 15/4/22.
//
//

#import "ProductRelatedCell.h"
#import "ProductInfo.h"
#import "LPLabel.h"
@implementation ProductRelatedCell

-(void)awakeFromNib
{

}

-(void)prepareForReuse
{
    [self.productImage setImage:[UIImage new]];
    self.productName.text = @"";
    self.marketPrice.text = @"";
    self.salePrice.text = @"";
    self.praise.text = @"";
    self.orderCount.text = @"";
}
-(void)loadProductInfo:(ProductInfo*)info
{
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:info.smallImg] placeholderImage:nil completed:nil];
    self.productName.text = info.name;
    self.marketPrice.text = [NSString stringWithFormat:@"￥%ld",(long)info.marketPrice];
    self.salePrice.text = [NSString stringWithFormat:@"%ld",(long)info.salePrice];
    self.praise.text = info.praise;
    self.orderCount.text = [NSString stringWithFormat:@"%ld",(long)info.orderCnt];
}
@end
