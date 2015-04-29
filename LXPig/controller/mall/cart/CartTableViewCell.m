//
//  CartTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/4/27.
//
//

#import "CartTableViewCell.h"
#import "LPLabel.h"
#import "PigCart.h"

@interface CartTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *salePrice;
@property (weak, nonatomic) IBOutlet LPLabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIButton *decreaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *increasBtn;

@end

@implementation CartTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(CartItem *)item WithSelected:(BOOL)selected
{
    self.checkButton.selected = selected;
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:item.productImage] placeholderImage:nil];
    self.name.text =item.name;
    self.salePrice.text = [item.salePrice stringValue];
    self.marketPrice.text = [NSString stringWithFormat:@"￥%@",item.marketPrice];
    self.count.text = [item.num stringValue];
}

-(IBAction)btnClick:(id)sender
{
    switch ([sender tag]) {
        case 0:
        {
            [sender setSelected:![sender isSelected]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCell:isCheck:)]) {
                [self.delegate cartTableViewCell:self isCheck:[sender isSelected]];
            }
            break;
        }
        case 1:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCellIncrease:)]) {
                [self.delegate cartTableViewCellIncrease:self];
            }
            break;
        }
        case 2:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCellDecrease:)]) {
                [self.delegate cartTableViewCellDecrease:self];
            }
            break;
        }
        default:
            break;
    }
}

@end
