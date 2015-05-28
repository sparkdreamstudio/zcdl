//
//  QAndAProblemTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import "QAndAProblemTableViewCell.h"

@implementation QAndAProblemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.typeLabel.layer.masksToBounds = YES;
    self.typeLabel.layer.cornerRadius = 3;
    self.usefulCnt.layer.masksToBounds = YES;
    self.usefulCnt.layer.cornerRadius = 3;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = HEXCOLOR(@"cdcdcd").CGColor;
    self.backView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCell:(NSDictionary *)dic
{
    NSLog(@"problem: %@",dic);
    self.contentLabel.text = dic[@"content"];
    self.createTime.text = dic[@"createTime"];
    self.usefulCnt.text = [NSString stringWithFormat:@" 可用%@ ",dic[@"usefulCnt"]];
    self.resultLabel.text = [dic[@"isSolve"] integerValue]==0?@"待解决":@"已解决";
    if ([dic[@"isSolve"] integerValue]==0) {
        self.resultLabel.textColor = NavigationBarColor;
    }
    else
    {
        self.resultLabel.textColor = HEXCOLOR(@"01CC1A");
    }
    if([dic[@"members"] objectForKey:@"nickName"]&&[[dic[@"members"] objectForKey:@"nickName"] length]>0)
    {
        self.userLabel.text = [NSString stringWithFormat:@"%@提问",[dic[@"members"] objectForKey:@"nickName"]];
    }
    else{
        NSMutableString* userName = [NSMutableString  stringWithString:[dic[@"members"] objectForKey:@"userName"]];
        if (userName.length > 7) {
            [userName replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        self.userLabel.text = userName;
    }
    
}

@end
