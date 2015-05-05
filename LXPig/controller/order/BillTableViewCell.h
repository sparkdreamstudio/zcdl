//
//  BillTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/4.
//
//

#import <UIKit/UIKit.h>

@class BillTableViewCell;

@protocol BillTableViewCellDelegate <NSObject>

-(void)billCellClick:(BillTableViewCell*)cell WithBillButton:(UIButton*)button;
-(void)billCellClick:(BillTableViewCell*)cell WithAddButton:(UIButton*)button;
@end

@interface BillTableViewCell : UITableViewCell

@property (weak,nonatomic) id<BillTableViewCellDelegate> delegate;

-(void)loadCell:(NSArray*)paperInfo WithAddButton:(BOOL)showAdd;

@end
