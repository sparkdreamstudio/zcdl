//
//  UIViewController+LXPig.h
//  LXPig
//
//  Created by leexiang on 15/4/14.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (LXPig)<JGProgressHUDDelegate>



-(void)showNormalHudDimissWithString:(NSString*)string;
-(void)showErrorHudDimissWithString:(NSString*)string;
-(UIView*)showNormalHudNoDimissWithString:(NSString*)string;
-(JGProgressHUD*)showProgressHudNoDimissWithString:(NSString*)string;
-(void)dismissHUD:(UIView*)hud WithSuccessString:(NSString*)string;
-(void)dismissHUD:(UIView*)hud WithErrorString:(NSString*)string;
-(void)dismissHUD:(UIView *)hud;
-(UIImagePickerController*)showImagePickerByType:(UIImagePickerControllerSourceType)type;

//-(UIView*)showErrorHudNoDimissWithString:(NSString*)string;
@end
