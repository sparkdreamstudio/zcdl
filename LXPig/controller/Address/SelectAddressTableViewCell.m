//
//  SelectAddressTableViewCell.m
//  LXPig
//
//  Created by 李响 on 15/5/28.
//
//

#import "SelectAddressTableViewCell.h"
#import "AddressManager.h"
@implementation SelectAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectedImageView.hidden = !selected;
    if (selected) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [self setBackgroundColor:[UIColor colorWithRed:0xf3/255.f green:0xf3/255.f blue:0xf3/255.f alpha:1]];
    }
}

-(void)loadAddress:(Address*)address
{
    self.nameLabel.text = address.contact;
    self.mobile.text = address.tel;
    NSString *strAddress = [NSString stringWithFormat:@"%@%@%@%@",address.province,address.city,address.district,address.address];
    self.address.text = address.isDefault == 0? strAddress:[NSString stringWithFormat:@"[默认]%@",strAddress];
}


@end
