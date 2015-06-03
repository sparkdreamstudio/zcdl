//
//  RightMenuViewController.h
//  LXPig
//
//  Created by 李响 on 15/6/1.
//
//

#import <UIKit/UIKit.h>
@class SlideViewController;
@interface RightMenuViewController : UIViewController

@property (weak,nonatomic)SlideViewController* slideController;
@property (weak,nonatomic) IBOutlet UIImageView* blurImageView;
@end
