//
//  QAndAReplyTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import <UIKit/UIKit.h>

@interface QAndAReplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *replyUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyTime;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *isAcceptLabel;

-(void)loadCell:(NSDictionary*)dic;
@end
