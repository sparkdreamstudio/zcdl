//
//  PSYCountIntputTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/16.
//
//

#import <UIKit/UIKit.h>

@class PSYCountIntputTableViewCell;

@protocol PSYCountIntputTableViewCellDelegate <NSObject>

-(void)psyCountInputCell:(PSYCountIntputTableViewCell*)cell text:(NSString*)text;

@end

@interface PSYCountIntputTableViewCell : UITableViewCell

@property (weak,nonatomic) id<PSYCountIntputTableViewCellDelegate> delegate;
@property (weak,nonatomic) IBOutlet UILabel* title;
@end
