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
@interface ConfirmOrderCell ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet LPLabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIButton*countBtn;
@property (weak, nonatomic) ConfirmOrderItem* item;

@end

@implementation ConfirmOrderCell

- (void)awakeFromNib {
    // Initialization code
    self.countBtn.layer.masksToBounds = YES;
    self.countBtn.layer.borderColor = HEXCOLOR(@"DDDDDD").CGColor;
    self.countBtn.layer.borderWidth = 1;
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
    if (self.countBtn) {
        [self.countBtn setTitle:[NSString stringWithFormat:@"%@",self.item.num] forState:UIControlStateNormal];
    }
}

-(IBAction)additemCount:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(confirmOrderCellIncrease:)])
    {
        [self.delegate confirmOrderCellIncrease:self];
    }
//    if (self.item.num.integerValue == 9999) {
//        return;
//    }
//    self.item.num = [NSNumber numberWithInteger:self.item.num.integerValue+1];
//    [self.countBtn setTitle:[NSString stringWithFormat:@"%@",self.item.num] forState:UIControlStateNormal];
}

-(IBAction)decreaseItemCount:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmOrderCellDecrease:)]) {
        [self.delegate confirmOrderCellDecrease:self];
    }
//    if (self.item.num.integerValue == 1) {
//        return;
//    }
//    self.item.num = [NSNumber numberWithInteger:self.item.num.integerValue-1];
//    [self.countBtn setTitle:[NSString stringWithFormat:@"%@",self.item.num] forState:UIControlStateNormal];
}

-(IBAction)setItemCount:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"修改数量" message:@"购买数量最小为1，最大为9999" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        UITextField* textField = [alertView textFieldAtIndex:0];
        if (textField.text.length > 0) {
            NSScanner* scan = [NSScanner scannerWithString:textField.text];
            int val;
            if ([scan scanInt:&val] && [scan isAtEnd]) {
                NSInteger num = [textField.text integerValue];
                if (self.delegate && [self.delegate respondsToSelector:@selector(confirmOrderCell:SetNum:)]) {
                    [self.delegate confirmOrderCell:self SetNum:num];
                }
//                if (num >= 1 && num <= 9999) {
//                    self.item.num = @(num);
//                    [self.countBtn setTitle:[NSString stringWithFormat:@"%@",self.item.num] forState:UIControlStateNormal];
//                }
            }
        }
        
        
    }
}

@end
