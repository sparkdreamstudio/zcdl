//
//  LimitEndTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/19.
//
//

#import "LimitEndTableViewCell.h"
#import "LPLabel.h"
@implementation LimitEndTableViewCell

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
        self.description1.text = @"已销售";
        self.description2.text = @"单";
        self.description3.text = dic[@"product"][@"name"];
        self.count.text = [dic[@"salesNum"] stringValue];
        self.marketPrice.text = [dic[@"product"][@"marketPrice"] stringValue];
        self.salePrice.text = [dic[@"product"][@"salePrice"] stringValue];
        self.descriptionCount.text = [NSString stringWithFormat:@"仅剩%@",dic[@"surplusNum"]];
        self.description4.text = @"抢购结束";
    }
    else if(type == 1){
        self.description1.text = @"已销售";
        self.description2.text = @"单";
        self.description3.text = dic[@"product"][@"name"];
        self.count.text = [dic[@"salesNum"] stringValue];
        self.marketPrice.text = [dic[@"product"][@"marketPrice"] stringValue];
        self.salePrice.text = [dic[@"product"][@"salePrice"] stringValue];
        self.descriptionCount.text = @"";
        self.description4.text = @"抢购结束";
    }
    else{
        self.description1.text = @"还需";
        self.description2.text = @"份";
        self.description3.text = dic[@"product"][@"name"];
        self.count.text = [dic[@"needNum"] stringValue];
        self.marketPrice.text = [dic[@"product"][@"marketPrice"] stringValue];
        self.salePrice.text = [dic[@"product"][@"salePrice"] stringValue];
        self.descriptionCount.text = [NSString stringWithFormat:@"最低%@份成团",dic[@"num"]];
        if ([dic[@"needNum"] integerValue] < 1) {
            self.description4.text= @"组团成功";
        }
        else
        {
            self.description4.text = @"组团失败";
        }
    }
}

@end
