//
//  LimitPromotionTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/5/19.
//
//

#import <UIKit/UIKit.h>
@class LPLabel;
@interface LimitPromotionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *description1;
@property (weak, nonatomic) IBOutlet UILabel *description2;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *description3;
@property (weak, nonatomic) IBOutlet UILabel *descriptionCount;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *dayCnt;
@property (weak, nonatomic) IBOutlet UILabel *hourCnt;
@property (weak, nonatomic) IBOutlet UILabel *minuteCnt;
@property (weak, nonatomic) IBOutlet UILabel *salePrice;
@property (weak, nonatomic) IBOutlet LPLabel *marketPrice;

-(void)loadCell:(NSDictionary *)dic WithType:(NSInteger)type;

@end
