//
//  ConfirmOderHeadCell.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "ConfirmOrderHeadCell.h"
#import "ConfirmOrderTableViewController.h"
@interface ConfirmOrderHeadCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@end

@implementation ConfirmOrderHeadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadItem:(ConfirmOrderItems *)items
{
    self.name.text =items.enterpriseName;
}

@end
