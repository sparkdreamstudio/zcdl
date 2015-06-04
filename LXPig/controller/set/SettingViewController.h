//
//  SettingViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/14.
//
//

#import "LxPigViewController.h"

@interface SettingViewController : LxPigViewController
@property (strong,nonatomic) IBOutlet NSLayoutConstraint* topContraint;
@property (assign,nonatomic) NSInteger topContraintHeight;
@property (assign,nonatomic) BOOL pushView;
@end
