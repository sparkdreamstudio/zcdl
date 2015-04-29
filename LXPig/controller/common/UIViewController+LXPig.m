//
//  UIViewController+LXPig.m
//  LXPig
//
//  Created by leexiang on 15/4/14.
//
//

#import "UIViewController+LXPig.h"

@implementation UIViewController (LXPig)



- (JGProgressHUD *)prototypeHUD {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    HUD.delegate = self;
    
    //HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    
    return HUD;
}

-(void)showNormalHudDimissWithString:(NSString*)string
{
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD = [self prototypeHUD];
    HUD.textLabel.text = string;
//    HUD.square = YES;
    [HUD showInView:self.view];
    [HUD dismissAfterDelay:1];
}

-(void)showErrorHudDimissWithString:(NSString*)string
{
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD = [self prototypeHUD];
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    HUD.textLabel.text = string;
//    HUD.square = YES;
    [HUD showInView:self.view];
    [HUD dismissAfterDelay:1];
}

-(UIView*)showNormalHudNoDimissWithString:(NSString*)string
{
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD = [self prototypeHUD];
    HUD.textLabel.text = string;
    //HUD.square = YES;
    [HUD showInView:self.view];
    
    return HUD;
}

-(void)dismissHUD:(UIView*)hud WithSuccessString:(NSString*)string
{
    JGProgressHUD* HUD = (JGProgressHUD*)hud;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
        HUD.textLabel.text = string;
    });
    [HUD dismissAfterDelay:1];
}
-(void)dismissHUD:(UIView*)hud WithErrorString:(NSString*)string
{
    JGProgressHUD* HUD = (JGProgressHUD*)hud;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
        HUD.textLabel.text = string;
    });
    [HUD dismissAfterDelay:1];
}

-(void)dismissHUD:(UIView *)hud
{
    JGProgressHUD* HUD = (JGProgressHUD*)hud;
    [HUD dismiss];
}

//-(UIView*)showErrorHudNoDimissWithString:(NSString*)string
//{
//    JGProgressHUD *HUD = [self prototypeHUD];
//    HUD = [self prototypeHUD];
//    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
//    HUD.textLabel.text = string;
//    HUD.square = YES;
//    [HUD showInView:self.view];
//    
//    return HUD;
//}



@end
