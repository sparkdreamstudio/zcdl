//
//  ExhibitionListTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import <UIKit/UIKit.h>

@interface ExhibitionListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *exhibitionImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
