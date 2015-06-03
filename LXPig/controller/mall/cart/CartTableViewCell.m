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

@interface CartTableViewCell()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *salePrice;
@property (weak, nonatomic) IBOutlet LPLabel *marketPrice;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (weak, nonatomic) IBOutlet UIButton *decreaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *increasBtn;

@end

@implementation CartTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.countBtn.layer.masksToBounds = YES;
    self.countBtn.layer.borderWidth = 1;
    self.countBtn.layer.borderColor = HEXCOLOR(@"DDDDDD").CGColor;
    self.countBtn.backgroundColor = [UIColor whiteColor];
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
    [self.countBtn setTitle:[NSString stringWithFormat:@"  %@  ",item.num] forState:UIControlStateNormal];
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
        case 3:
        {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"修改数量" message:@"购买数量最小为1，最大为9999" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
            [alertView show];
        }
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        UITextField* textField = [alertView textFieldAtIndex:0];
        if (textField.text.length > 0) {
            NSScanner* scan = [NSScanner scannerWithString:textField.text];
            int val;
            if ([scan scanInt:&val] && [scan isAtEnd]) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCell:SetNum:)]) {
                    [self.delegate cartTableViewCell:self SetNum:[textField.text integerValue]];
                }
            }
        }
        
        
    }
}

@end
