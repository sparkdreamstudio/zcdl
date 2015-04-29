//
//  CommentTagCell.h
//  LXPig
//
//  Created by leexiang on 15/4/23.
//
//

#import <UIKit/UIKit.h>
@class SKTagView;
@interface CommentTagCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SKTagView *tagView;
@property (weak, nonatomic) IBOutlet UIView *bgVIew;

@end
