//
//  MessageTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/6/9.
//
//

#import <UIKit/UIKit.h>
@class MessageTableViewCell;

@protocol MessageTableViewCellDelegate <NSObject>

-(void)messageTableViewCellDelete:(MessageTableViewCell*)cell;

@end

@interface MessageTableViewCell : UITableViewCell
@property (weak,nonatomic) id<MessageTableViewCellDelegate> delegate;
-(void)loadData:(NSDictionary*)dic;

@end
