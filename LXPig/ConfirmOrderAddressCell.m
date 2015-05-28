//
//  ConfirmOrderAddressCell.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "ConfirmOrderAddressCell.h"
#import "AddressManager.h"
@interface ConfirmOrderAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobile;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *noAdderrssLabel;
@end

@implementation ConfirmOrderAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadAddress:(Address *)address
{
    if (address) {
        self.name.text = address.contact;
        self.mobile.text = address.tel;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",address.province,address.city,address.district,address.address];
        self.noAdderrssLabel.hidden = YES;
        self.name.hidden = NO;
        self.mobile.hidden = NO;
        self.addressLabel.hidden = NO;
    }
    else{
        self.noAdderrssLabel.hidden = NO;
        self.name.hidden = YES;
        self.mobile.hidden = YES;
        self.addressLabel.hidden = YES;
    }
    
}

@end
