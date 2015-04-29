//
//  CartTableViewCellHead.h
//  LXPig
//
//  Created by leexiang on 15/4/27.
//
//

#import <UIKit/UIKit.h>

@class CartTableViewCellHead;

@protocol CartTableViewCellHeadDelegate <NSObject>

-(void)cartTableViewCellHead:(CartTableViewCellHead*)head isCheck:(BOOL)checked;

@end


@interface CartTableViewCellHead : UITableViewCell

@property (weak, nonatomic) id<CartTableViewCellHeadDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end
