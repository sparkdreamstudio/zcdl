//
//  PSYCountIntputTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/16.
//
//

#import "PSYCountIntputTableViewCell.h"

@interface PSYCountIntputTableViewCell ()<UITextFieldDelegate>

@end

@implementation PSYCountIntputTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString* str = [[NSMutableString alloc]initWithString:textField.text];
    [str replaceCharactersInRange:range withString:string];
    if (self.delegate && [self.delegate respondsToSelector:@selector(psyCountInputCell:text:)]) {
        [self.delegate psyCountInputCell:self text:str];
    }
    return YES;
}

@end
