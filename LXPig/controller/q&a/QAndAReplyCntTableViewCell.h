//
//  QAndAReplyCntTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import <UIKit/UIKit.h>

@interface QAndAReplyCntTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cntLabel;
-(void)loadCell:(NSDictionary*)dic;
@end
