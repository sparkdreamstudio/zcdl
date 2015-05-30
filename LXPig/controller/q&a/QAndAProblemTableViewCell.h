//
//  QAndAProblemTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import <UIKit/UIKit.h>

@class QAndAProblemTableViewCell;
@protocol QAndAProblemTableViewCellDelegate <NSObject>

-(void)QAndAProblemTableViewCellUserClick:(QAndAProblemTableViewCell*)cell;

@end
@interface QAndAProblemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *usefulCntBtn;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIView  *backView;
@property (weak, nonatomic) id<QAndAProblemTableViewCellDelegate> delegate;
-(void)loadCell:(NSDictionary*)dic;

@end
