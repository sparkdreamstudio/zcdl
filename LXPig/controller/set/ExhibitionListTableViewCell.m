//
//  ExhibitionListTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import "ExhibitionListTableViewCell.h"

@interface ExhibitionListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *roundedView;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeWidth;

@end
@implementation ExhibitionListTableViewCell

- (void)awakeFromNib {
    
    self.roundedView.layer.borderColor = [UIColor colorWithRed:0xcd/255.f green:0xcd/255.f blue:0xcd/255.f alpha:1].CGColor;
    self.roundedView.layer.borderWidth = 1;
    self.typeLabel.layer.masksToBounds = YES;
    self.typeLabel.layer.borderColor = self.typeLabel.textColor.CGColor;
    self.typeLabel.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(NSDictionary*)data
{
    NSString *beginString = [data objectForKey:@"beginDate"];
    NSString *endString = [data objectForKey:@"endDate"];
    NSArray* beginArray = [beginString componentsSeparatedByString:@"-"];
    NSArray* endArray = [endString componentsSeparatedByString:@"-"];
    self.areaLabel.text = [data objectForKey:@"area"];
    self.timeRangeLabel.text = [NSString stringWithFormat:@"%@.%@-%@.%@",beginArray[1],beginArray[2],endArray[1],endArray[2]];
    self.nameLabel.text = [data objectForKey:@"title"];
    self.addressLabel.text = [data objectForKey:@"address"];
    self.feeLabel.text = [NSString stringWithFormat:@"会费：%@",[data objectForKey:@"charge"]];
    self.typeLabel.text = [[data objectForKey:@"type"] objectForKey:@"name"];
    self.typeWidth.constant = [Utils getSizeOfString:[[data objectForKey:@"type"] objectForKey:@"name"] WithSize:CGSizeMake(SCREEN_WIDTH, 1) AndSystemFontSize:13  ].width+5;
}

@end
