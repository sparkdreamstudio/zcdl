//
//  MyQuestionDetailTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import "MyQuestionDetailTableViewCell.h"

@interface MyQuestionDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *answerUser;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

@end

@implementation MyQuestionDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)acceptBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionDetailCell:AcceptBtnClick:)]) {
        [self.delegate questionDetailCell:self AcceptBtnClick:sender];
    }
}

-(void)loadCell:(NSDictionary*)dic AndIsSolve:(NSInteger)solve
{
    if (solve == 0) {
        self.acceptBtn.hidden = NO;
    }
    else
    {
        self.acceptBtn.hidden = YES;
    }
    self.answerUser.text = dic[@"members"][@"name"];
    self.content.text = dic[@"content"];
    self.time.text = dic[@"createTime"];
}
@end
