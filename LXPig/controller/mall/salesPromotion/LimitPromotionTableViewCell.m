//
//  LimitPromotionTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/19.
//
//

#import "LimitPromotionTableViewCell.h"
#import "LPLabel.h"
@implementation LimitPromotionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCell:(NSDictionary *)dic WithType:(NSInteger)type
{
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"product"][@"smallImg"]] placeholderImage:nil];
    if (type == 0) {
        self.description1.text = @" 已销售";
        self.description2.text = @"单 ";
        self.description3.text = dic[@"product"][@"name"];
        self.count.text = [dic[@"salesNum"] stringValue];
        self.marketPrice.text = [dic[@"product"][@"marketPrice"] stringValue];
        self.salePrice.text = [dic[@"product"][@"salePrice"] stringValue];
        self.descriptionCount.text = [NSString stringWithFormat:@"仅剩%@",dic[@"surplusNum"]];
    }
    else if(type == 1){
        self.description1.text = @" 已销售";
        self.description2.text = @"单 ";
        self.description3.text = dic[@"product"][@"name"];
        self.count.text = [dic[@"salesNum"] stringValue];
        self.marketPrice.text = [dic[@"product"][@"marketPrice"] stringValue];
        self.salePrice.text = [dic[@"product"][@"salePrice"] stringValue];
        self.descriptionCount.text = @"";
    }
    else{
        self.description1.text = @" 还需";
        self.description2.text = @"份 ";
        self.description3.text = dic[@"product"][@"name"];
        self.count.text = [dic[@"needNum"] stringValue];
        self.marketPrice.text = [dic[@"product"][@"marketPrice"] stringValue];
        self.salePrice.text = [dic[@"product"][@"salePrice"] stringValue];
        self.descriptionCount.text = [NSString stringWithFormat:@"最低%@份成团",dic[@"num"]];
    }
    NSString* systemTimeStr = dic[@"systemTime"];
    NSString* endTimeStr = dic[@"endTime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *systemTime = [formatter dateFromString:systemTimeStr];
    NSDate *endTime = [formatter dateFromString:endTimeStr];
    NSTimeInterval aTimer = [endTime timeIntervalSinceDate:systemTime];
    
    NSInteger day = aTimer/24/3600;
    NSInteger hour = (aTimer-24*3600*day)/3600;
    NSInteger minute = (aTimer - day*24*3600 - hour*3600)/60;
    self.dayCnt.text = [NSString stringWithFormat:@"%ld",(long)day];
    self.hourCnt.text = [NSString stringWithFormat:@"%ld",(long)hour];
    self.minuteCnt.text = [NSString stringWithFormat:@"%ld",(long)minute];
}

@end
