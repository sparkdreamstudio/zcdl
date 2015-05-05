//
//  AddressManageTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/4/30.
//
//

#import "AddressManageTableViewCell.h"
#import "AddressManager.h"
@implementation AddressManageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}

-(void)loadAddress:(Address*)address
{
    self.nameLabel.text = address.contact;
    self.mobile.text = address.tel;
    NSString *strAddress = [NSString stringWithFormat:@"%@%@%@%@",address.province,address.city,address.district,address.address];
    self.address.text = address.isDefault == 0? strAddress:[NSString stringWithFormat:@"[默认]%@",strAddress];
    
    self.selectedImageView.hidden = !address.isDefault;
    if (address.isDefault != 0) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [self setBackgroundColor:[UIColor colorWithRed:0xf3/255.f green:0xf3/255.f blue:0xf3/255.f alpha:1]];
    }
}


@end
