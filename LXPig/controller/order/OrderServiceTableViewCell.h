//
//  OrderServiceTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/8.
//
//

#import <UIKit/UIKit.h>

@interface OrderServiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@end
