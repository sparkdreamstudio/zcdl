//
//  ConfirmOrderCell.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "ConfirmOrderCell.h"
#import "LPLabel.h"
#import "ConfirmOrderTableViewController.h"
@interface ConfirmOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet LPLabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) ConfirmOrderItem* item;

@end

@implementation ConfirmOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadItem:(ConfirmOrderItem *)item
{
    self.item = item;
    self.name.text =item.name;
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:item.productImage] placeholderImage:nil];
    self.salePriceLabel.text = [item.salePrice stringValue];
    self.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@",item.marketPrice];
    self.count.text = [NSString stringWithFormat:@"%@",item.num];
}

-(IBAction)additemCount:(id)sender
{
    self.item.num = [NSNumber numberWithInteger:self.item.num.integerValue-1];
    self.count.text = [NSString stringWithFormat:@"x%@",self.item.num];
}

-(IBAction)decreaseItemCount:(id)sender
{
    self.item.num = [NSNumber numberWithInteger:self.item.num.integerValue-1];
    self.count.text = [NSString stringWithFormat:@"x%@",self.item.num];
}

@end
