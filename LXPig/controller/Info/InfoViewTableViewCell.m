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
    self.imageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    self.title.text = @"";
    self.content.text = @"";
    self.time.text = @"";
    self.imageView.image = nil;
}

-(void)loadCell:(NSDictionary*)dic
{
    self.title.text = dic[@"title"];
    self.content.text = dic[@"smalltext"];
    self.time.text = dic[@"newstime"];
    [self.infoImage sd_setImageWithURL:[NSURL URLWithString:dic[@"titlepic"]] placeholderImage:[UIImage imageNamed:@"info_null"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.contentView setNeedsUpdateConstraints];
    }];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"titlepic"]] placeholderImage:[UIImage imageNamed:@"info_null"]];
    
}

@end
