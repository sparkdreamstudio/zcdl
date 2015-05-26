//
//  InfoViewTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/11.
//
//

#import <UIKit/UIKit.h>

@interface InfoViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

-(void)loadCell:(NSDictionary*)dic;

@end
