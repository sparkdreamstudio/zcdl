//
//  PSYButtonTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/16.
//
//

#import <UIKit/UIKit.h>

@class PSYButtonTableViewCell;

@protocol PSYButtonTableViewCellDelegate <NSObject>

-(void)psyButtonClickCell:(PSYButtonTableViewCell*)cell;

@end

@interface PSYButtonTableViewCell : UITableViewCell

@property (weak,nonatomic) id<PSYButtonTableViewCellDelegate> delegate;
@property (weak,nonatomic) IBOutlet UIButton* textButton;
@end
