//
//  ProductCommentCell.h
//  LXPig
//
//  Created by leexiang on 15/4/23.
//
//

#import <UIKit/UIKit.h>

@interface ProductCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *star0;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *pigclass;
@property (weak, nonatomic) IBOutlet UILabel *replyContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* commentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* replyContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* seperatorHeight;
@end
