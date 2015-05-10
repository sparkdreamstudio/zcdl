//
//  QAndAProblemTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import <UIKit/UIKit.h>

@interface QAndAProblemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usefulCnt;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIView  *backView;
-(void)loadCell:(NSDictionary*)dic;

@end
