//
//  ConfirmOrderCell.h
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import <UIKit/UIKit.h>

@class ConfirmOrderItem;
@class ConfirmOrderCell;
@protocol ConfirmOrderCellDelegate <NSObject>

-(void)confirmOrderCellDecrease:(ConfirmOrderCell *)cell;
-(void)confirmOrderCellIncrease:(ConfirmOrderCell *)cell;
-(void)confirmOrderCell:(ConfirmOrderCell *)cell SetNum:(NSInteger)num;

@end


@interface ConfirmOrderCell : UITableViewCell


@property (weak,nonatomic)id<ConfirmOrderCellDelegate> delegate;
-(void)loadItem:(ConfirmOrderItem*)item;


@end
