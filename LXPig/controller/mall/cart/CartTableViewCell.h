//
//  CartTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/4/27.
//
//

#import <UIKit/UIKit.h>

@class CartItem;
@class CartTableViewCell;

@protocol CartTableViewCellDelegate <NSObject>

-(void)cartTableViewCell:(CartTableViewCell*)cell isCheck:(BOOL)check;
-(void)cartTableViewCellDecrease:(CartTableViewCell *)cell;
-(void)cartTableViewCellIncrease:(CartTableViewCell *)cell;
@end

@interface CartTableViewCell : UITableViewCell

@property (weak, nonatomic) id<CartTableViewCellDelegate> delegate;
-(void)loadData:(CartItem*)item WithSelected:(BOOL)selected;

@end
