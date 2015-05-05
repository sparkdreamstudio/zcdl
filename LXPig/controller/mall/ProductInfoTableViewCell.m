//
//  ProductInfoTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/4/20.
//
//

#import "ProductInfoTableViewCell.h"
#import "ProductInfo.h"
#import "LPLabel.h"
@implementation ProductInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.marketPriceLable.strikeThroughEnabled = YES;
    self.marketPriceLable.strikeThroughColor = self.marketPriceLable.textColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    [self.productImageView setImage:[UIImage new]];
    self.companyNameLabel.text = @"";
    self.productName.text = @"";
    self.marketPriceLable.text = @"";
    self.salePriceLabel.text = @"";
    self.praiseLabel.text = @"";
    self.saleCount.text =@"";
}
-(void)loadProductInfo:(ProductInfo*)info
{
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:info.smallImg] placeholderImage:nil completed:nil];
    self.companyNameLabel.text = info.enterprise.name;
    self.productName.text = info.name;
    self.marketPriceLable.text = [NSString stringWithFormat:@"￥%ld",(long)info.marketPrice];
    self.salePriceLabel.text = [NSString stringWithFormat:@"%ld",(long)info.salePrice];
    self.saleCount.text = [NSString stringWithFormat:@"%ld",(long)info.orderCnt];
    self.praiseLabel.text = info.praise;
}
@end
