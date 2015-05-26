//
//  InfoViewTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/11.
//
//

#import "InfoViewTableViewCell.h"

@implementation InfoViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCell:(NSDictionary*)dic
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"titlepic"]] placeholderImage:nil];
    self.title.text = dic[@"title"];
    self.content.text = dic[@"smalltext"];
    self.time.text = dic[@"newstime"];
}

@end
