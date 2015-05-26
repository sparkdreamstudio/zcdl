//
//  MyQuestionDetailTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import <UIKit/UIKit.h>

@class MyQuestionDetailTableViewCell;
@protocol MyQuestionDetailTableViewCellDelegate <NSObject>

-(void)questionDetailCell:(MyQuestionDetailTableViewCell*)cell AcceptBtnClick:(UIButton*)btn;

@end

@interface MyQuestionDetailTableViewCell : UITableViewCell
@property (weak,nonatomic) id<MyQuestionDetailTableViewCellDelegate> delegate;
-(void)loadCell:(NSDictionary*)dic AndIsSolve:(NSInteger)solve;

@end
