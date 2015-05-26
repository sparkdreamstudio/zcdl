//
//  MyQuestionTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import "MyQuestionTableViewCell.h"

@interface MyQuestionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *isSolveLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *replyCnt;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation MyQuestionTableViewCell

- (void)awakeFromNib {
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = HEXCOLOR(@"cdcdcd").CGColor;
    self.backView.layer.borderWidth = 1;
    
    self.typeLabel.layer.masksToBounds = YES;
    self.typeLabel.layer.cornerRadius = 2;
    
    self.replyCnt.layer.masksToBounds = YES;
    self.replyCnt.layer.borderColor = HEXCOLOR(@"dddddd").CGColor;
    self.replyCnt.layer.borderWidth = 1;
    self.replyCnt.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCell:(NSDictionary*)dic
{
    self.content.text = dic[@"content"];
    self.time.text = dic[@"createTime"];
    if([dic[@"isSolve"]integerValue]==0)
    {
        self.isSolveLabel.text = @"未解决";
        self.isSolveLabel.textColor = HEXCOLOR(@"d21a23");
    }
    else
    {
        self.isSolveLabel.text = @"已解决";
        self.isSolveLabel.textColor = HEXCOLOR(@"01cc1a");
    }
    self.replyCnt.text = [NSString stringWithFormat:@" 查看回复%@ ",dic[@"replyCnt"]];
}
@end
