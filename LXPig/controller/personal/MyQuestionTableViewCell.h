//
//  MyQuestionTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import <UIKit/UIKit.h>

@interface MyQuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
-(void)loadCell:(NSDictionary*)dic;
@end
