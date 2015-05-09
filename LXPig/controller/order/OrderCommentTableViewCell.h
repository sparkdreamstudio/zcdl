//
//  OrderCommentTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/7.
//
//

#import <UIKit/UIKit.h>

@interface CommentObject : NSObject

@property (assign,nonatomic)long long keyId;
@property (strong,nonatomic)NSString* name;
@property (strong,nonatomic)NSString* smallImg;
@property (strong,nonatomic)NSNumber* salePrice;
@property (strong,nonatomic)NSNumber* saleCnt;
@property (assign,nonatomic)NSInteger serviceStar;
@property (assign,nonatomic)NSInteger ruttingStar;
@property (assign,nonatomic)NSInteger priceStar;
@property (strong,nonatomic)NSString* content;
@property (strong,nonatomic)NSString* label;

@end

@class OrderCommentTableViewCell;

@protocol OrderCommentTableViewCellDelegate <NSObject>

-(void)orderCommentCell:(OrderCommentTableViewCell*)cell WithContent:(NSString*)content;
-(void)orderCommentCell:(OrderCommentTableViewCell *)cell WithRatingTag:(NSInteger)tag AndRating:(CGFloat)rating;
-(void)orderCommentCell:(OrderCommentTableViewCell *)cell WithTagButtonClick:(UIButton*)button;

@end

@interface OrderCommentTableViewCell : UITableViewCell

@property (weak,nonatomic) id<OrderCommentTableViewCellDelegate> delegate;

-(void)loadData:(CommentObject*)object;

@end
