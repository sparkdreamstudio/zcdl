//
//  ConfirmOrderBottomCell.h
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import <UIKit/UIKit.h>

@class ConfirmOrderBottomCell;
@class ConfirmOrderItems;
@protocol ConfirmOrderBottomCellDelegate <NSObject>

-(void)ConfirmOrderBottomCell:(ConfirmOrderBottomCell*)cell theString:(NSString*)string;
-(void)ConfirmOrderBottomCell:(ConfirmOrderBottomCell*)cell isTest:(BOOL)test;
@end

@interface ConfirmOrderBottomCell : UITableViewCell
@property (weak,nonatomic) id<ConfirmOrderBottomCellDelegate> delegate;
-(void)loadItem:(ConfirmOrderItems*)items;
@end
