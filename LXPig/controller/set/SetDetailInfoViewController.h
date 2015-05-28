//
//  SetDetailInfoViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/28.
//
//

#import "LxPigViewController.h"

@interface SetDetailInfoViewController : LxPigViewController
@property (weak,nonatomic)NSString* htmlString;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSDictionary* dic;
@end
