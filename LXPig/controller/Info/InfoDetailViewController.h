//
//  InfoDetailViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/11.
//
//

#import <UIKit/UIKit.h>

@interface InfoDetailViewController : LxPigViewController
@property (weak,nonatomic)NSString* htmlString;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSDictionary* dic;
@end
