//
//  ConfirmOrderBottomCell.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "ConfirmOrderBottomCell.h"
#import "ConfirmOrderTableViewController.h"
@interface ConfirmOrderBottomCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemCount;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (weak, nonatomic) IBOutlet UIButton *testButton;
@end

@implementation ConfirmOrderBottomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadItem:(ConfirmOrderItems *)items
{
    self.itemCount.text = [NSString stringWithFormat:@"%ld",(long)items.totalNumber];
    self.totalPrice.text = [NSString stringWithFormat:@"￥%ld",(long)items.totalPrice];
    [self.testButton setSelected:items.isTestService];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *tempString = [NSMutableString stringWithString:textField.text];
    [tempString replaceCharactersInRange:range withString:string];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ConfirmOrderBottomCell:theString:)]) {
        [self.delegate ConfirmOrderBottomCell:self theString:tempString];
    }
    return YES;
}

-(IBAction)textBtnClick:(UIButton*)sender
{
    [sender setSelected:!sender.isSelected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ConfirmOrderBottomCell:isTest:)]) {
        [self.delegate ConfirmOrderBottomCell:self isTest:sender.isSelected];
    }
}
@end
